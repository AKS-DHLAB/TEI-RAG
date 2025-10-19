import os
from pathlib import Path
import configparser
from typing import Dict, Optional
import threading

# ----------------
# Settings loader
# ----------------


def _read_dotenv(path: Path) -> Dict[str, str]:
    out = {}
    if not path.exists():
        return out
    try:
        for line in path.read_text(encoding='utf-8').splitlines():
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            if '=' in line:
                k, v = line.split('=', 1)
                out[k.strip()] = v.strip().strip('"').strip("'")
    except Exception:
        return {}
    return out


def load_settings() -> Dict[str, str]:
    settings: Dict[str, str] = {}
    settings.update({k: v for k, v in os.environ.items()})
    # .env located at repo root (one level above scripts/)
    root = Path(__file__).resolve().parents[1]
    dotenv = root / '.env'
    settings.update(_read_dotenv(dotenv))

    cfg_path = root / 'config' / 'neo4j.ini'
    if cfg_path.exists():
        cp = configparser.ConfigParser()
        try:
            cp.read(cfg_path)
            sec = None
            if 'neo4j' in cp:
                sec = cp['neo4j']
            elif cp.sections():
                sec = cp[cp.sections()[0]]
            if sec is not None:
                for k in ('uri', 'user', 'password', 'NEO4J_URI', 'NEO4J_USER', 'NEO4J_PASSWORD'):
                    if k in sec:
                        v = sec.get(k)
                        if v is not None:
                            settings[k] = v
                if 'uri' in sec:
                    v = sec.get('uri')
                    if v is not None:
                        settings['NEO4J_URI'] = v
                if 'user' in sec:
                    v = sec.get('user')
                    if v is not None:
                        settings['NEO4J_USER'] = v
                if 'password' in sec:
                    v = sec.get('password')
                    if v is not None:
                        settings['NEO4J_PASSWORD'] = v
        except Exception:
            pass

    return settings


def get_neo4j_credentials() -> Dict[str, Optional[str]]:
    s = load_settings()
    return {
        'uri': s.get('NEO4J_URI') or s.get('uri') or 'bolt://localhost:7687',
        'user': s.get('NEO4J_USER') or s.get('user') or 'neo4j',
        'password': s.get('NEO4J_PASSWORD') or s.get('password'),
    }


def get_setting(key: str, default: Optional[str] = None) -> Optional[str]:
    return load_settings().get(key, default)


# ----------------
# Embedder cache
# ----------------

_emb_lock = threading.Lock()
_emb_cache: dict = {}


from typing import Optional


def get_cached_embedder(model_name: Optional[str] = None):
    if model_name is None:
        model_name = DEFAULT_EMBED_MODEL
    key = f"embedder::{model_name}"
    with _emb_lock:
        if key in _emb_cache:
            return _emb_cache[key]
        try:
            # Try SentenceTransformer first (convenient API)
            from sentence_transformers import SentenceTransformer
            import torch
            sbert_device = 'cuda' if torch.cuda.is_available() else ('mps' if getattr(torch.backends, 'mps', None) is not None and torch.backends.mps.is_available() else 'cpu')
            model = SentenceTransformer(model_name, device=sbert_device)
            _emb_cache[key] = model
            return model
        except Exception:
            # Fallback: use Hugging Face AutoModel + AutoTokenizer to build an
            # embedder with a compatible `.encode()` method.
            try:
                from transformers import AutoTokenizer, AutoModel
                import torch
                import numpy as _np

                device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
                tok = AutoTokenizer.from_pretrained(model_name, use_fast=True)
                m = AutoModel.from_pretrained(model_name)
                m.to(device)

                class HFEmbedder:
                    def __init__(self, tokenizer, model, device):
                        self.tokenizer = tokenizer
                        self.model = model
                        self.device = device

                    def encode(self, texts, show_progress_bar=False, convert_to_numpy=True, batch_size=32):
                        # accept a list of strings; return numpy array
                        import math
                        all_vecs = []
                        for i in range(0, len(texts), batch_size):
                            batch = texts[i:i+batch_size]
                            enc = self.tokenizer(batch, padding=True, truncation=True, return_tensors='pt')
                            input_ids = enc['input_ids'].to(self.device)
                            attention_mask = enc['attention_mask'].to(self.device)
                            with torch.no_grad():
                                out = self.model(input_ids=input_ids, attention_mask=attention_mask)
                                last = out.last_hidden_state
                                mask = attention_mask.unsqueeze(-1).expand(last.size()).float()
                                summed = (last * mask).sum(1)
                                counts = mask.sum(1)
                                counts = _np.where(counts.cpu().numpy() == 0, 1, counts.cpu().numpy())
                                avg = summed.cpu().numpy() / counts
                                all_vecs.append(avg)
                        res = _np.vstack(all_vecs)
                        if convert_to_numpy:
                            return res
                        return res.tolist()

                emb = HFEmbedder(tok, m, device)
                _emb_cache[key] = emb
                return emb
            except Exception:
                # Re-raise original exception for caller visibility
                raise


def unload_all_embedders():
    with _emb_lock:
        _emb_cache.clear()


__all__ = [
    'load_settings', 'get_neo4j_credentials', 'get_setting',
    'get_cached_embedder', 'unload_all_embedders', 'DEFAULT_EMBED_MODEL',
]

# Central default for the embedder model. Change this one value to update
# the default model used across the project.
DEFAULT_EMBED_MODEL = "BAAI/bge-m3"
