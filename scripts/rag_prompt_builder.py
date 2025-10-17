"""Prompt builder for RAG: assemble system/context/graph/user sections.

This module formats a single string prompt that contains retrieved document
chunks (as [source:id] blocks) and optional Neo4j-derived facts (as
[graph:id] entries). The returned prompt is ready to be consumed by a causal
LM and includes explicit instructions to cite sources.
"""

from typing import List, Dict


def build_prompt(question: str, retrieved_chunks: List[Dict], neo4j_facts: List[Dict], max_context_chars: int = 4000) -> str:
    """
    Assemble a RAG prompt combining retrieved text chunks and Neo4j facts.

    Inputs:
      - question: user question string
      - retrieved_chunks: list of dicts with keys: id, path, chunk_index, excerpt
      - neo4j_facts: list of dicts representing Neo4j query results (e.g., nodes/properties or summary facts)
      - max_context_chars: soft cap for concatenated context to avoid overly long prompts

    Output: a single string prompt ready to feed to a causal LLM.

    The prompt structure:
      1) System instruction with behavior and citation rules.
      2) Context section containing the most relevant retrieved chunks (with citations).
      3) Graph facts section summarizing Neo4j findings (with citations to node ids/paths).
      4) User question + instructions (answer concisely, cite sources in [source:id] format).
    """

    # Helper: format a chunk into a cited block
    def fmt_chunk(c):
        cid = c.get("id") or f"{c.get('path')}::chunk::{c.get('chunk_index')}"
        header = f"[source:{cid}]"
        excerpt = c.get("excerpt", "").strip()
        return header + "\n" + excerpt

    # Helper: format a neo4j fact into a short line
    def fmt_fact(f):
        # expect f to have keys like 'path','id','summary' or arbitrary properties
        if "summary" in f:
            return f"[graph:{f.get('id', f.get('path','unknown'))}] {f['summary']}"
        # fallback: join prop key:val
        items = []
        for k, v in f.items():
            items.append(f"{k}={v}")
        return "[graph] " + "; ".join(items)

    # Build context limiting to max_context_chars
    ctx_parts = []
    ctx_len = 0
    for c in retrieved_chunks:
        block = fmt_chunk(c)
        if ctx_len + len(block) > max_context_chars:
            break
        ctx_parts.append(block)
        ctx_len += len(block)

    graph_parts = [fmt_fact(f) for f in neo4j_facts]

    system = (
        "You are an assistant that answers questions using provided reference materials. "
        "Use only the information present in the Context and Graph Facts sections when answering. "
        "If the answer cannot be determined from the provided sources, say you don't know and do not hallucinate.\n"
        "Cite every factual claim with one or more sources using the format [source:<id>] for text chunks and [graph:<id>] for graph facts. "
        "When multiple sources support the same claim, list them comma-separated in the citation.\n"
    )

    prompt = []
    prompt.append("SYSTEM:\n" + system)
    prompt.append("\nCONTEXT (retrieved text chunks):\n")
    if ctx_parts:
        prompt.append("\n---\n".join(ctx_parts))
    else:
        prompt.append("(no retrieved text chunks available)")

    prompt.append("\n\nGRAPH FACTS (from Neo4j):\n")
    if graph_parts:
        prompt.append("\n".join(graph_parts))
    else:
        prompt.append("(no graph facts available)")

    prompt.append(
        "\n\nINSTRUCTIONS:\nAnswer the question concisely (3-6 sentences). For each factual statement include one or more citations in-line using the source tags. "
        "If you cannot answer from the provided sources, reply: 'I don't know based on the provided sources.'\n"
    )

    prompt.append("\nUSER QUESTION:\n" + question + "\n\nRESPONSE:\n")

    return "\n".join(prompt)
