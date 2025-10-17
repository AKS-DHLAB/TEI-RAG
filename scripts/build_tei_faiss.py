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


def main():
    files = list(iter_schema_files(ROOT))
    if not files:
        print('No schema files found under', ROOT)
        return

    # read and chunk
    docs = []
    metas = []
    for p in sorted(files):
        txt = p.read_text(encoding='utf-8', errors='ignore')
        for i, chunk in enumerate(chunk_text(txt)):
            docs.append(chunk)
            metas.append({'path': str(p), 'chunk_index': i, 'excerpt': chunk[:200]})

    print(f'Found {len(files)} files, producing {len(docs)} chunks')

    # embed
    from sentence_transformers import SentenceTransformer
    import numpy as np
    import faiss
    from typing import Any, cast

    # Cast to Any for static analysis friendliness (some type stubs vary by install)
    model = cast(Any, SentenceTransformer(EMBED_MODEL))
    embeddings = model.encode(docs, show_progress_bar=True, convert_to_numpy=True)
    # Ensure embeddings is a 2D numpy array: (n_vectors, dim)
    if embeddings.ndim != 2:
        raise RuntimeError(f"Unexpected embeddings shape {embeddings.shape}; expected 2D array")
    dim = embeddings.shape[1]
    index = faiss.IndexFlatL2(dim)
    # static type checkers may not have precise stubs for faiss; cast to Any
    from typing import cast as _cast
    _cast(Any, index).add(embeddings)

    OUT_INDEX.parent.mkdir(parents=True, exist_ok=True)
    faiss.write_index(index, str(OUT_INDEX))
    with open(OUT_META, 'w') as f:
        json.dump(metas, f)
    print('Wrote', OUT_INDEX, 'and', OUT_META)


if __name__ == '__main__':
    main()
