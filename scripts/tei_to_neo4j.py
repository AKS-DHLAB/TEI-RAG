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
import hashlib
import re
import sys
from collections import defaultdict

try:
    from neo4j import GraphDatabase
except Exception:  # pragma: no cover - runtime dependency may be missing in some environments
    GraphDatabase = None

try:
    import faiss
    import numpy as _np
except Exception:
    faiss = None
    _np = None


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
    p.add_argument("--extract-graph", action="store_true", help="Parse TEI/XML files listed in meta and create Element/Entity graph in Neo4j")
    p.add_argument("--element-embeddings", action="store_true", help="Compute embeddings for Elements and store in Neo4j")
    p.add_argument("--rebuild-faiss", action="store_true", help="Rebuild FAISS index from Element embeddings and write data/faiss_elements.index and meta")
    p.add_argument("--fill-missing-embeddings", action="store_true", help="Find Elements without embedding, compute embeddings (can force CPU via FORCE_EMBED_CPU=1), write to Neo4j, and optionally rebuild FAISS")
    p.add_argument("--merge-entities", action="store_true", help="Normalize and merge Entity nodes across files (canonicalize names)")
    p.add_argument("--faiss-out", default=str(Path('data') / 'faiss_elements.index'), help="FAISS index output path for element embeddings")
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
    tx.run("CREATE CONSTRAINT IF NOT EXISTS FOR (e:Element) REQUIRE e.id IS UNIQUE")
    tx.run("CREATE CONSTRAINT IF NOT EXISTS FOR (en:Entity) REQUIRE en.id IS UNIQUE")


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
                        "tag": c.get('tag') if c.get('tag') is not None else '',
                        "attributes": c.get('attributes') if c.get('attributes') is not None else {},
                        "text": ''
                    })
                query = """
                UNWIND $rows AS r
                MERGE (f:File {path: r.path})
                SET f.id = r.path
                MERGE (e:Element {id: r.chunk_id})
                SET e.file_id = r.path, e.text = r.text, e.chunk_index = r.chunk_index, e.excerpt = r.excerpt, e.embedding = r.embedding, e.attributes = coalesce(r.attributes, {}), e.tag = coalesce(r.tag, '')
                MERGE (f)-[:CONTAINS]->(e)
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

    # If user requested graph extraction, run merged extractor
    if args.extract_graph:
        # Run merged extractor (raises on error so we see failures)
        totals = extract_graph_and_write(meta, uri, user, password, batch_size=args.batch, dry_run=args.dry_run, with_embeddings=args.element_embeddings, embed_model=args.embed_model, faiss_out=args.faiss_out, rebuild_faiss=args.rebuild_faiss, merge_entities=args.merge_entities)
        print('Done extract_graph:', totals)
        # still optionally continue to ingest chunk-level meta
    # default: run chunk-level ingest
    if args.fill_missing_embeddings:
        fill_missing_element_embeddings(uri, user, password, batch_size=args.batch, embed_model=args.embed_model, rebuild_faiss=args.rebuild_faiss, faiss_out=args.faiss_out)
    else:
        ingest(meta, uri, user, password, args.batch, args.dry_run, cypher_only=args.cypher_only, with_embeddings=args.with_embeddings, embed_model=args.embed_model)


# main will be invoked at end of file after helper definitions


###########################
# Extract graph and FAISS helpers
###########################


def normalize_tag_local(tag: str):
    if tag is None:
        return ''
    if '}' in tag:
        return tag.split('}', 1)[1]
    return tag


def get_text_local(elem):
    parts = []
    if getattr(elem, 'text', None):
        parts.append(elem.text)
    for c in list(elem):
        parts.append(get_text_local(c))
        if getattr(c, 'tail', None):
            parts.append(c.tail)
    return ''.join(parts).strip()


def parse_file_elements_local(file_path: str):
    p = Path(file_path)
    try:
        # prefer lxml for robustness, but import via importlib to avoid static analyzer errors
        try:
            import importlib
            LET = importlib.import_module('lxml.etree')
            tree = LET.parse(str(p))
            root = tree.getroot()
        except Exception:
            raise
    except Exception:
        import xml.etree.ElementTree as ET
        tree = ET.parse(str(p))
        root = tree.getroot()

    elements = []
    entity_records = []
    child_pairs = []
    entity_links = []

    entity_tags = set(['persName', 'placeName', 'orgName', 'date', 'name'])

    def traverse(node, xpath_prefix):
        tag = normalize_tag_local(node.tag)
        text = get_text_local(node)
        el_id = f"{file_path}::element::{xpath_prefix}/{tag}"
        excerpt = text[:1000]
        attrs = {k: v for k, v in (node.attrib.items() if hasattr(node, 'attrib') else [])}
        try:
            import json as _json
            attrs_str = _json.dumps(attrs, ensure_ascii=False)
        except Exception:
            attrs_str = ''
        elements.append({
            'file_path': file_path,
            'element_id': el_id,
            'tag': tag,
            'xpath': f"{xpath_prefix}/{tag}",
            'text': excerpt,
            'full_text': text,
            'attributes': attrs_str,
        })

        if tag in entity_tags and text:
            canon = re.sub(r'\s+', ' ', text).strip().lower()
            canon_hash = hashlib.md5(canon.encode('utf-8')).hexdigest()
            ent_id = f"entity::{canon_hash}"
            entity_records.append({'id': ent_id, 'tag': tag, 'text': excerpt, 'canonical': canon})
            entity_links.append({'el_id': el_id, 'ent_id': ent_id})

        children = list(node)
        tag_groups = defaultdict(list)
        for c in children:
            tag_groups[normalize_tag_local(c.tag)].append(c)
        for tag_name, group in tag_groups.items():
            for idx, child in enumerate(group, start=1):
                child_xpath_prefix = f"{xpath_prefix}/{tag_name}[{idx}]"
                parent_id = el_id
                child_id = f"{file_path}::element::{child_xpath_prefix}/{normalize_tag_local(child.tag)}"
                child_pairs.append({'parent_id': parent_id, 'child_id': child_id})
                traverse(child, child_xpath_prefix)

    root_tag = normalize_tag_local(root.tag)
    traverse(root, f"/{root_tag}[1]")
    return elements, entity_records, child_pairs, entity_links


def extract_graph_and_write(meta, uri, user, password, batch_size=500, dry_run=False, with_embeddings=False, embed_model=None, faiss_out='data/faiss_elements.index', rebuild_faiss=False, merge_entities=False):
    files = sorted({item.get('path') for item in meta})
    print(f'Found {len(files)} files to extract graph from')

    emb = None
    if with_embeddings:
        try:
            try:
                from scripts.utils import get_cached_embedder
            except Exception:
                # fallback: load scripts/utils.py by path
                import importlib.util as _il
                util_path = Path(os.getcwd()) / 'scripts' / 'utils.py'
                spec = _il.spec_from_file_location('scripts.utils', str(util_path))
                if spec is None or spec.loader is None:
                    raise ImportError(f'Could not load spec for {util_path}')
                mod = _il.module_from_spec(spec)
                spec.loader.exec_module(mod)
                get_cached_embedder = getattr(mod, 'get_cached_embedder')
            emb = get_cached_embedder(embed_model)
        except Exception as e:
            print('Failed to load embedder:', e)
            emb = None

    totals = {'elements': 0, 'entities': 0, 'element_child_rels': 0, 'contains_rels': 0, 'entity_rels': 0}
    faiss_meta = []
    faiss_vecs = []

    for fp in files:
        p = Path(fp)
        if not p.exists():
            print('File not found, skipping:', fp)
            continue
        print('\nProcessing', fp)
        try:
            elements, entity_records, child_pairs, entity_links = parse_file_elements_local(fp)
        except Exception as e:
            print('Failed to parse', fp, 'skipping:', e)
            continue

        if dry_run:
            print(f'Would create {len(elements)} elements, {len(entity_records)} entities, {len(child_pairs)} child links, {len(entity_links)} entity links for {fp}')
            totals['elements'] += len(elements)
            totals['entities'] += len(entity_records)
            totals['element_child_rels'] += len(child_pairs)
            totals['entity_rels'] += len(entity_links)
            totals['contains_rels'] += len(elements)
            continue

        if GraphDatabase is None:
            raise RuntimeError('neo4j driver not available; install with: pip install neo4j')
        driver = create_driver(uri, user, password)
        try:
            with driver.session() as sess:
                sess.execute_write(ensure_constraints)

                for i in range(0, len(elements), batch_size):
                    batch = elements[i:i+batch_size]
                    def write_elements(tx, rows):
                        q = """
                        UNWIND $rows AS r
                        MERGE (f:File {path: r.file_path})
                        SET f.id = r.file_path
                        MERGE (el:Element {id: r.element_id})
                        SET el.file_id = r.file_path, el.tag = r.tag, el.xpath = r.xpath, el.excerpt = r.excerpt, el.text = r.text, el.attributes = r.attributes, el.embedding = r.embedding
                        MERGE (f)-[:CONTAINS]->(el)
                        """
                        tx.run(q, rows=rows)
                    for r in batch:
                        r.setdefault('embedding', None)
                    sess.execute_write(write_elements, batch)
                    totals['elements'] += len(batch)
                    totals['contains_rels'] += len(batch)

                for i in range(0, len(entity_records), batch_size):
                    batch = entity_records[i:i+batch_size]
                    def write_entities(tx, rows):
                        q = """
                        UNWIND $rows AS r
                        MERGE (en:Entity {id: r.id})
                        SET en.tag = r.tag, en.text = r.text, en.canonical = r.canonical
                        """
                        tx.run(q, rows=rows)
                    sess.execute_write(write_entities, batch)
                    totals['entities'] += len(batch)

                for i in range(0, len(child_pairs), batch_size):
                    batch = child_pairs[i:i+batch_size]
                    def write_child_rels(tx, rows):
                        q = """
                        UNWIND $rows AS r
                        MATCH (a:Element {id: r.parent_id}), (b:Element {id: r.child_id})
                        MERGE (a)-[:ELEMENT_CHILD]->(b)
                        """
                        tx.run(q, rows=rows)
                    sess.execute_write(write_child_rels, batch)
                    totals['element_child_rels'] += len(batch)

                for i in range(0, len(entity_links), batch_size):
                    batch = entity_links[i:i+batch_size]
                    def write_entity_links(tx, rows):
                        q = """
                        UNWIND $rows AS r
                        MATCH (el:Element {id: r.el_id}), (en:Entity {id: r.ent_id})
                        MERGE (el)-[:CONTAINS_ENTITY]->(en)
                        """
                        tx.run(q, rows=rows)
                    sess.execute_write(write_entity_links, batch)
                    totals['entity_rels'] += len(batch)

                print(f'Wrote for {fp}: elements={len(elements)}, entities={len(entity_records)}, child_links={len(child_pairs)}, entity_links={len(entity_links)}')
        finally:
            try:
                driver.close()
            except Exception:
                pass

        if with_embeddings and emb is not None:
            texts = [e['full_text'] for e in elements]
            try:
                vecs = emb.encode(texts, show_progress_bar=False, convert_to_numpy=True)
                try:
                    import numpy as np_local
                except Exception:
                    np_local = None
                if np_local is not None and getattr(vecs, 'ndim', None) == 1:
                    vecs = np_local.expand_dims(vecs, 0)

                # prepare updates for Neo4j
                emb_rows = []
                for idx, e in enumerate(elements):
                    v = vecs[idx]
                    if np_local is not None:
                        arr = np_local.asarray(v, dtype='float32')
                        v_list = arr.tolist()
                    else:
                        # assume list-like
                        v_list = list(v)
                    faiss_meta.append({'id': e['element_id'], 'file_path': e['file_path'], 'tag': e['tag'], 'xpath': e['xpath'], 'text': e['text']})
                    faiss_vecs.append(v_list)
                    emb_rows.append({'element_id': e['element_id'], 'embedding': v_list})

                # write embeddings back to Neo4j in batches
                try:
                    if GraphDatabase is None:
                        raise RuntimeError('neo4j driver not available')
                    driver2 = create_driver(uri, user, password)
                    with driver2.session() as s2:
                        def write_embeddings_tx(tx, rows):
                            q_upd = """
                            UNWIND $rows AS r
                            MATCH (el:Element {id: r.element_id})
                            SET el.embedding = r.embedding
                            """
                            tx.run(q_upd, rows=rows)

                        for j in range(0, len(emb_rows), batch_size):
                            b = emb_rows[j:j+batch_size]
                            s2.execute_write(write_embeddings_tx, b)
                    try:
                        driver2.close()
                    except Exception:
                        pass
                except Exception as e:
                    print('Failed to write element embeddings to Neo4j:', e)

            except Exception as ex:
                print('Embedding computation failed for file', fp, ex)

    print('\nOverall totals:')
    print(totals)

    if rebuild_faiss and faiss_vecs:
        try:
            import faiss as _faiss
            import numpy as np_local
        except Exception:
            print('faiss or numpy not available; cannot rebuild FAISS index')
        else:
            print('Rebuilding FAISS index with', len(faiss_vecs), 'vectors')
            arr = np_local.vstack([np_local.asarray(v, dtype='float32') for v in faiss_vecs])
            dim = arr.shape[1]
            index = _faiss.IndexFlatL2(dim)
            # use getattr to avoid some static analyzers complaining about call signature
            getattr(index, 'add')(arr)
            _faiss.write_index(index, faiss_out)
            meta_out = Path(faiss_out).with_suffix('.meta.json')
            with meta_out.open('w', encoding='utf-8') as mf:
                json.dump(faiss_meta, mf, ensure_ascii=False, indent=2)
            print('FAISS index written to', faiss_out, 'meta to', str(meta_out))

    if merge_entities:
        print('Entity normalization/merge: canonical ids were used on creation; additional normalization not implemented')

    return totals


def fill_missing_element_embeddings(uri, user, password, batch_size=500, embed_model=None, rebuild_faiss=False, faiss_out='data/faiss_elements.index'):
    """Find Elements without embedding, compute embeddings, write to Neo4j, and optionally rebuild FAISS."""
    if GraphDatabase is None:
        raise RuntimeError('neo4j driver not available')
    drv = create_driver(uri, user, password)
    try:
        with drv.session() as s:
            # fetch elements missing embeddings
            rows = s.run('MATCH (e:Element) WHERE e.embedding IS NULL RETURN e.id AS id, e.text AS text LIMIT 1000000')
            to_process = []
            for r in rows:
                tid = r['id']
                txt = r['text'] or ''
                to_process.append({'id': tid, 'text': txt})

        if not to_process:
            print('No Elements missing embedding')
            return 0

        # determine embedder device preference
        force_cpu = os.environ.get('FORCE_EMBED_CPU') == '1' or os.environ.get('PYTORCH_FORCE_CPU') == '1'
        emb = None
        try:
            from scripts.utils import get_cached_embedder
            # If using SentenceTransformer, we cannot pass device; instead set env to force CPU
            if force_cpu:
                os.environ['PYTORCH_ENABLE_MPS_FALLBACK'] = '1'
                os.environ['CUDA_VISIBLE_DEVICES'] = ''
            emb = get_cached_embedder(embed_model)
        except Exception:
            # fallback to file-load like earlier
            import importlib.util as _il
            util_path = Path(os.getcwd()) / 'scripts' / 'utils.py'
            spec = _il.spec_from_file_location('scripts.utils', str(util_path))
            if spec is None or spec.loader is None:
                raise ImportError('Cannot load scripts.utils')
            mod = _il.module_from_spec(spec)
            spec.loader.exec_module(mod)
            if force_cpu:
                os.environ['PYTORCH_ENABLE_MPS_FALLBACK'] = '1'
                os.environ['CUDA_VISIBLE_DEVICES'] = ''
            emb = getattr(mod, 'get_cached_embedder')(embed_model)

        # batch encode
        import numpy as np_local
        emb_rows = []
        for i in range(0, len(to_process), batch_size):
            batch = to_process[i:i+batch_size]
            texts = [b['text'] for b in batch]
            try:
                vecs = emb.encode(texts, show_progress_bar=False, convert_to_numpy=True)
                if getattr(vecs, 'ndim', None) == 1:
                    vecs = np_local.expand_dims(vecs, 0)
                for j, b in enumerate(batch):
                    arr = np_local.asarray(vecs[j], dtype='float32')
                    emb_rows.append({'element_id': b['id'], 'embedding': arr.tolist()})
            except Exception as e:
                print('Batch embedding failed at', i, e)

        # write back to Neo4j
        with drv.session() as s:
            def write_embeddings_tx(tx, rows):
                q = '''
                UNWIND $rows AS r
                MATCH (e:Element {id: r.element_id})
                SET e.embedding = r.embedding
                '''
                tx.run(q, rows=rows)
            for k in range(0, len(emb_rows), batch_size):
                s.execute_write(write_embeddings_tx, emb_rows[k:k+batch_size])

        print('Wrote', len(emb_rows), 'element embeddings to Neo4j')

        # optionally rebuild FAISS from all embeddings
        if rebuild_faiss:
            # read all embeddings and rebuild via existing pattern
            all_rows = []
            with drv.session() as s:
                cur = s.run('MATCH (e:Element) WHERE e.embedding IS NOT NULL RETURN e.id as id, e.embedding as embedding, e.file_id as file, e.tag as tag, e.xpath as xpath, e.text as text')
                for rec in cur:
                    embv = rec['embedding']
                    if embv is None:
                        continue
                    all_rows.append({'id': rec['id'], 'embedding': embv, 'file': rec['file'], 'tag': rec['tag'], 'xpath': rec['xpath'], 'text': rec['text']})
            if all_rows:
                try:
                    import faiss as _faiss
                except Exception:
                    print('faiss not available; cannot rebuild FAISS')
                else:
                    arr = np_local.vstack([np_local.asarray(r['embedding'], dtype='float32') for r in all_rows])
                    dim = arr.shape[1]
                    index = _faiss.IndexFlatL2(dim)
                    getattr(index, 'add')(arr)
                    _faiss.write_index(index, faiss_out)
                    meta_out = Path(faiss_out).with_suffix('.meta.json')
                    with meta_out.open('w', encoding='utf-8') as mf:
                        json.dump([{'id':r['id'],'file':r['file'],'tag':r['tag'],'xpath':r['xpath'],'text': (r['text'] or '')[:300]} for r in all_rows], mf, ensure_ascii=False, indent=2)
                    print('FAISS index written to', faiss_out, 'meta to', str(meta_out))

        return len(emb_rows)
    finally:
        try:
            drv.close()
        except Exception:
            pass


if __name__ == "__main__":
    main()
