"""LLM helper: load local HF models and generate text from a prompt.

This module provides two small helpers intended for use by the RAG
integration scripts:

- choose_device(): return a best-effort device string: 'cuda', 'mps' or 'cpu'.
- generate_from_prompt(...): convenience wrapper that loads the tokenizer
  and causal LM and performs a short generation. It caches loaded
  model/tokenizer pairs to avoid repeated downloads/initialization.

Notes:
- The function aims to be defensive: if transformers is missing it raises a
  helpful error. It attempts to use bitsandbytes for 8-bit loading when
  available and CUDA is present, and uses MPS-specific dtype when running on
  Apple's silicon.
"""

import torch
from typing import Optional, Any, cast

try:
    from transformers import AutoTokenizer, AutoModelForCausalLM
except Exception:
    AutoTokenizer = None
    AutoModelForCausalLM = None

# Try to detect bitsandbytes availability (optional for 8-bit loading)
try:
    import bitsandbytes as bnb  # type: ignore
    BNB_AVAILABLE = True
except Exception:
    BNB_AVAILABLE = False

# Simple in-process cache so repeated calls don't re-download models/tokenizers
_MODEL_CACHE = {}
_TOKENIZER_CACHE = {}


def choose_device() -> str:
    """Return preferred device string for model loading/execution.

    Order of preference: CUDA (if available) -> MPS (Apple silicon) -> CPU.
    """
    if torch.cuda.is_available():
        return "cuda"
    if hasattr(torch.backends, "mps") and torch.backends.mps.is_available():
        return "mps"
    return "cpu"


def _load_model_and_tokenizer(model_name: str, trust_remote_code: bool = False):
    """Load and cache a HF tokenizer and causal LM for the given model.

    This helper encapsulates device/precision choices and supports using
    bitsandbytes when available for memory-efficient 8-bit loading on CUDA.
    """
    if model_name in _MODEL_CACHE and model_name in _TOKENIZER_CACHE:
        return _MODEL_CACHE[model_name], _TOKENIZER_CACHE[model_name]

    device = choose_device()

    # Defensive: ensure transformers symbols are available; this also helps
    # static analyzers (e.g., Pylance) narrow the types of AutoTokenizer/Model.
    if AutoTokenizer is None or AutoModelForCausalLM is None:
        raise RuntimeError("transformers library is required for model loading")

    # Tokenizer: use_fast for performance when available
    tokenizer = AutoTokenizer.from_pretrained(
        model_name, use_fast=True, trust_remote_code=trust_remote_code
    )

    load_kwargs = {}
    if device == "cuda" and BNB_AVAILABLE:
        # Use 8-bit with device_map for large models when bitsandbytes is installed
        load_kwargs.update({"load_in_8bit": True, "device_map": "auto"})
    elif device == "mps":
        # MPS backend benefits from float16 tensors for many HF models
        load_kwargs.update({"dtype": torch.float16})
    else:
        # CPU fallback — rely on transformers defaults
        load_kwargs.update({"device_map": None})

    model = AutoModelForCausalLM.from_pretrained(
        model_name, trust_remote_code=trust_remote_code, **load_kwargs
    )

    # When device_map is not used, explicitly move model to the selected device
    if hasattr(model, "to") and load_kwargs.get("device_map") in (None, "auto"):
        # Use a cast to Any to avoid static type checker complaints about
        # differing model signatures across HF versions. At runtime this
        # simply calls the model's .to(device) method.
        _m = cast(Any, model)
        if device == "cuda":
            _m.to(torch.device("cuda"))
        elif device == "mps":
            _m.to(torch.device("mps"))
        else:
            _m.to(torch.device("cpu"))

    _MODEL_CACHE[model_name] = model
    _TOKENIZER_CACHE[model_name] = tokenizer
    return model, tokenizer


def generate_from_prompt(
    prompt: str,
    model_name: str = "gpt2",
    max_new_tokens: int = 128,
    temperature: float = 0.7,
    trust_remote_code: bool = False,
    **gen_kwargs,
) -> str:
    """Generate text from `prompt` using a HF causal LM.

    Parameters
    - prompt: full prompt string (system+context+user) to feed to the model.
    - model_name: HF model identifier (e.g., 'gpt2' or 'kakaocorp/kanana-nano-2.1b-base').
    - max_new_tokens: maximum number of tokens to generate.
    - temperature: sampling temperature (applied only when sampling is enabled).
    - trust_remote_code: pass-through to transformers when model requires remote code.
    - gen_kwargs: additional kwargs passed directly to `model.generate`.

    Returns the model-generated string (prompt prefix is removed when present).
    """
    if AutoTokenizer is None or AutoModelForCausalLM is None:
        raise RuntimeError("transformers not installed in environment")

    model, tokenizer = _load_model_and_tokenizer(
        model_name, trust_remote_code=trust_remote_code
    )

    device = choose_device()

    # Tokenize prompt
    inputs = tokenizer(prompt, return_tensors="pt")
    input_ids = inputs["input_ids"]

    # Ensure pad token exists to avoid generation errors when using attention masks
    if tokenizer.pad_token is None:
        tokenizer.pad_token = tokenizer.eos_token

    attention_mask = inputs.get("attention_mask")

    # Move tensors to device if needed
    if device == "cuda":
        input_ids = input_ids.cuda()
        if attention_mask is not None:
            attention_mask = attention_mask.cuda()
    elif device == "mps":
        input_ids = input_ids.to("mps")
        if attention_mask is not None:
            attention_mask = attention_mask.to("mps")

    generation_params = {
        "input_ids": input_ids,
        "max_new_tokens": max_new_tokens,
        "pad_token_id": tokenizer.pad_token_id,
    }
    # Merge user-supplied generation kwargs (e.g., do_sample=False)
    generation_params.update(gen_kwargs)

    if attention_mask is not None:
        generation_params["attention_mask"] = attention_mask

    # Only set temperature when sampling is enabled
    do_sample = generation_params.get("do_sample", True)
    if do_sample:
        generation_params["temperature"] = temperature

    # Perform generation under no_grad for efficiency
    with torch.no_grad():
        outputs = model.generate(**generation_params)

    text = tokenizer.decode(outputs[0], skip_special_tokens=True)
    # If the model echoed the prompt, strip it to return only the generated portion
    if text.startswith(prompt):
        return text[len(prompt) :].strip()
    return text
