"""Neo4j helper utilities used by the RAG pipeline.

This module centralizes creation of the Neo4j driver and a couple of small
query helpers used during retrieval and citation expansion.

Key invariants:
- Chunk nodes are expected to have a unique `id` property in the form
  "<path>::chunk::<index>" which is used for lookups and citation mapping.
"""

import os
from neo4j import GraphDatabase
from typing import List, Dict, Any, Optional, Sequence


def create_driver(
    uri: Optional[str] = None, user: Optional[str] = None, password: Optional[str] = None
):
    """Create and return a Neo4j bolt driver.

    Credentials may be supplied as arguments or read from the environment
    variables: NEO4J_URI, NEO4J_USER, NEO4J_PASSWORD. Password is required.
    """
    uri = uri or os.environ.get("NEO4J_URI", "bolt://localhost:7687")
    user = user or os.environ.get("NEO4J_USER", "neo4j")
    password = password or os.environ.get("NEO4J_PASSWORD")
    if password is None:
        raise ValueError("NEO4J_PASSWORD must be provided via env or argument")
    return GraphDatabase.driver(uri, auth=(user, password))


def search_chunks_fulltext(driver, query: str, limit: int = 10) -> List[Dict[str, Any]]:
    """Run a fulltext query against the `chunk_fulltext` index and return node properties.

    Returns a list of dicts with keys such as: id, path, chunk_index, excerpt, score.
    """
    cypher = (
        "CALL db.index.fulltext.queryNodes('chunk_fulltext', $q) "
        "YIELD node, score RETURN node, score ORDER BY score DESC LIMIT $limit"
    )

    def _tx(tx, q, limit):
        res = tx.run(cypher, q=q, limit=limit)
        out = []
        for r in res:
            n = r["node"]
            props = dict(n.items())
            props["score"] = r["score"]
            out.append(props)
        return out

    with driver.session() as s:
        return s.execute_read(_tx, query, limit)


def get_chunks_by_ids(driver, chunk_ids: Sequence[str]) -> List[Dict[str, Any]]:
    """Fetch Chunk nodes by their unique `id` property.

    Accepts an iterable of chunk id strings (e.g. "tei/schema/...::chunk::12").
    Returns a list of property dicts for matched nodes. If `chunk_ids` is
    empty, an empty list is returned immediately.
    """
    if not chunk_ids:
        return []

    cypher = "MATCH (c:Chunk) WHERE c.id IN $ids RETURN c"

    def _tx(tx, ids):
        res = tx.run(cypher, ids=ids)
        return [dict(r["c"].items()) for r in res]

    with driver.session() as s:
        return s.execute_read(_tx, chunk_ids)
