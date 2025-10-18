#!/usr/bin/env python3
"""Build FAISS index from docs and run simple RAG queries with a HF causal LM.

Usage:
  # Build index
  python scripts/rag_index_and_query.py --mode build --docs docs --index-path data/faiss.index --meta-path data/meta.json --embed-model sentence-transformers/all-MiniLM-L6-v2

  # Query
  python scripts/rag_index_and_query.py --mode query --index-path data/faiss.index --meta-path data/meta.json --hf-model kakaocorp/kanana-nano-2.1b-base

Notes:
  - Requires packages in `requirements-rag.txt`.
  - FAISS CPU is used by default; for GPU replace with faiss-gpu and adapt code.
"""
import argparse
import json
import os
from pathlib import Path
from typing import List

def build_index(docs_dir: Path, embed_model_name: str, index_path: Path, meta_path: Path):
    from sentence_transformers import SentenceTransformer
    import numpy as np
    import faiss

    model = SentenceTransformer(embed_model_name)
    texts = []
    metas = []
    for p in sorted(docs_dir.glob('**/*.txt')):
        txt = p.read_text(encoding='utf-8', errors='ignore')
        texts.append(txt)
        metas.append({'path': str(p), 'text_snippet': txt[:500]})

    embeddings = model.encode(texts, show_progress_bar=True, convert_to_numpy=True)
    dim = embeddings.shape[1]
    index = faiss.IndexFlatL2(dim)
    # Cast index to Any for static-analysis friendliness before calling add
    from typing import Any, cast as _cast
    _cast(Any, index).add(embeddings)

    os.makedirs(index_path.parent, exist_ok=True)
    faiss.write_index(index, str(index_path))
    with open(meta_path, 'w') as f:
        json.dump(metas, f)
    print(f'Wrote index to {index_path} with {len(texts)} docs')


def query_index(index_path: Path, meta_path: Path, hf_model: str, topk: int = 3, device: str | None = None, use_8bit: bool = False, device_map: str | None = None):
    import faiss
    import json
    from transformers import AutoTokenizer, AutoModelForCausalLM
    import torch
    from typing import Any, cast

    index = cast(Any, faiss.read_index(str(index_path)))
    with open(meta_path, 'r') as f:
        metas = json.load(f)

    # choose device
    device_str = device or ('cuda' if torch.cuda.is_available() else 'cpu')
    device_torch = torch.device(device_str)
    print('Using device', device_torch)

    # determine platform capabilities
    is_mps = getattr(torch.backends, 'mps', None) is not None and torch.backends.mps.is_available()
    is_cuda = torch.cuda.is_available()

    # handle 8-bit availability: bitsandbytes requires CUDA; on macOS MPS it's not available
    if use_8bit and not is_cuda:
        print('Warning: --use-8bit requested but CUDA is not available. bitsandbytes requires CUDA. Falling back to fp16 on MPS/CPU where possible.')
        use_8bit = False

    print(f"Loading HF model {hf_model} (use_8bit={use_8bit}, device_map={device_map}, is_mps={is_mps}, is_cuda={is_cuda})")
    tokenizer = AutoTokenizer.from_pretrained(hf_model)

    # load model once
    if use_8bit:
        try:
            # bitsandbytes is optional and may not be resolvable by static analyzers on macOS
            import importlib
            importlib.import_module('bitsandbytes')  # type: ignore
        except Exception:
            raise RuntimeError('bitsandbytes is not installed or not usable on this platform')
        model = AutoModelForCausalLM.from_pretrained(hf_model, load_in_8bit=True, device_map=device_map or 'auto')
        model = cast(Any, model)
    else:
        # prefer fp16 where supported
        try:
            if is_mps and device_str == 'mps':
                # On some PyTorch/MPS builds, loading directly with fp16 causes issues; load in float32 then move
                model = AutoModelForCausalLM.from_pretrained(hf_model)
                try:
                    cast(Any, model).to(device_torch)
                except Exception:
                    pass
            elif is_cuda and device_str == 'cuda':
                model = AutoModelForCausalLM.from_pretrained(hf_model, torch_dtype=torch.float16, device_map=device_map or 'auto')
                model = cast(Any, model)
            else:
                model = AutoModelForCausalLM.from_pretrained(hf_model)
                model = cast(Any, model)
        except Exception as e:
            print('Model load with dtype hint failed, falling back to default:', e)
            model = AutoModelForCausalLM.from_pretrained(hf_model)
            model = cast(Any, model)

    # if device_map not used, move to device
    if not device_map:
        try:
            cast(Any, model).to(device_torch)
        except Exception:
            # some model types may not support direct .to(device) after device_map loads
            pass

    model.eval()

    # embed model instance for queries
    from sentence_transformers import SentenceTransformer
    sbert = cast(Any, SentenceTransformer('sentence-transformers/all-MiniLM-L6-v2'))

    while True:
        try:
            q = input('\nQuery: ').strip()
        except (EOFError, KeyboardInterrupt):
            print('\nGoodbye')
            break
        if not q:
            continue
        if q.lower() in ('quit', 'exit'):
            break

        # embed query with sentence-transformers model
        q_emb = sbert.encode([q], convert_to_numpy=True)
        D, I = index.search(q_emb, topk)
        hits = I[0]
        ctx = ''
        for idx in hits:
            meta = metas[idx]
            ctx += f"\n---\nSource: {meta.get('path')}\n{meta.get('text_snippet')}\n"

        # build prompt
        prompt = f"Context:\n{ctx}\n\nQuestion: {q}\nAnswer:"
        inputs = tokenizer(prompt, return_tensors='pt')
        # move inputs to the target device if possible; prefer explicit device_torch
        try:
            inputs = {k: v.to(device_torch) for k, v in inputs.items()}
        except Exception:
            # Fallback: try to move to model.device if available
            try:
                mdl_dev = getattr(model, 'device', None)
                if mdl_dev is not None:
                    inputs = {k: v.to(mdl_dev) for k, v in inputs.items()}
            except Exception:
                pass

        # generate
        with torch.no_grad():
            out = model.generate(**inputs, max_new_tokens=200)
        answer = tokenizer.decode(out[0], skip_special_tokens=True)
        print('\n--- Answer ---')
        print(answer)
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--mode', choices=['build', 'query'], required=True)
    parser.add_argument('--docs', type=str, default='docs')
    parser.add_argument('--embed-model', type=str, default='sentence-transformers/all-MiniLM-L6-v2')
    parser.add_argument('--index-path', type=str, default='data/faiss.index')
    parser.add_argument('--meta-path', type=str, default='data/meta.json')
    parser.add_argument('--hf-model', type=str, default='kakaocorp/kanana-nano-2.1b-base')
    parser.add_argument('--topk', type=int, default=3)
    parser.add_argument('--device', type=str, default=None)
    parser.add_argument('--use-8bit', action='store_true', dest='use_8bit', help='Load model in 8-bit using bitsandbytes')
    parser.add_argument('--device-map', type=str, default=None, dest='device_map', help='Device map for from_pretrained (e.g. auto)')
    args = parser.parse_args()

    docs_dir = Path(args.docs)
    index_path = Path(args.index_path)
    meta_path = Path(args.meta_path)

    if args.mode == 'build':
        if not docs_dir.exists():
            print('Docs directory not found. Create it and put txt files there.')
            return
        build_index(docs_dir, args.embed_model, index_path, meta_path)
    else:
        if not index_path.exists() or not meta_path.exists():
            print('Index or meta not found. Run with --mode build first.')
            return
        query_index(index_path, meta_path, args.hf_model, topk=args.topk, device=args.device, use_8bit=args.use_8bit, device_map=args.device_map)


if __name__ == '__main__':
    main()
