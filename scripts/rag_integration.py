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

"""RAG integration entrypoint.

Minimal, robust script to run retrieval (FAISS or simulation), build a prompt,
optionally call a local LLM, write raw logs, attempt JSON extraction and
expand citations by fetching chunk text from Neo4j.
"""

import argparse
import json
import sys
from pathlib import Path
from typing import List

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
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)


def simulate_retrieval(meta: List[dict], limit: int = 5):
    return meta[:limit]


def faiss_retrieval(meta: List[dict], index_path: str, query: str, model_name: str = 'all-MiniLM-L6-v2', topk: int = 5):
    if SentenceTransformer is None or faiss is None or np is None:
        raise RuntimeError('FAISS or sentence-transformers not available in environment')

    idx = faiss.read_index(index_path)
    import torch
    sbert_device = 'cuda' if torch.cuda.is_available() else 'cpu'
    model = SentenceTransformer(model_name, device=sbert_device)
    qemb = model.encode([query], show_progress_bar=False, convert_to_numpy=True)
    qemb = np.array(qemb).astype('float32')
    D, I = idx.search(qemb, topk)
    ids = I[0].tolist() if hasattr(I, '__len__') else list(I)

    retrieved = []
    for ii in ids:
        try:
            retrieved.append(meta[int(ii)])
        except Exception:
            continue

    return retrieved


def parse_args():
    p = argparse.ArgumentParser()
    p.add_argument('--question', required=True)
    p.add_argument('--limit', type=int, default=5)
    p.add_argument('--use-faiss', action='store_true')
    p.add_argument('--faiss-index', default='data/faiss_tei.index')
    p.add_argument('--faiss-meta', default='data/faiss_tei_meta.json')
    p.add_argument('--use-full-text', action='store_true', help='Load full chunk text from data/tei_training_data.jsonl and use it in prompts')
    p.add_argument('--call-llm', action='store_true')
    p.add_argument('--llm-model', default='kakaocorp/kanana-nano-2.1b-base')
    p.add_argument('--force-json', action='store_true')
    p.add_argument('--max-new-tokens', type=int, default=2048)
    p.add_argument('--temperature', type=float, default=0.0)
    p.add_argument('--max-context-chars', type=int, default=8000, help='Max characters of concatenated context to include in the prompt')
    p.add_argument('--trust-remote-code', action='store_true')
    return p.parse_args()


def extract_json_block(s: str):
    # Try several marker styles first (explicit markers are most reliable)
    markers = [('<JSON>', '</JSON>'), ('<<<BEGIN_JSON>>>', '<<<END_JSON>>>'), ('<BEGIN_JSON>', '<END_JSON>')]
    for open_m, close_m in markers:
        si = s.find(open_m)
        ei = s.find(close_m, si + 1) if si != -1 else -1
        if si != -1 and ei != -1:
            return s[si + len(open_m):ei].strip()

    # Try code fence with json
    import re
    m = re.search(r"```json\s*(\{.*?\})\s*```", s, flags=re.S)
    if m:
        return m.group(1).strip()

    # Try triple-backtick generic (take content and attempt to find JSON inside)
    m = re.search(r"```\s*(.*?)\s*```", s, flags=re.S)
    if m:
        inner = m.group(1)
        js = _extract_balanced_braces(inner)
        if js:
            return js

    # Last-resort: find the first balanced JSON object in the entire string
    return _extract_balanced_braces(s)


def _extract_balanced_braces(s: str):
    # Find first '{' and extract a balanced JSON object by tracking depth.
    start = s.find('{')
    if start == -1:
        return None
    depth = 0
    in_string = False
    escape = False
    for i in range(start, len(s)):
        ch = s[i]
        if in_string:
            if escape:
                escape = False
            elif ch == '\\':
                escape = True
            elif ch == '"':
                in_string = False
            # otherwise continue inside string
        else:
            if ch == '"':
                in_string = True
            elif ch == '{':
                depth += 1
            elif ch == '}':
                depth -= 1
                if depth == 0:
                    return s[start:i+1]
    return None


def heuristic_extract(s: str):
    import re
    cit_pat = re.compile(r"\[(?:source|graph):[^\]]+\]")
    citations = cit_pat.findall(s)
    citations = [c.strip()[1:-1] for c in citations]
    text = cit_pat.sub('', s).strip()
    sentences = re.split(r'(?<=[.!?])\s+', text)
    answer = ' '.join(sentences[:2]).strip()
    return {'answer': answer or "I don't know based on the provided sources.", 'citations': citations}


def main():
    args = parse_args()

    meta_path = args.faiss_meta
    if not Path(meta_path).exists():
        print('Meta file not found:', meta_path)
        return

    meta = load_meta(meta_path)

    # if requested, load matching full texts for the retrieved ids from training JSONL
    def load_full_texts_for(retrieved, training_path='data/tei_training_data.jsonl'):
        # build lookup set of (path, chunk_index)
        need = {(r.get('path'), r.get('chunk_index')) for r in retrieved}
        out = {}
        tp = Path(training_path)
        if not tp.exists():
            return out
        try:
            with open(tp, 'r', encoding='utf-8') as f:
                for line in f:
                    try:
                        rec = json.loads(line)
                    except Exception:
                        continue
                    key = (rec.get('path'), rec.get('chunk_index'))
                    if key in need:
                        out[key] = rec.get('text')
                        if len(out) == len(need):
                            break
        except Exception:
            return out
        return out

    if args.use_faiss:
        retrieved = faiss_retrieval(meta, args.faiss_index, args.question, topk=args.limit)
    else:
        retrieved = simulate_retrieval(meta, limit=args.limit)

    print('\n=== Retrieved chunks ===\n')
    print(json.dumps(retrieved, ensure_ascii=False, indent=2)[:4000])

    if args.use_full_text:
        fulls = load_full_texts_for(retrieved)
        for r in retrieved:
            key = (r.get('path'), r.get('chunk_index'))
            if key in fulls:
                r['excerpt'] = fulls[key]

    prompt = build_prompt(args.question, retrieved, neo4j_facts=[], max_context_chars=args.max_context_chars)

    if args.call_llm:
        raw_out_log = []
        last_llm_exception = None
        out = ''

        try:
            from llm_local import generate_from_prompt

            def run_llm_once(pmt, gen_kwargs=None, temp=None):
                gen_kwargs = gen_kwargs or {}
                try:
                    out_text = generate_from_prompt(
                        pmt,
                        model_name=args.llm_model,
                        max_new_tokens=args.max_new_tokens,
                        trust_remote_code=args.trust_remote_code,
                        temperature=(temp if temp is not None else args.temperature),
                        **gen_kwargs,
                    )
                except TypeError:
                    out_text = generate_from_prompt(
                        pmt,
                        model_name=args.llm_model,
                        max_new_tokens=args.max_new_tokens,
                        trust_remote_code=args.trust_remote_code,
                        **gen_kwargs,
                    )
                raw_out_log.append(out_text)
                return out_text

            # Build a compact example JSON based on the first retrieved chunk to encourage
            # the model to produce context-aware answers instead of blindly copying a static example.
            example_json = None
            if retrieved and isinstance(retrieved, list) and len(retrieved) > 0:
                first = retrieved[0]
                fid = first.get('id') or f"{first.get('path')}::chunk::{first.get('chunk_index')}"
                # create a short example answer using a snippet of excerpt
                ex_snip = (first.get('excerpt') or '')
                ex_snip = ex_snip.replace('\n', ' ')[:200].strip()
                # sanitize quotes for safe embedding
                safe_snip = ex_snip[:120].replace('"', '\\"')
                fid_str = str(fid)
                example_json = '<JSON>{"answer": "' + safe_snip + '", "citations": ["[source:' + fid_str + ']"]}</JSON>'

            json_instructions = (
                "\n\nIMPORTANT: Your response MUST START with the literal marker <JSON> and END with </JSON>.\n"
                "Output ONLY a single well-formed JSON object between these markers with keys: \"answer\" (string) and \"citations\" (array of strings).\n"
                "Do not output any additional commentary before, after, or outside the markers.\n"
            )

            if example_json:
                json_instructions += "Example (based on the first retrieved chunk):\n" + example_json + "\n\n"

            prompt_json = prompt + json_instructions if args.force_json else prompt

            # Stage 1: deterministic
            gen_kwargs_stage1 = dict(do_sample=False, num_beams=1)
            try:
                out = run_llm_once(prompt_json, gen_kwargs=gen_kwargs_stage1, temp=0.0)
            except Exception as e:
                print('Stage1 LLM failed:', e)
                out = ''

            def has_citations(s: str):
                return ('[source:' in s) or ('[graph:' in s) or ('<JSON>' in s and '</JSON>' in s)

            if args.force_json and not has_citations(out):
                try:
                    short_retrieved = retrieved[:2]
                    short_prompt = build_prompt(args.question, short_retrieved, neo4j_facts=[])
                    short_prompt += json_instructions
                    out = run_llm_once(short_prompt, gen_kwargs=gen_kwargs_stage1, temp=0.0)
                except Exception:
                    pass

            if args.force_json and not has_citations(out):
                gen_kwargs_stage3 = dict(do_sample=True, top_k=50, top_p=0.95)
                try:
                    out = run_llm_once(prompt_json, gen_kwargs=gen_kwargs_stage3, temp=0.1)
                except Exception:
                    pass

        except Exception as e:
            last_llm_exception = e
            print('LLM call failed:', e)

        # write raw outputs
        try:
            import datetime
            logpath = Path('logs')
            logpath.mkdir(exist_ok=True)
            fname = logpath / f"llm_raw_{args.llm_model.replace('/', '_')}_{int(datetime.datetime.now().timestamp())}.txt"
            with open(fname, 'w', encoding='utf-8') as lf:
                lf.write('\n--- RAW OUTPUTS ---\n')
                if raw_out_log:
                    for i, r in enumerate(raw_out_log):
                        lf.write(f'-- run {i} --\n')
                        lf.write(r + '\n\n')
                else:
                    lf.write('(no raw outputs captured)\n')
                if last_llm_exception is not None:
                    lf.write('\n--- EXCEPTION ---\n')
                    lf.write(repr(last_llm_exception) + '\n')
            print('Wrote raw LLM outputs to', fname)
        except Exception as _e:
            print('Failed to write LLM raw log:', _e)

        # parse
        parsed = None
        if args.force_json:
            js = extract_json_block(out)
            if js:
                try:
                    parsed = json.loads(js)
                    print('\n=== LLM OUTPUT (parsed JSON) ===\n')
                    print(json.dumps(parsed, ensure_ascii=False, indent=2))
                except Exception:
                    parsed = heuristic_extract(out)
                    print('\n=== LLM OUTPUT (heuristic parsed) ===\n')
                    print(json.dumps(parsed, ensure_ascii=False, indent=2))
            else:
                parsed = heuristic_extract(out)
                print('\n=== LLM OUTPUT (heuristic parsed) ===\n')
                print(json.dumps(parsed, ensure_ascii=False, indent=2))
        else:
            print('\n=== LLM OUTPUT ===\n')
            print(out)

        # expand citations
        try:
            if isinstance(parsed, dict):
                cita = parsed.get('citations', [])

                def normalize_citation_to_chunk_id(cit: str):
                    s = cit.strip()
                    if s.startswith('[') and s.endswith(']'):
                        s = s[1:-1].strip()
                    if ':' in s:
                        prefix, rest = s.split(':', 1)
                        s = rest.strip()

                    if '::chunk::' in s:
                        return s

                    try:
                        maybe_idx = int(s)
                        for m in meta:
                            if m.get('chunk_index') == maybe_idx:
                                return f"{m.get('path')}::chunk::{maybe_idx}"
                    except Exception:
                        pass

                    return s

                ids_to_lookup = [normalize_citation_to_chunk_id(c) for c in cita if c]
                if ids_to_lookup:
                    rows = get_chunks_by_ids(create_driver(), ids_to_lookup)
                    print('\n=== CITED SOURCES (expanded) ===\n')
                    print(json.dumps(rows, ensure_ascii=False, indent=2))
                else:
                    print('No normalized citation ids to lookup')
        except Exception as _e:
            print('Failed to expand citations:', _e)


if __name__ == '__main__':
    main()

