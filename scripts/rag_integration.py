"""RAG integration entrypoint.

This script orchestrates a simple retrieval-augmented generation flow used in
the project. It wires together the FAISS-based retriever, the prompt builder,
Neo4j helpers and the local LLM wrapper. The module is documented to help
future maintainers understand the expected inputs and outputs.
"""

import argparse
import json
import os
import sys
from pathlib import Path
from typing import List, Optional

# ensure scripts/ is importable when running from repo root
ROOT = Path(__file__).resolve().parents[1]
SCRIPTS_DIR = ROOT / "scripts"
sys.path.insert(0, str(SCRIPTS_DIR))

from rag_prompt_builder import build_prompt
from neo4j_helpers import create_driver, get_chunks_by_ids

try:
    from sentence_transformers import SentenceTransformer
    import numpy as np
    import faiss
except Exception:
    SentenceTransformer = None
    np = None
    faiss = None


def load_meta(path: str) -> List[dict]:
    """Load the FAISS metadata JSON file produced by build_tei_faiss.py.

    The metadata is expected to be a list of chunk dicts containing at least
    the fields: 'id', 'path', 'chunk_index', 'excerpt'.
    """
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)


def simulate_retrieval(meta: List[dict], limit: int = 5):
    """Return the first `limit` entries from meta.

    This helper is intentionally tiny and used when FAISS is not available
    during quick local testing. Production runs should use `faiss_retrieval`.
    """
    return meta[:limit]


def faiss_retrieval(meta: List[dict], index_path: str, query: str, model_name: str = 'all-MiniLM-L6-v2', topk: int = 5):
    """Retrieve nearest chunks from FAISS index for `query`.

    Returns a list of meta entries corresponding to the nearest neighbors.
    """
    if SentenceTransformer is None or faiss is None or np is None:
        raise RuntimeError('FAISS or sentence-transformers not available in environment')

    idx = faiss.read_index(index_path)
    model = SentenceTransformer(model_name)
    qemb = model.encode([query], show_progress_bar=False)
    qemb = np.array(qemb).astype('float32')
    D, I = idx.search(qemb, topk)
    ids = []
    scores = []
    for i, sc in zip(I[0], D[0]):
        if i < 0 or i >= len(meta):
            continue
        ids.append(meta[i])
        scores.append(float(sc))
    # attach score to returned chunks
    for c, s in zip(ids, scores):
        c['score'] = s
    return ids


def fetch_graph_facts(driver, chunk_list: List[dict]):
    ids = [str(c.get('id')) for c in chunk_list if c.get('id') is not None]
    # get_chunks_by_ids returns properties of the chunk nodes
    if not ids:
        return []
    rows = get_chunks_by_ids(driver, ids)
    # Simplify to summaries: pick excerpt or other props
    facts = []
    for r in rows:
        facts.append({
            'id': r.get('id'),
            'summary': (r.get('excerpt') or '')[:300]
        })
    return facts


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--meta-file', default='data/faiss_tei_meta.json')
    p.add_argument('--question', required=True)
    p.add_argument('--limit', type=int, default=5)
    p.add_argument('--use-faiss', action='store_true', help='Use FAISS index for retrieval')
    p.add_argument('--faiss-index', default='data/faiss_tei.index', help='Path to FAISS index file')
    p.add_argument('--embed-model', default='all-MiniLM-L6-v2', help='SentenceTransformer model to use for embeddings')
    p.add_argument('--call-llm', action='store_true', help='Call local HF model with the built prompt')
    p.add_argument('--llm-model', default='kakaocorp/kanana-nano-2.1b-base', help='Hugging Face model name for local generation')
    p.add_argument('--max-new-tokens', type=int, default=128)
    p.add_argument('--temperature', type=float, default=0.7)
    p.add_argument('--trust-remote-code', action='store_true', help='Pass trust_remote_code=True when loading HF model')
    p.add_argument('--force-json', action='store_true', help='Ask LLM to output JSON and parse it')
    args = p.parse_args()

    meta = load_meta(args.meta_file)
    if args.use_faiss:
        retrieved = faiss_retrieval(meta, args.faiss_index, args.question, model_name=args.embed_model, topk=args.limit)
    else:
        retrieved = simulate_retrieval(meta, args.limit)

    pw = os.environ.get('NEO4J_PASSWORD')
    if not pw:
        raise RuntimeError('Set NEO4J_PASSWORD env to run this integration dry-run')

    driver = create_driver(password=pw)
    graph_facts = fetch_graph_facts(driver, retrieved)

    prompt = build_prompt(args.question, retrieved, graph_facts)
    print(prompt)

    if args.call_llm:
        try:
            from llm_local import generate_from_prompt

            raw_out_log = []

            def run_llm_once(pmt, gen_kwargs=None, temp=None):
                gen_kwargs = gen_kwargs or {}
                try:
                    out_text = generate_from_prompt(pmt, model_name=args.llm_model, max_new_tokens=args.max_new_tokens, trust_remote_code=args.trust_remote_code, temperature=(temp if temp is not None else args.temperature), **gen_kwargs)
                except TypeError:
                    # older generate API might not accept temperature when do_sample=False; try without temperature
                    out_text = generate_from_prompt(pmt, model_name=args.llm_model, max_new_tokens=args.max_new_tokens, trust_remote_code=args.trust_remote_code, **gen_kwargs)
                raw_out_log.append(out_text)
                return out_text

            # Stronger JSON enforcement instructions (ask output to START with marker)
            json_instructions = (
                "\n\nIMPORTANT: Your response MUST START with the literal marker <JSON> and end with </JSON>. "
                "Output ONLY a single well-formed JSON object between these markers with keys: \"answer\" (string) and \"citations\" (array of strings).\n"
                "Example exactly (including markers): <JSON>{\"answer\": \"short answer\", \"citations\": [\"source:tei/schema/...::chunk::12\"]}</JSON>\n"
            )

            # Prepare the prompt(s)
            if args.force_json:
                prompt_json = prompt + json_instructions
            else:
                prompt_json = prompt

            # Stage 1: deterministic attempt (greedy/beam with no sampling)
            gen_kwargs_stage1 = dict(do_sample=False, num_beams=1)
            try:
                out = run_llm_once(prompt_json, gen_kwargs=gen_kwargs_stage1, temp=0.0)
            except Exception as e:
                print('Stage1 LLM failed:', e)
                out = ''

            # If no citation patterns and force_json was requested, try stricter retries
            def has_citations(s: str):
                return ('[source:' in s) or ('[graph:' in s) or ('<JSON>' in s and '</JSON>' in s)

            if args.force_json and not has_citations(out):
                # Stage 2: try again with a shorter context: only keep top-2 retrieved chunks
                try:
                    short_retrieved = retrieved[:2]
                    short_prompt = build_prompt(args.question, short_retrieved, graph_facts)
                    short_prompt += json_instructions
                    out = run_llm_once(short_prompt, gen_kwargs=gen_kwargs_stage1, temp=0.0)
                except Exception:
                    pass

            # Stage 3: fall back to sampling with low temperature (if still nothing)
            if args.force_json and not has_citations(out):
                gen_kwargs_stage3 = dict(do_sample=True, top_k=50, top_p=0.95)
                try:
                    out = run_llm_once(prompt_json, gen_kwargs=gen_kwargs_stage3, temp=0.1)
                except Exception:
                    pass

            # Save raw outputs to a log file for debugging
            try:
                import datetime
                logpath = Path('logs')
                logpath.mkdir(exist_ok=True)
                fname = logpath / f"llm_raw_{args.llm_model.replace('/', '_')}_{int(datetime.datetime.now().timestamp())}.txt"
                with open(fname, 'w', encoding='utf-8') as lf:
                    lf.write('\n--- RAW OUTPUTS ---\n')
                    for i, r in enumerate(raw_out_log):
                        lf.write(f'-- run {i} --\n')
                        lf.write(r + '\n\n')
                print('Wrote raw LLM outputs to', fname)
            except Exception as _e:
                print('Failed to write LLM raw log:', _e)

            # Proceed to parsing as before
            parsed = None
            if args.force_json:
                import json as _json
                # try direct parse
                try:
                    parsed = _json.loads(out)
                    print('\n=== LLM OUTPUT (parsed JSON) ===\n')
                    print(_json.dumps(parsed, ensure_ascii=False, indent=2))
                except Exception:
                    # helper: balanced braces
                    def extract_json(s: str):
                        start = s.find('{')
                        if start == -1:
                            return None
                        depth = 0
                        for i in range(start, len(s)):
                            if s[i] == '{':
                                depth += 1
                            elif s[i] == '}':
                                depth -= 1
                                if depth == 0:
                                    return s[start:i+1]
                        return None

                    def extract_between_markers(s: str, start_marker: str, end_marker: str):
                        si = s.find(start_marker)
                        ei = s.find(end_marker, si+len(start_marker))
                        if si != -1 and ei != -1:
                            return s[si+len(start_marker):ei]
                        return None

                    marked = extract_between_markers(out, '<JSON>', '</JSON>')
                    candidate = marked or extract_json(out)

                    if candidate:
                        try:
                            parsed = _json.loads(candidate)
                            print('\n=== LLM OUTPUT (extracted JSON) ===\n')
                            print(_json.dumps(parsed, ensure_ascii=False, indent=2))
                        except Exception:
                            # heuristic fallback
                            def heuristic_extract(s: str):
                                import re
                                cit_pat = re.compile(r"\[(?:source|graph):[^\]]+\]")
                                citations = cit_pat.findall(s)
                                citations = [c.strip()[1:-1] for c in citations]
                                text = cit_pat.sub('', s).strip()
                                import re as _re
                                sentences = _re.split(r'(?<=[.!?])\s+', text)
                                answer = ' '.join(sentences[:2]).strip()
                                return {'answer': answer or "I don't know based on the provided sources.", 'citations': citations}

                            parsed = heuristic_extract(out)
                            print('\n=== LLM OUTPUT (heuristic parsed) ===\n')
                            print(_json.dumps(parsed, ensure_ascii=False, indent=2))
                    else:
                        def heuristic_extract(s: str):
                            import re
                            cit_pat = re.compile(r"\[(?:source|graph):[^\]]+\]")
                            citations = cit_pat.findall(s)
                            citations = [c.strip()[1:-1] for c in citations]
                            import re as _re
                            text = cit_pat.sub('', s).strip()
                            sentences = _re.split(r'(?<=[.!?])\s+', text)
                            answer = ' '.join(sentences[:2]).strip()
                            return {'answer': answer or "I don't know based on the provided sources.", 'citations': citations}

                        parsed = heuristic_extract(out)
                        print('\n=== LLM OUTPUT (heuristic parsed) ===\n')
                        import json as _json2
                        print(_json2.dumps(parsed, ensure_ascii=False, indent=2))
            else:
                print('\n=== LLM OUTPUT ===\n')
                print(out)

            # After parsing, expand citations by fetching chunk text
            try:
                if isinstance(parsed, dict):
                    cita = parsed.get('citations', [])

                    def normalize_citation_to_chunk_id(cit: str):
                        # remove surrounding brackets/spaces
                        s = cit.strip()
                        if s.startswith('[') and s.endswith(']'):
                            s = s[1:-1].strip()
                        # strip known prefixes
                        if ':' in s:
                            prefix, rest = s.split(':', 1)
                            # if rest itself contains another prefix (rare), keep the rest
                            s = rest.strip()

                        # If already looks like full chunk id (path::chunk::idx)
                        if '::chunk::' in s:
                            # handle ellipsis '...' inside path by trying to match against meta
                            path_part, idx_part = s.split('::chunk::', 1)
                            try:
                                idx = int(idx_part)
                            except Exception:
                                idx = None

                            # exact path match
                            if idx is not None:
                                # try exact path
                                for m in meta:
                                    if m.get('path') == path_part:
                                        return f"{m.get('path')}::chunk::{idx}"

                                # try contains match (handle collapsed '...')
                                path_frag = path_part.replace('...', '').strip()
                                if path_frag:
                                    for m in meta:
                                        if path_frag in (m.get('path') or '') and m.get('chunk_index') == idx:
                                            return f"{m.get('path')}::chunk::{idx}"

                                # fallback: find any meta with chunk_index==idx
                                for m in meta:
                                    if m.get('chunk_index') == idx:
                                        return f"{m.get('path')}::chunk::{idx}"

                        # If s is numeric, find by chunk_index (best-effort)
                        try:
                            maybe_idx = int(s)
                            for m in meta:
                                if m.get('chunk_index') == maybe_idx:
                                    return f"{m.get('path')}::chunk::{maybe_idx}"
                        except Exception:
                            pass

                        # As a last resort, return s unchanged
                        return s

                    ids_to_lookup = []
                    for c in cita:
                        nid = normalize_citation_to_chunk_id(c)
                        if nid:
                            ids_to_lookup.append(nid)

                    if ids_to_lookup:
                        rows = get_chunks_by_ids(driver, ids_to_lookup)
                        print('\n=== CITED SOURCES (expanded) ===\n')
                        import json as _j
                        print(_j.dumps(rows, ensure_ascii=False, indent=2))
                    else:
                        print('No normalized citation ids to lookup')
            except Exception as _e:
                print('Failed to expand citations:', _e)
        except Exception as e:
            print('LLM call failed:', e)


if __name__ == '__main__':
    main()
 
