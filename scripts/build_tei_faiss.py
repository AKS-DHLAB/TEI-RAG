#!/usr/bin/env python3
"""Build a FAISS index from TEI schema files under tei/schema.

This script:
 - finds .dtd, .rng, .rnc files under tei/schema
 - reads them as text, splits into chunks, embeds with sentence-transformers
 - builds a FAISS IndexFlatL2 and writes index + meta JSON to data/faiss_tei.index and data/faiss_tei_meta.json
"""
from pathlib import Path
import os
import json

CHUNK_SIZE = 800
CHUNK_OVERLAP = 100
EMBED_MODEL = 'sentence-transformers/all-MiniLM-L6-v2'
OUT_INDEX = Path('data/faiss_tei.index')
OUT_META = Path('data/faiss_tei_meta.json')
TRAINING_JSONL = Path('data/tei_training_data.jsonl')
# default root kept for backward compatibility, but allow scanning entire tei tree
ROOT = Path('tei/schema')


def iter_schema_files(root: Path):
    for ext in ('*.dtd','*.rng','*.rnc','*.xml'):
        for p in root.rglob(ext):
            yield p


def chunk_text(text: str, size: int = CHUNK_SIZE, overlap: int = CHUNK_OVERLAP):
    i = 0
    n = len(text)
    while i < n:
        end = min(n, i + size)
        yield text[i:end]
        i += size - overlap


def parse_args():
    import argparse
    p = argparse.ArgumentParser()
    p.add_argument('--root', default=str(ROOT), help='Root directory to scan for schema files')
    p.add_argument('--chunk-size', type=int, default=CHUNK_SIZE)
    p.add_argument('--chunk-overlap', type=int, default=CHUNK_OVERLAP)
    p.add_argument('--embed-model', default=EMBED_MODEL)
    p.add_argument('--out-index', default=str(OUT_INDEX))
    p.add_argument('--out-meta', default=str(OUT_META))
    p.add_argument('--out-training', default=str(TRAINING_JSONL), help='Output JSONL training file')
    return p.parse_args()


def main():
    args = parse_args()
    root = Path(args.root)
    files = list(iter_schema_files(root))
    if not files:
        print('No schema files found under', root)
        return

    # read and chunk
    docs = []
    metas = []
    for p in sorted(files):
        txt = p.read_text(encoding='utf-8', errors='ignore')
        for i, chunk in enumerate(chunk_text(txt, size=args.chunk_size, overlap=args.chunk_overlap)):
            docs.append(chunk)
            metas.append({'path': str(p), 'chunk_index': i, 'excerpt': chunk[:200]})

    print(f'Found {len(files)} files, producing {len(docs)} chunks')

    # embed
    from sentence_transformers import SentenceTransformer
    import numpy as np
    import faiss
    from typing import Any, cast

    # Cast to Any for static analysis friendliness (some type stubs vary by install)
    import torch
    sbert_device = 'cuda' if torch.cuda.is_available() else 'cpu'
    model = cast(Any, SentenceTransformer(args.embed_model, device=sbert_device))
    embeddings = model.encode(docs, show_progress_bar=True, convert_to_numpy=True)
    # Ensure embeddings is a 2D numpy array: (n_vectors, dim)
    if embeddings.ndim != 2:
        raise RuntimeError(f"Unexpected embeddings shape {embeddings.shape}; expected 2D array")
    dim = embeddings.shape[1]
    index = faiss.IndexFlatL2(dim)
    # static type checkers may not have precise stubs for faiss; cast to Any
    from typing import cast as _cast
    _cast(Any, index).add(embeddings)

    out_index = Path(args.out_index)
    out_meta = Path(args.out_meta)
    out_training = Path(args.out_training)

    out_index.parent.mkdir(parents=True, exist_ok=True)
    faiss.write_index(index, str(out_index))
    with open(out_meta, 'w', encoding='utf-8') as f:
        json.dump(metas, f, ensure_ascii=False)
    # write training JSONL: each line is {"text": chunk, "path": path, "chunk_index": i}
    out_training.parent.mkdir(parents=True, exist_ok=True)
    with open(out_training, 'w', encoding='utf-8') as outf:
        for m, doc in zip(metas, docs):
            rec = {"text": doc, "path": m['path'], "chunk_index": m['chunk_index']}
            outf.write(json.dumps(rec, ensure_ascii=False) + "\n")

    print('Wrote', out_index, 'and', out_meta, 'and', out_training)


if __name__ == '__main__':
    main()
