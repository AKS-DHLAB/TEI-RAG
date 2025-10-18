import os
import sys
import time
import socket
import subprocess
import shutil
from pathlib import Path
import json
from typing import List, Dict


def _is_port_in_use(port: int) -> bool:
    import socket

    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        try:
            s.settimeout(0.5)
            s.connect(("127.0.0.1", port))
            return True
        except Exception:
            return False


def _start_neo4j_background() -> None:
    """Try to start Neo4j in the background using available tooling.

    This tries Homebrew `brew services start neo4j` first, then `neo4j start`.
    It's best-effort: failures are printed but don't raise.
    """
    try:
        # prefer brew if available
        brew = shutil.which("brew")
        neo4j_cli = shutil.which("neo4j")
        if brew:
            subprocess.run([brew, "services", "start", "neo4j"], check=False)
            return
        if neo4j_cli:
            subprocess.run([neo4j_cli, "start"], check=False)
            return
    except Exception as e:
        print(f"Failed to start neo4j automatically: {e}", file=sys.stderr)


def _start_streamlit_background(log_path: str = "logs/streamlit_background.log", port: int = 8501) -> None:
    """Spawn a background streamlit process which runs this module.

    The child process will have STREAMLIT_CHILD=1 so the UI code runs there.
    """
    # Don't start if port is already in use
    if _is_port_in_use(port):
        print(f"Port {port} already in use; not starting Streamlit.")
        return

    python = sys.executable
    env = os.environ.copy()
    env["STREAMLIT_CHILD"] = "1"
    args = [python, "-m", "streamlit", "run", sys.argv[0], "--server.port", str(port)]
    Path("logs").mkdir(parents=True, exist_ok=True)
    with open(log_path, "ab") as out:
        # spawn detached background process
        subprocess.Popen(args, env=env, stdout=out, stderr=out, start_new_session=True)


# Only when STREAMLIT_CHILD=1 will the Streamlit UI code run. This prevents
# the script-runner from executing the UI code in the parent process when we
# want to spawn a streamlit-managed child process.
_STREAMLIT_CHILD = os.environ.get("STREAMLIT_CHILD") == "1"

if _STREAMLIT_CHILD:
    import streamlit as st

    # Optional cached resources in Streamlit session to avoid repeated reloads
    def get_cached_llm(model_name: str):
        """Return a cached LLM generate function (loads model once).

        Import the local llm helper lazily to avoid loading native libs at module
        import time. If loading fails, a helpful Streamlit error will be shown.
        """
        key = f"llm::{model_name}"
        if key in st.session_state:
            return st.session_state[key]

        try:
            # Import via the package path to be robust when run as a Streamlit app
            import importlib

            llm_local = importlib.import_module("scripts.llm_local")
            # ensure model/tokenizer are loaded into the process cache
            llm_local._load_model_and_tokenizer(model_name)
            st.session_state[key] = llm_local.generate_from_prompt
            return st.session_state[key]
        except Exception as e:  # pragma: no cover - runtime import guard
            st.error(f"Failed to preload model {model_name}: {e}\nCheck transformers/torch native libs.")
            return None


    def get_cached_embedder():
        key = "embedder::sbert"
        if key in st.session_state:
            return st.session_state[key]
        try:
            # lazy import to avoid c-extension init at module import time
            from sentence_transformers import SentenceTransformer

            import torch
            sbert_device = 'cuda' if torch.cuda.is_available() else 'cpu'
            model = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2", device=sbert_device)
            st.session_state[key] = model
            return model
        except Exception as e:  # pragma: no cover - runtime import guard
            st.error(f"Failed to load embedder: {e}\nInstall sentence-transformers and its dependencies.")
            return None

    st.set_page_config(page_title="RAG Query UI", layout="wide")

    st.title("RAG Query UI")

    # UI controls
    meta_file = st.sidebar.text_input("FAISS meta JSON", value="data/faiss_tei_meta.json")
    index_file = st.sidebar.text_input("FAISS index file", value="data/faiss_tei.index")
    use_faiss = st.sidebar.checkbox("Use FAISS retrieval", value=True)
    use_neo4j = st.sidebar.checkbox("Fetch Neo4j facts", value=True)
    show_debug = st.sidebar.checkbox("Show debug queries/responses", value=True)
    enable_rerank = st.sidebar.checkbox("Enable re-rank (cross-encoder)", value=True)
    rerank_top_k = st.sidebar.number_input("Re-rank: top K", min_value=1, max_value=10, value=3)
    use_compression = st.sidebar.checkbox("Compress chunks using full text (1-3 sentences)", value=False)
    compress_sentences = st.sidebar.number_input("Top sentences per chunk", min_value=1, max_value=5, value=3)
    prefer_mps = st.sidebar.checkbox("Prefer MPS (Apple silicon) for model/embedder", value=False)
    # 기본 모델을 kanana로 설정합니다. 로컬에 모델이 없으면 처음 로드에 시간이 걸릴 수 있습니다.
    llm_model = st.sidebar.text_input("LLM model", value="kakaocorp/kanana-nano-2.1b-base")
    max_new_tokens = st.sidebar.number_input("Max new tokens", min_value=16, max_value=2048, value=2048, step=16)
    # Generation params
    temperature = st.sidebar.slider("Temperature", 0.0, 1.5, 0.7, 0.05)
    do_sample = st.sidebar.checkbox("Do sample (stochastic)", value=True)
    # Preload / Load buttons (explicit)
    if st.sidebar.button("Load model & embedder"):
        with st.spinner("Loading model and embedder (this may take a while)..."):
            t0 = None
            try:
                import time

                t0 = time.time()
                llm_ok = False
                emb_ok = False
                # load LLM
                gen = get_cached_llm(llm_model)
                llm_ok = gen is not None
                # load embedder
                emb = get_cached_embedder()
                emb_ok = emb is not None
                t1 = time.time()
                if llm_ok or emb_ok:
                    st.success(f"Loaded: model={llm_ok}, embedder={emb_ok} (took {t1-t0:.1f}s)")
                    st.session_state['llm_loaded'] = llm_ok
                    st.session_state['embedder_loaded'] = emb_ok
                else:
                    st.error("Failed to load both model and embedder. Check logs and installed packages.")
            except Exception as e:  # pragma: no cover - runtime import guard
                st.error(f"Load failed: {e}")
                if t0:
                    import time

                    st.info(f"Elapsed before failure: {time.time()-t0:.1f}s")

    question = st.text_area("Question", height=120)

    col1, col2 = st.columns([2, 1])

    with col2:
        if st.button("Run Query"):
            if not question.strip():
                st.warning("Enter a question first")
            else:
                st.session_state['run'] = True

    if 'run' not in st.session_state:
        st.session_state['run'] = False

    if st.session_state['run']:
        # Load meta
        meta_path = Path(meta_file)
        if not meta_path.exists():
            st.error(f"Meta file not found: {meta_path}")
        else:
            meta = json.loads(meta_path.read_text(encoding='utf-8'))

            # FAISS retrieval (simple approximate using sentence-transformers)
            if use_faiss:
                st.info("Running FAISS retrieval (this may use a local sentence-transformers model)")
                try:
                    import importlib

                    faiss = importlib.import_module("faiss")
                    from sentence_transformers import SentenceTransformer
                    import numpy as np

                    import torch
                    sbert_device = 'cuda' if torch.cuda.is_available() else 'cpu'
                    sbert = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2", device=sbert_device)
                    # Respect the UI preference for MPS when loading models in this process
                    if prefer_mps:
                        os.environ['PREFER_MPS'] = '1'
                    else:
                        os.environ.pop('PREFER_MPS', None)
                    qv = sbert.encode([question], convert_to_numpy=True)
                    idx = faiss.read_index(str(index_file))
                    D, I = idx.search(qv, 5)
                    # build hits and also capture debug info
                    hits = [meta[i] for i in I[0] if i >= 0 and i < len(meta)]
                    if show_debug:
                        try:
                            # show a truncated view of the query vector
                            qv_list = qv[0].tolist() if hasattr(qv, 'tolist') else list(map(float, qv[0]))
                        except Exception:
                            qv_list = None
                        st.subheader('FAISS debug')
                        if qv_list is not None:
                            st.write('query vector (truncated 16 vals):', qv_list[:16])
                        # distances and indices
                        try:
                            st.write('distances:', (D.tolist() if hasattr(D, 'tolist') else D) )
                        except Exception:
                            st.write('distances (unavailable)')
                        try:
                            st.write('indices:', (I.tolist() if hasattr(I, 'tolist') else I) )
                        except Exception:
                            st.write('indices (unavailable)')
                        # show the full hit ids/titles
                        st.write('retrieved hit IDs/paths:')
                        for ii, idx_i in enumerate(I[0]):
                            if idx_i >= 0 and idx_i < len(meta):
                                m = meta[idx_i]
                                st.write(ii, idx_i, m.get('id') or m.get('path'))
                except Exception as e:  # pragma: no cover - runtime import guard
                    st.error(f"FAISS retrieval failed: {e}\nEnsure faiss and sentence-transformers are installed and working.")
                    hits = []
            else:
                # fallback: top-3 by appearance (simple)
                hits = meta[:3]
            # Optionally re-rank hits and compress
            final_hits = hits
            if enable_rerank and hits:
                try:
                    # import rerank helper from rag_integration (optional)
                    import importlib

                    ri = importlib.import_module("scripts.rag_integration")
                    top_k = min(int(rerank_top_k), len(hits))
                    reranked = ri.rerank_chunks(question, hits, top_k=top_k)
                    st.subheader("Re-ranked Chunks")
                    for h in reranked:
                        st.markdown(f"**{h.get('id', h.get('path',''))}** - {h.get('path','')}\n\n{(h.get('excerpt') or '')[:400]}")
                    final_hits = reranked
                except Exception as e:
                    st.warning(f"Re-rank failed or unavailable: {e}")

            if use_compression and final_hits:
                try:
                    # load full texts for the hits from training JSONL
                    def _load_full_texts_for(retrieved, training_path='data/tei_training_data.jsonl'):
                        need = {(r.get('path'), r.get('chunk_index')) for r in retrieved}
                        out = {}
                        tp = Path(training_path)
                        if not tp.exists():
                            return out
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
                        return out

                    import importlib
                    ri = importlib.import_module("scripts.rag_integration")
                    fulls = _load_full_texts_for(final_hits)
                    compressed_hits = []
                    for r in final_hits:
                        key = (r.get('path'), r.get('chunk_index'))
                        full_text = fulls.get(key)
                        if full_text:
                            short = ri.extract_top_sentences(full_text, question, n=int(compress_sentences))
                            rc = dict(r)
                            rc['excerpt'] = short
                            compressed_hits.append(rc)
                        else:
                            compressed_hits.append(r)
                    st.subheader('Compressed Chunks (top sentences)')
                    for h in compressed_hits:
                        st.markdown(f"**{h.get('id', h.get('path',''))}** - {h.get('path','')}\n\n{(h.get('excerpt') or '')[:400]}")
                    final_hits = compressed_hits
                except Exception as e:
                    st.warning(f"Compression failed: {e}")

            st.subheader("Retrieved Chunks")
            for h in hits:
                st.markdown(f"**{h.get('id', h.get('path',''))}** - {h.get('path','')}\n\n{h.get('excerpt', h.get('text_snippet',''))}")

            neo4j_facts = []
            if use_neo4j and hits:
                st.info("Fetching Neo4j facts for cited chunks")
                try:
                    import importlib

                    neo4j_helpers = importlib.import_module("scripts.neo4j_helpers")
                    import os
                    # Prefer environment variable, but fall back to config/neo4j.ini if present
                    pw = os.environ.get("NEO4J_PASSWORD")
                    if not pw:
                        try:
                            from pathlib import Path
                            import configparser
                            import re

                            cfg_path = Path("config/neo4j.ini")
                            if cfg_path.exists():
                                cp = configparser.ConfigParser()
                                cp.read(cfg_path)
                                # common conventions: [neo4j] password=..., or first section
                                pw = None
                                if "neo4j" in cp:
                                    pw = cp["neo4j"].get("password") or cp["neo4j"].get("pw") or cp["neo4j"].get("NEO4J_PASSWORD")
                                elif cp.sections():
                                    sec = cp[cp.sections()[0]]
                                    pw = sec.get("password") or sec.get("pw") or sec.get("NEO4J_PASSWORD")

                                # fallback: simple key=value parsing
                                if not pw:
                                    txt = cfg_path.read_text(encoding="utf-8")
                                    m = re.search(r"(?i)password\\s*=\\s*(.+)", txt)
                                    if m:
                                        pw = m.group(1).strip()

                                if pw:
                                    os.environ["NEO4J_PASSWORD"] = pw
                                    st.info("Loaded NEO4J_PASSWORD from config/neo4j.ini")
                        except Exception as e:
                            st.warning(f"Failed to read config/neo4j.ini: {e}")

                    if not pw:
                        st.warning("NEO4J_PASSWORD not set in environment; cannot fetch Neo4j facts")
                    else:
                        # show the cypher we'll run and the ids
                        # Ensure we have chunk ids. If the meta entries do not include an
                        # explicit 'id' field, synthesize one using the same convention
                        # used by `tei_to_neo4j.py`: "{path}::chunk::{chunk_index}".
                        ids = []
                        for h in hits:
                            if h.get("id"):
                                ids.append(h.get("id"))
                            else:
                                pth = h.get("path")
                                ci = h.get("chunk_index")
                                if pth is not None and ci is not None:
                                    ids.append(f"{pth}::chunk::{int(ci)}")
                        cypher = "MATCH (c:Chunk) WHERE c.id IN $ids RETURN c"
                        if show_debug:
                            st.subheader('Neo4j debug')
                            st.code(cypher)
                            st.write('params:', {'ids': ids})

                        driver = neo4j_helpers.create_driver(password=pw)
                        # run query and show raw rows
                        neo4j_rows = neo4j_helpers.get_chunks_by_ids(driver, ids)
                        neo4j_facts = [{"id": r.get("id"), "summary": (r.get("excerpt") or "")[:300]} for r in neo4j_rows]
                        if show_debug:
                            st.write('neo4j raw rows (first 10):')
                            for r in neo4j_rows[:10]:
                                st.json(r)
                except Exception as e:  # pragma: no cover - runtime import guard
                    st.error(f"Neo4j fetch failed: {e}")

            st.subheader("Built Prompt Preview")
            try:
                import importlib

                rp = importlib.import_module("scripts.rag_prompt_builder")
                prompt = rp.build_prompt(question, hits, neo4j_facts)
                st.code(prompt)
            except Exception as e:  # pragma: no cover - runtime import guard
                st.error(f"Prompt build failed: {e}")
                prompt = None

            st.subheader("LLM Generation")
            if prompt:
                try:
                    # Require explicit preload to avoid accidental heavy imports during app startup.
                    # Check the explicit 'llm_loaded' flag set by the sidebar Load button. This
                    # avoids calling get_cached_llm() (which loads transformers/torch) during
                    # Streamlit's session replay or when a Run button was persisted in the
                    # frontend state.
                    if not st.session_state.get('llm_loaded', False):
                        st.warning("Model not loaded. Click 'Load model & embedder' in the sidebar first.")
                        raise RuntimeError("Model not preloaded")

                    gen_fn = get_cached_llm(llm_model)
                    if gen_fn is None:
                        st.error("Model failed to load when requested. See logs for details.")
                        raise RuntimeError("Model load failed")

                    raw = gen_fn(
                        prompt,
                        model_name=llm_model,
                        max_new_tokens=max_new_tokens,
                        do_sample=do_sample,
                        temperature=temperature,
                    )
                    st.text_area("Raw model output", value=raw, height=240)

                    # Try basic JSON extraction heuristics
                    import re
                    json_blk = None
                    parsed = None
                    m = re.search(r"<JSON>(.*?)</JSON>", raw, flags=re.S)
                    if m:
                        json_blk = m.group(1)
                    else:
                        # find first balanced {...}
                        start = raw.find('{')
                        if start != -1:
                            depth = 0
                            for i in range(start, len(raw)):
                                if raw[i] == '{':
                                    depth += 1
                                elif raw[i] == '}':
                                    depth -= 1
                                    if depth == 0:
                                        json_blk = raw[start:i+1]
                                        break
                    if json_blk:
                        try:
                            parsed = json.loads(json_blk)
                            st.json(parsed)
                        except Exception as e:
                            st.warning(f"Failed to parse extracted JSON: {e}")
                    else:
                        st.info("No JSON-like block found in model output")

                    # Expand citations if present
                    try:
                        if isinstance(parsed, dict) and parsed.get('citations'):
                            from neo4j_helpers import create_driver, get_chunks_by_ids
                            ids = parsed.get('citations') or []
                            # ensure list of strings
                            ids = [str(x) for x in ids]
                            pw = os.environ.get('NEO4J_PASSWORD')
                            if pw and ids:
                                drv = create_driver(password=pw)
                                rows = get_chunks_by_ids(drv, ids)
                                st.subheader('Expanded cited chunks')
                                st.write(rows)
                            else:
                                st.warning('NEO4J_PASSWORD not set; cannot expand cited chunks')
                    except Exception:
                        pass

                except Exception as e:
                    st.error(f"LLM generation failed: {e}")



    # end of child streamlit app


if __name__ == "__main__" and not _STREAMLIT_CHILD:
    # Launcher mode: start neo4j and streamlit as background services.
    print("Launching neo4j (if available) and Streamlit in background...")
    try:
        _start_neo4j_background()
    except Exception as e:
        print(f"neo4j start attempt failed: {e}", file=sys.stderr)

    try:
        _start_streamlit_background()
    except Exception as e:
        print(f"streamlit start attempt failed: {e}", file=sys.stderr)

    print("Launcher finished. Streamlit logs: logs/streamlit_background.log")


