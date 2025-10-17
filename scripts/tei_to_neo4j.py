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
    return p.parse_args()


def load_meta(path: str):
    p = Path(path)
    if not p.exists():
        raise FileNotFoundError(p)
    with p.open("r", encoding="utf-8") as f:
        return json.load(f)


def ensure_constraints(tx):
    # File.path unique, and Chunk node key (path,chunk_index)
    tx.run("CREATE CONSTRAINT IF NOT EXISTS FOR (f:File) REQUIRE f.path IS UNIQUE")
    # Composite node-key constraints require Enterprise edition. Use a single-property unique id instead.
    tx.run("CREATE CONSTRAINT IF NOT EXISTS FOR (c:Chunk) REQUIRE c.id IS UNIQUE")


def create_driver(uri, user, password):
    if GraphDatabase is None:
        raise RuntimeError("neo4j driver not available; install with: pip install neo4j")
    return GraphDatabase.driver(uri, auth=(user, password))


def ingest(meta, uri, user, password, batch_size, dry_run):
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

    if password is None:
        raise RuntimeError("NEO4J password required (set NEO4J_PASSWORD env or pass --password)")

    driver = create_driver(uri, user, password)
    try:
        with driver.session() as sess:
            sess.execute_write(ensure_constraints)

            for path, chunks in files.items():
                print(f"Creating File node for {path} with {len(chunks)} chunks")
                sess.execute_write(lambda tx, p=path: tx.run("MERGE (f:File {path:$path}) SET f.filename = $filename", path=p, filename=Path(p).name))

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

                    def tx_func(tx, recs):
                        query = """
                        UNWIND $rows AS r
                        MERGE (f:File {path: r.path})
                        MERGE (c:Chunk {id: r.chunk_id})
                        SET c.path = r.path, c.chunk_index = r.chunk_index, c.excerpt = r.excerpt
                        MERGE (f)-[:HAS_CHUNK]->(c)
                        """
                        tx.run(query, rows=recs)

                    sess.execute_write(tx_func, records)

    finally:
        driver.close()


def main():
    args = parse_args()
    meta = load_meta(args.meta_file)
    ingest(meta, args.uri, args.user, args.password, args.batch, args.dry_run)


if __name__ == "__main__":
    main()
