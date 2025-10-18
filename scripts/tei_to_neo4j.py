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


def ingest(meta, uri, user, password, batch_size, dry_run, cypher_only=False):
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
    # If env vars or cli args don't provide Neo4j creds, try config/neo4j.ini
    cfg = read_neo4j_config()
    uri = args.uri or cfg.get("uri")
    user = args.user or cfg.get("user")
    password = args.password or cfg.get("password")

    ingest(meta, uri, user, password, args.batch, args.dry_run, cypher_only=args.cypher_only)


if __name__ == "__main__":
    main()
