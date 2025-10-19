#!/usr/bin/env python3
"""Ingest TEI FAISS meta JSON into Neo4j as File and Chunk nodes.

This script reads a JSON array (as produced by `build_tei_faiss.py`) where each
entry contains at least: {"path": "tei/schema/..", "chunk_index": N, "excerpt": "..."}.

It creates (:File {path, filename}) nodes and (:Chunk {path, chunk_index, excerpt})
nodes, and relationships (File)-[:HAS_CHUNK]->(Chunk).

Usage examples:
  # dry-run prints summary
  python scripts/tei_to_neo4j.py --meta-file data/faiss_tei_meta.json --dry-run

  # actual import (set password via env or pass --password)
  export NEO4J_PASSWORD=secret
  python scripts/tei_to_neo4j.py --meta-file data/faiss_tei_meta.json --batch 500

Requires neo4j python driver in your active environment (pip install neo4j).
"""

import os
import json
import argparse
import configparser
from pathlib import Path

try:
    from neo4j import GraphDatabase
except Exception:  # pragma: no cover - runtime dependency may be missing in some environments
    GraphDatabase = None


def parse_args():
    p = argparse.ArgumentParser()
    p.add_argument("--meta-file", required=True, help="Path to faiss_tei_meta.json")
    p.add_argument("--uri", default=os.environ.get("NEO4J_URI", "bolt://localhost:7687"))
    p.add_argument("--user", default=os.environ.get("NEO4J_USER", "neo4j"))
    p.add_argument("--password", default=os.environ.get("NEO4J_PASSWORD"))
    p.add_argument("--batch", type=int, default=500, help="Number of chunks per transaction")
    p.add_argument("--dry-run", action="store_true")
    p.add_argument("--cypher-only", action="store_true", help="Print Cypher UNWIND/MERGE query and a small sample of parameters instead of executing against Neo4j")
    p.add_argument("--with-embeddings", action="store_true", help="Compute embeddings for chunks and store as c.embedding in Neo4j")
    p.add_argument("--embed-model", default=None, help="Embedder model to use (defaults to utils.DEFAULT_EMBED_MODEL)")
    p.add_argument("--training-file", default=str(Path('data/tei_training_data.jsonl')),
                   help="JSONL with full chunk texts used for embedding (path,chunk_index,text)")
    return p.parse_args()


def load_meta(path: str):
    p = Path(path)
    if not p.exists():
        raise FileNotFoundError(p)
    with p.open("r", encoding="utf-8") as f:
        return json.load(f)


def read_neo4j_config(path: str = "config/neo4j.ini"):
    """Read neo4j config from an ini file. Returns dict with possible keys: uri, user, password."""
    p = Path(path)
    if not p.exists():
        return {}
    cp = configparser.ConfigParser()
    try:
        cp.read(p)
    except Exception:
        return {}
    for section in ("neo4j", "default"):
        if section in cp:
            sec = cp[section]
            out = {}
            # Accept keys like uri, user, password or neo4j_uri, neo4j_user, neo4j_password
            def get_any(keys):
                for k in keys:
                    if sec.get(k) is not None:
                        return sec.get(k)
                return None

            uri_val = get_any(("uri", "neo4j_uri", "neo4j-uri", "NEO4J_URI"))
            user_val = get_any(("user", "neo4j_user", "neo4j-user", "NEO4J_USER"))
            pwd_val = get_any(("password", "neo4j_password", "neo4j-password", "NEO4J_PASSWORD"))
            if uri_val:
                out["uri"] = uri_val
            if user_val:
                out["user"] = user_val
            if pwd_val:
                out["password"] = pwd_val
            return out
    # fallback: attempt top-level keys
    return {}


def ensure_constraints(tx):
    # File.path unique, and Chunk node key (path,chunk_index)
    tx.run("CREATE CONSTRAINT IF NOT EXISTS FOR (f:File) REQUIRE f.path IS UNIQUE")
    # Composite node-key constraints require Enterprise edition. Use a single-property unique id instead.
    tx.run("CREATE CONSTRAINT IF NOT EXISTS FOR (c:Chunk) REQUIRE c.id IS UNIQUE")


def create_driver(uri, user, password):
    if GraphDatabase is None:
        raise RuntimeError("neo4j driver not available; install with: pip install neo4j")
    return GraphDatabase.driver(uri, auth=(user, password))


def ingest(meta, uri, user, password, batch_size, dry_run, cypher_only=False, with_embeddings=False, embed_model=None):
    # Group by file path
    files = {}
    for item in meta:
        p = item.get("path")
        files.setdefault(p, []).append(item)

    print(f"Found {len(files)} files and {len(meta)} chunks in meta")

    if dry_run:
        for path, chunks in list(files.items())[:5]:
            print(f"File: {path} -> {len(chunks)} chunks; sample excerpt len={len(chunks[0].get('excerpt',''))}")
        return

    if cypher_only:
        # Print the Cypher query that would be run and a small sample of the rows for inspection.
        print("Cypher-only mode: printing UNWIND/MERGE query and up to 3 sample parameter rows per batch (no DB activity)")
        for path, chunks in list(files.items())[:5]:
            print(f"\n--- File: {path} ({len(chunks)} chunks) ---")
            for i in range(0, len(chunks), batch_size):
                batch = chunks[i:i+batch_size]
                records = []
                for c in batch:
                    chunk_index = int(c.get("chunk_index", 0))
                    pathv = c.get("path")
                    records.append({
                        "path": pathv,
                        "chunk_index": chunk_index,
                        "excerpt": c.get("excerpt") or "",
                        "chunk_id": f"{pathv}::chunk::{chunk_index}",
                    })

                query = """
                UNWIND $rows AS r
                MERGE (f:File {path: r.path})
                MERGE (c:Chunk {id: r.chunk_id})
                SET c.path = r.path, c.chunk_index = r.chunk_index, c.excerpt = r.excerpt
                MERGE (f)-[:HAS_CHUNK]->(c)
                """
                print("Query:\n" + query.strip())
                # print up to 3 sample parameter rows
                import json as _json
                sample = records[:3]
                print("Sample rows:")
                print(_json.dumps(sample, ensure_ascii=False, indent=2)[:2000])
        return

    if password is None:
        raise RuntimeError("NEO4J password required (set NEO4J_PASSWORD env or pass --password)")

    driver = create_driver(uri, user, password)
    try:
        with driver.session() as sess:
            sess.execute_write(ensure_constraints)

            for path, chunks in files.items():
                print(f"Creating File node for {path} with {len(chunks)} chunks")
                sess.execute_write(lambda tx, p=path: tx.run("MERGE (f:File {path:$path}) SET f.filename = $filename", path=p, filename=Path(p).name))

                # Prepare full-text lookup if embeddings will be computed
                full_text_map = {}
                # delay import for performance
                from pathlib import Path as _P
                training_path = _P('data/tei_training_data.jsonl')
                if training_path.exists():
                    with training_path.open('r', encoding='utf-8') as tf:
                        for line in tf:
                            try:
                                rec = json.loads(line)
                            except Exception:
                                continue
                            key = (rec.get('path'), rec.get('chunk_index'))
                            full_text_map[key] = rec.get('text')

                for i in range(0, len(chunks), batch_size):
                    batch = chunks[i:i+batch_size]
                    records = []
                    for c in batch:
                        chunk_index = int(c.get("chunk_index", 0))
                        pathv = c.get("path")
                        text = full_text_map.get((pathv, chunk_index)) or c.get('excerpt') or ''
                        records.append({
                            "path": pathv,
                            "chunk_index": chunk_index,
                            "excerpt": c.get("excerpt") or "",
                            "chunk_id": f"{pathv}::chunk::{chunk_index}",
                            "text": text,
                            "embedding": None,
                        })

                    def tx_func(tx, recs):
                        query = """
                        UNWIND $rows AS r
                        MERGE (f:File {path: r.path})
                        MERGE (c:Chunk {id: r.chunk_id})
                        SET c.path = r.path, c.chunk_index = r.chunk_index, c.excerpt = r.excerpt, c.embedding = r.embedding
                        MERGE (f)-[:HAS_CHUNK]->(c)
                        """
                        tx.run(query, rows=recs)

                    # If embeddings were requested, compute them here per-batch
                    if with_embeddings:
                        try:
                            from scripts.utils import get_cached_embedder
                            emb = get_cached_embedder(embed_model)
                            texts = [r['text'] for r in records]
                            vecs = emb.encode(texts, show_progress_bar=False, convert_to_numpy=True)
                            import numpy as _np
                            if vecs.ndim == 1:
                                vecs = _np.expand_dims(vecs, 0)
                            for jj, r in enumerate(records):
                                r['embedding'] = vecs[jj].tolist()
                        except Exception as e:
                            print(f"Embedding computation failed for batch starting at {i}: {e}")

                    # Execute write; embedding values may be None if not computed
                    sess.execute_write(tx_func, records)

    finally:
        driver.close()


def main():
    args = parse_args()
    meta = load_meta(args.meta_file)
    # Centralized config loader
    try:
        from scripts.utils import get_neo4j_credentials
        creds = get_neo4j_credentials()
        uri = args.uri or creds.get('uri')
        user = args.user or creds.get('user')
        password = args.password or creds.get('password')
    except Exception:
        uri = args.uri
        user = args.user
        password = args.password

    ingest(meta, uri, user, password, args.batch, args.dry_run, cypher_only=args.cypher_only, with_embeddings=args.with_embeddings, embed_model=args.embed_model)


if __name__ == "__main__":
    main()
