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
from neo4j_helpers import create_driver, get_chunks_by_ids, get_related_facts

try:
    # Cross-encoder for re-ranking (optional)
    from sentence_transformers.cross_encoder import CrossEncoder
except Exception:
    CrossEncoder = None

try:
    # We still import modules conditionally; embedder instances should be acquired
    # via scripts.embedder_cache.get_cached_embedder() to avoid repeated loads.
    import numpy as np
    import faiss
    SentenceTransformer = True
except Exception:
    SentenceTransformer = None
    np = None
    faiss = None


# --- Embedded TeiFaissWithNeo4j implementation (merged from scripts/tei_faiss_with_neo4j.py)
from dataclasses import dataclass
from enum import Enum
import re
from typing import Tuple, Dict
from neo4j import GraphDatabase
from scripts.utils import get_neo4j_credentials, get_cached_embedder


class QueryType(Enum):
    STRUCTURE = "structure"
    SEMANTIC = "semantic"
    HYBRID = "hybrid"


class ConfidenceLevel(Enum):
    STRUCTURE = "구조 기반 ✅"
    SEMANTIC = "의미 기반 ⚡"
    HYBRID = "혼합 기반 ⭐"


@dataclass
class Element:
    id: str
    file_id: str
    tag: str
    text: str
    attributes: Dict
    chunk_index: int
    embedding: Optional[List[float]] = None
    embedding_dim: Optional[int] = None


@dataclass
class SearchResult:
    elements: List[Element]
    query_type: QueryType
    confidence: ConfidenceLevel
    confidence_score: float
    explanation: str


class TeiFaissWithNeo4j:
    def __init__(
        self,
        neo4j_uri: Optional[str] = None,
        neo4j_user: Optional[str] = None,
        neo4j_password: Optional[str] = None,
        faiss_index_path: str = "data/faiss_tei.index",
        faiss_meta_path: str = "data/faiss_tei_meta.json",
    ):
        creds = get_neo4j_credentials()
        uri = neo4j_uri or creds.get("uri")
        user = neo4j_user or creds.get("user")
        pwd = neo4j_password or creds.get("password")

        self._driver = None
        try:
            if uri:
                if user and pwd:
                    auth = (user, pwd)
                    self._driver = GraphDatabase.driver(uri, auth=auth)
                else:
                    # no auth provided
                    self._driver = GraphDatabase.driver(uri)
        except Exception:
            self._driver = None

        self.faiss_index_path = faiss_index_path
        self.faiss_meta_path = faiss_meta_path
        self.index = None
        self.meta = []
        if Path(self.faiss_meta_path).exists():
            try:
                with open(self.faiss_meta_path, "r", encoding="utf-8") as f:
                    self.meta = json.load(f)
            except Exception:
                self.meta = []

        if faiss is not None and Path(self.faiss_index_path).exists():
            try:
                self.index = faiss.read_index(self.faiss_index_path)
            except Exception:
                self.index = None

        # embedder is lazy
        self._embedder = None

    def _ensure_embedder(self):
        if self._embedder is None:
            try:
                self._embedder = get_cached_embedder()
            except Exception:
                self._embedder = None
        return self._embedder

    def close(self):
        if self._driver:
            try:
                self._driver.close()
            except Exception:
                pass

    # -------------------- classify_query --------------------
    def classify_query(self, query: str) -> Tuple[QueryType, Dict]:
        q = query.lower()
        meta: Dict = {"structure_keywords": [], "element_tags": [], "numbers": []}

        # detect numbers (chapter/act numbers)
        nums = re.findall(r"\b(?:chapter|act|scene)\s*(\d+)\b", q)
        if nums:
            meta["numbers"] = [int(n) for n in nums]

        # detect structure keywords
        for k in ["chapter", "act", "scene", "section"]:
            if k in q:
                meta["structure_keywords"].append(k)

        # detect element tags
        for tag in ["note", "persname", "date", "div", "body", "line", "p"]:
            if tag in q:
                meta["element_tags"].append(tag)

        # heuristics to classify
        has_struct = bool(meta["structure_keywords"] or meta["numbers"])
        has_tag = bool(meta["element_tags"])
        has_sem = True
        # if contains structure indicators -> hybrid
        if has_struct and has_sem:
            qtype = QueryType.HYBRID
        elif has_struct:
            qtype = QueryType.STRUCTURE
        else:
            qtype = QueryType.SEMANTIC

        return qtype, meta

    # -------------------- Neo4j structure search --------------------
    def neo4j_structure_search(self, file_id: str, structure_metadata: Dict) -> List[Element]:
        if not self._driver:
            raise RuntimeError("Neo4j driver not configured")

        # Pattern: Chapter N notes
        numbers = structure_metadata.get("numbers") or []
        tags = structure_metadata.get("element_tags") or []

        results: List[Element] = []
        with self._driver.session() as s:
            if numbers and ("chapter" in structure_metadata.get("structure_keywords", [])):
                # Best-effort: match div elements that likely represent chapters, then traverse ELEMENT_CHILD
                num = numbers[0]
                cy = (
                    "MATCH (f:File {id:$file_id})-[:CONTAINS]->(chapter:Element)"
                    " WHERE toLower(chapter.tag) = 'div'"
                    " WITH chapter"
                    " MATCH (chapter)-[:ELEMENT_CHILD*0..15]->(note:Element)"
                    " WHERE toLower(note.tag) = 'note'"
                    " RETURN note, chapter"
                )
                recs = s.run(cy, file_id=file_id)
                for r in recs:
                    n = r["note"]
                    results.append(self._record_to_element(n))
                return results

            # generic tag search within file
            if tags:
                tag = tags[0]
                cy = (
                    "MATCH (f:File {id:$file_id})-[:CONTAINS]->(e:Element)"
                    " WHERE toLower(e.tag) = $tag"
                    " RETURN e ORDER BY e.xpath"
                )
                recs = s.run(cy, file_id=file_id, tag=tag.lower())
                for r in recs:
                    results.append(self._record_to_element(r["e"]))
                return results

            # fallback: return empty
            return []

    def _record_to_element(self, node) -> Element:
        # node may be a neo4j Node or mapping-like
        try:
            props = dict(node.items())
        except Exception:
            # try attribute access
            props = {}
            for k in ["id", "file_id", "tag", "text", "attributes", "chunk_index", "embedding"]:
                props[k] = node.get(k) if hasattr(node, 'get') else None

        eid = props.get("id") or ""
        file_id = props.get("file_id") or props.get("file") or ""
        tag = props.get("tag") or ""
        text = props.get("text") or ""
        attributes = props.get("attributes") or {}
        # attributes may be stored as a JSON string; try to parse
        try:
            if isinstance(attributes, str) and attributes.strip():
                import json as _json
                attributes = _json.loads(attributes)
        except Exception:
            # leave as original string if parse fails
            pass
        # Ensure attributes is a dict for type-checkers and downstream code
        if not isinstance(attributes, dict):
            attributes = {}
        chunk_index = int(props.get("chunk_index") or 0)
        emb = props.get("embedding")
        emb_dim = None
        try:
            tmp = props.get("embedding_dim")
            if isinstance(tmp, int):
                emb_dim = int(tmp)
            elif isinstance(tmp, str) and tmp.isdigit():
                emb_dim = int(tmp)
            elif emb:
                emb_dim = len(emb)
        except Exception:
            emb_dim = None
        return Element(id=eid, file_id=file_id, tag=tag, text=text, attributes=attributes, chunk_index=chunk_index, embedding=emb, embedding_dim=emb_dim)

    # -------------------- FAISS semantic search --------------------
    def faiss_semantic_search(self, query: str, top_k: int = 50, similarity_threshold: float = 0.55) -> List[Element]:
        if self.index is None or np is None:
            raise RuntimeError("FAISS index or numpy not available")

        emb = self._ensure_embedder()
        if emb is None:
            raise RuntimeError("Embedder unavailable")

        qv = emb.encode([query], convert_to_numpy=True)
        qv = np.array(qv).astype('float32')
        try:
            D, I = self.index.search(qv, top_k)
        except Exception as e:
            raise

        hits: List[Element] = []
        # D may be distances; convert to similarity heuristic
        for dist, idx in zip(D[0], I[0]):
            if idx < 0 or idx >= len(self.meta):
                continue
            sim = 1.0 / (1.0 + float(dist)) if dist is not None else 0.0
            if sim < similarity_threshold:
                continue
            m = self.meta[int(idx)]
            e = Element(
                id=m.get('id') or f"{m.get('path')}::chunk::{m.get('chunk_index')}",
                file_id=m.get('path'),
                tag=m.get('tag', ''),
                # meta may use 'excerpt' (from build_tei_faiss) or 'text'/'text_snippet'
                text=m.get('excerpt') or m.get('text_snippet') or m.get('text') or '',
                attributes=m.get('attributes') or {},
                chunk_index=int(m.get('chunk_index') or 0),
                embedding=None,
                embedding_dim=None,
            )
            hits.append(e)

        return hits

    # -------------------- Hybrid search --------------------
    def hybrid_search(self, file_id: str, query: str, structure_metadata: Dict) -> List[Element]:
        # 1. Neo4j structural filter -> get chunk indices
        struct_elems = []
        try:
            struct_elems = self.neo4j_structure_search(file_id, structure_metadata)
        except Exception:
            struct_elems = []

        struct_indices = {e.chunk_index for e in struct_elems if e.chunk_index is not None}

        # 2. FAISS semantic search
        sem_elems = []
        try:
            sem_elems = self.faiss_semantic_search(query, top_k=50)
        except Exception:
            sem_elems = []

        sem_indices = {e.chunk_index for e in sem_elems}

        # 3. intersection
        inter = struct_indices & sem_indices

        final: List[Element] = []
        if inter:
            # pick elements from meta that match intersection, preserve chunk_index order
            idxs = sorted(list(inter))
            for ci in idxs:
                # find any matching element from sem_elems or struct_elems
                found = next((e for e in sem_elems if e.chunk_index == ci), None)
                if not found:
                    found = next((e for e in struct_elems if e.chunk_index == ci), None)
                if found:
                    final.append(found)
        else:
            # fallbacks
            if struct_elems:
                final = struct_elems
            else:
                final = sem_elems

        return final

    # -------------------- validate_results --------------------
    def validate_results(self, elements: List[Element], query_type: QueryType) -> Tuple[float, str]:
        if query_type == QueryType.STRUCTURE:
            return 1.0, "구조로 확정된 결과(정확도 매우 높음)"
        if query_type == QueryType.SEMANTIC:
            return 0.85, "FAISS 의미 검색 기반 결과(중간 신뢰도)"
        # hybrid
        return 0.97, "구조 + 의미 결합(고신뢰 결과)"

    # -------------------- search (orchestrator) --------------------
    def search(self, file_id: str, query: str, top_k: int = 20) -> SearchResult:
        qtype, meta = self.classify_query(query)
        if qtype == QueryType.STRUCTURE:
            elems = self.neo4j_structure_search(file_id, meta)
        elif qtype == QueryType.SEMANTIC:
            elems = self.faiss_semantic_search(query, top_k=top_k)
        else:
            elems = self.hybrid_search(file_id, query, meta)

        score, reason = self.validate_results(elems, qtype)
        confidence = (
            ConfidenceLevel.STRUCTURE if qtype == QueryType.STRUCTURE else
            ConfidenceLevel.SEMANTIC if qtype == QueryType.SEMANTIC else
            ConfidenceLevel.HYBRID
        )

        return SearchResult(elements=elems, query_type=qtype, confidence=confidence, confidence_score=score, explanation=reason)

    # -------------------- utilities --------------------
    def format_response(self, result: SearchResult) -> str:
        lines = []
        lines.append("=" * 60)
        lines.append("🔍 검색 결과")
        lines.append("=" * 60)
        lines.append("")
        lines.append("📊 통계:")
        lines.append(f"  • 발견: {len(result.elements)}개 요소")
        lines.append(f"  • 검색 유형: {result.query_type.value}")
        lines.append(f"  • 신뢰도: [{result.confidence.value}] {result.confidence_score*100:.1f}%")
        lines.append(f"  • 이유: {result.explanation}")
        lines.append("")
        lines.append("📝 결과:")
        for i, e in enumerate(result.elements[:20], start=1):
            lines.append(f"  {i}️⃣ 위치: Chunk {e.chunk_index}")
            lines.append(f"     태그: <{e.tag}>")
            lines.append(f"     속성: {e.attributes}")
            snippet = (e.text or "")
            if len(snippet) > 200:
                snippet = snippet[:197] + "..."
            lines.append(f"     내용: {snippet}")
            lines.append("")
        if len(result.elements) > 20:
            lines.append(f"... 외 {len(result.elements)-20}개 (생략)")
        lines.append("=" * 60)
        return "\n".join(lines)

    def to_json(self, result: SearchResult) -> Dict:
        return {
            "elements": [
                {
                    "id": e.id,
                    "file_id": e.file_id,
                    "tag": e.tag,
                    "text": e.text,
                    "attributes": e.attributes,
                    "chunk_index": e.chunk_index,
                }
                for e in result.elements
            ],
            "query_type": result.query_type.value,
            "confidence": result.confidence.value,
            "confidence_score": result.confidence_score,
            "explanation": result.explanation,
        }



def load_meta(path: str) -> List[dict]:
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)


def rerank_chunks(query: str, retrieved: List[dict], model_name: str = 'sentence-transformers/cross-encoder/ms-marco-MiniLM-L-6', top_k: int = 3):
    """Re-rank retrieved chunks using a cross-encoder. Returns top_k chunks in order.

    Falls back to a simple heuristic (original order) when cross-encoder not available.
    """
    if not retrieved:
        return []

    texts = []
    ids = []
    for r in retrieved:
        txt = r.get('excerpt') or r.get('text') or ''
        texts.append(txt)
        ids.append(r)

    # Try cross-encoder first
    try:
        if CrossEncoder is not None:
            model = CrossEncoder(model_name)
            pairs = [[query, t] for t in texts]
            scores = model.predict(pairs)
            scored = list(zip(scores, retrieved))
            scored.sort(key=lambda x: x[0], reverse=True)
            top = [s[1] for s in scored[:top_k]]
            return top
    except Exception:
        pass

    # Fallback: use simple lexical heuristic (keep first top_k)
    return retrieved[:top_k]


def extract_top_sentences(text: str, query: str, n: int = 3, embed_model: Optional[str] = None) -> str:
    """Extract up to n sentences from text most similar to query using SBERT embeddings.

    Returns concatenated sentences as a single string (joined by space).
    Falls back to the first n sentences if embedding model not available.
    """
    import re
    sentences = [s.strip() for s in re.split(r'(?<=[.!?])\s+', text) if s.strip()]
    if not sentences:
        return ''

    try:
        if SentenceTransformer is None:
            raise RuntimeError('no sbert')
        # use embedder cache
        from scripts.utils import get_cached_embedder
        emb = get_cached_embedder(embed_model)
        import numpy as _np
        qv = emb.encode([query], convert_to_numpy=True)[0]
        svecs = emb.encode(sentences, convert_to_numpy=True)
        # cosine similarities
        norms_q = (_np.linalg.norm(qv) or 1.0)
        norms_s = (_np.linalg.norm(svecs, axis=1) + 1e-12)
        sims = (_np.dot(svecs, qv) / (norms_s * norms_q)).tolist()
        ranked_idx = sorted(range(len(sims)), key=lambda i: sims[i], reverse=True)[:n]
        chosen = [sentences[i] for i in ranked_idx]
        return ' '.join(chosen)
    except Exception:
        # fallback: first n sentences
        return ' '.join(sentences[:n])


def simulate_retrieval(meta: List[dict], limit: int = 5):
    return meta[:limit]


def faiss_retrieval(meta: List[dict], index_path: str, query: str, model_name: Optional[str] = None, topk: int = 5):
    if SentenceTransformer is None or faiss is None or np is None:
        raise RuntimeError('FAISS or sentence-transformers not available in environment')
    idx = faiss.read_index(index_path)
    # use cached embedder to avoid repeated model loads
    from scripts.utils import get_cached_embedder
    emb = get_cached_embedder(model_name)
    qemb = emb.encode([query], show_progress_bar=False, convert_to_numpy=True)
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

    print('\n=== Retrieved chunks (raw) ===\n')
    print(json.dumps(retrieved, ensure_ascii=False, indent=2)[:4000])

    # Re-rank retrieved chunks for higher precision
    try:
        reranked = rerank_chunks(args.question, retrieved, top_k=min( max(3, args.limit), len(retrieved) ))
        print('\n=== Retrieved chunks (reranked top) ===\n')
        print(json.dumps(reranked, ensure_ascii=False, indent=2)[:4000])
    except Exception as _e:
        print('Rerank failed, using original retrieved order:', _e)
        reranked = retrieved[:args.limit]

    # Load full texts if compression is requested
    if args.use_full_text:
        fulls = load_full_texts_for(retrieved)
        # compress each of the reranked top-k chunks into 1-3 top sentences
        compressed = []
        for r in reranked:
            key = (r.get('path'), r.get('chunk_index'))
            full_text = fulls.get(key)
            if full_text:
                short = extract_top_sentences(full_text, args.question, n=3)
                r_copy = dict(r)
                r_copy['excerpt'] = short
                compressed.append(r_copy)
            else:
                compressed.append(r)
        print('\n=== Retrieved chunks (compressed top) ===\n')
        print(json.dumps(compressed, ensure_ascii=False, indent=2)[:4000])
    else:
        compressed = reranked

    # Retrieve related facts from Neo4j for the top compressed chunks
    try:
        chunk_ids = []
        for r in compressed:
            cid = r.get('id') or f"{r.get('path')}::chunk::{r.get('chunk_index')}"
            chunk_ids.append(cid)
        # prefer centralized config for neo4j creds
        try:
            from scripts.utils import get_neo4j_credentials
            creds = get_neo4j_credentials()
            drv = create_driver(creds.get('uri'), creds.get('user'), creds.get('password'))
        except Exception:
            drv = create_driver()
        neo4j_facts = get_related_facts(drv, chunk_ids, max_depth=1)
        print('\n=== Neo4j related facts (derived) ===\n')
        print(json.dumps(neo4j_facts, ensure_ascii=False, indent=2)[:4000])
    except Exception as _e:
        print('Failed to fetch neo4j related facts:', _e)
        neo4j_facts = []

    prompt = build_prompt(args.question, compressed, neo4j_facts=neo4j_facts, max_context_chars=args.max_context_chars)

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
                "Do NOT output any explanatory text, salutations, notes, or comments before or after the JSON block.\n"
                "If you cannot answer from the provided sources, the JSON must be: {\"answer\": \"I don't know based on the provided sources.\", \"citations\": []}.\n"
                "Strictly ensure there are no leading or trailing characters outside the <JSON>...</JSON> markers.\n"
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

