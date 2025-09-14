# backend/llm.py
from __future__ import annotations
import os, re, time
from typing import Tuple, Dict
import aiohttp  # HTTP для gen-api
import logging

def _load_key() -> str | None:
    p = "/run/secrets/gen_api_key"
    try:
        if os.path.exists(p):
            with open(p, "r", encoding="utf-8") as f:
                k = f.read().strip()
                if k:
                    return k
    except Exception:
        pass
    k = (os.getenv("GEN_API_KEY") or "").strip()
    return k or None

GEN_API_KEY = _load_key()
GEN_API_MODEL = os.getenv("GEN_API_MODEL", "gpt-4o-mini-2024-07-18")
GEN_API_ENDPOINT = os.getenv("GEN_API_ENDPOINT", "https://api.gen-api.ru/api/v1/networks/gpt-4o-mini")

_CACHE_TTL = 1
_CACHE: Dict[str, tuple[float, str]] = {}

_SYSTEM_PROMPT = (
    "Ты помощник для калькулятора. Пользователь даёт запрос (RU/EN) о реальных величинах. "
    "Верни ТОЛЬКО одно математическое выражение, пригодное для локального вычисления. "
    "Без слов и единиц измерения\величины. Разрешены цифры, точка, + - * / ^ и скобки. "
    "Если нужно — выполни конвертацию/поиск и подставь числа. "
    "Примеры: 324+100, 2+2*2, (299792458/1000), 3.1425926. "
    "Не используй переменные, функции, и не предполагай параметризованные данные. "
    "Если ответ не однозначный, дай наиболее правдоподобный"
)
_EXPR_RX = re.compile(r'^[\d\s+*\-\/^().]+$')
def _valid_expr(s: str) -> bool:
    return bool(s.strip()) and _EXPR_RX.match(s.strip()) is not None

logger = logging.getLogger("calculator.llm")
async def ask_llm(request: str) -> Tuple[bool, str]:
    """Вернёт (True, '<выражение>') либо (False, '<ошибка>')."""
    if not request or not request.strip():
        return False, "пустой запрос"

    now = time.time()
    cached = _CACHE.get(request)
    if cached and now - cached[0] < _CACHE_TTL:
        logger.info(f"LLM cache hit for request: {request}")
        return True, cached[1]

    if not GEN_API_KEY:
        logger.error("AI key is not configured")
        return False, "AI key is not configured"

    payload = {
        "is_sync": True,
        "messages": [
            {"role": "system", "content": _SYSTEM_PROMPT},
            {"role": "user", "content": request},
        ],
        "model": GEN_API_MODEL,
        "stream": False,
        "max_tokens": 128,
    }
    headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": f"Bearer {GEN_API_KEY}",
    }

    try:
        async with aiohttp.ClientSession() as session:
            async with session.post(GEN_API_ENDPOINT, json=payload, headers=headers, timeout=30) as response:
                status_code = response.status
                if status_code == 200:
                    data = await response.json()
                else:
                    txt = (await response.text() or "")[:200]
                    logger.error(f"AI provider error: {txt}")
                    return False, f"AI provider error: {txt}"
    except Exception as e:
        logger.error(f"Network error to LLM: {e}")
        return False, f"ошибка сети к LLM: {e}"

    # DEBUG при необходимости: export DEBUG_LLM=1
    if os.getenv("DEBUG_LLM") == "1":
        print("DEBUG LLM raw:", data)

    # 1) известные схемы
    content = None
    try:
        content = data["choices"][0]["message"]["content"]
    except Exception:
        pass
    if content is None:
        try:
            content = data["choices"][0]["text"]
        except Exception:
            pass
    if content is None:
        content = (data.get("result") or {}).get("output_text")
    if content is None:
        content = data.get("response") or data.get("message") or data.get("content")

    def _to_text(x):
        if isinstance(x, str):
            return x
        if isinstance(x, list):
            parts = []
            for item in x:
                t = _to_text(item)
                if t:
                    parts.append(t)
            return " ".join(parts) if parts else None
        if isinstance(x, dict):
            for k in ("content", "text", "message", "output_text", "response"):
                if k in x:
                    t = _to_text(x[k])
                    if t:
                        return t
            parts = []
            for v in x.values():
                t = _to_text(v)
                if t:
                    parts.append(t)
            return " ".join(parts) if parts else None
        return None

    content = _to_text(content)

    # 2) универсальный поиск первой «математической» строки
    def iter_strings(obj):
        if isinstance(obj, str):
            yield obj
        elif isinstance(obj, dict):
            for v in obj.values():
                yield from iter_strings(v)
        elif isinstance(obj, list):
            for v in obj:
                yield from iter_strings(v)

    if not content:
        for s in iter_strings(data):
            s_clean = (s or "").strip().strip("`").replace(",", ".")
            if _valid_expr(s_clean):
                content = s_clean
                break

    if not content:
        logger.error("Empty response from LLM")
        return False, "пустой ответ LLM"

    expr = (content or "").strip().strip("`").replace(",", ".")
    if not _valid_expr(expr):
        m = re.search(r'[\d(][\d\s+*\-\/^().]*[\d)]', expr)
        if m:
            expr = m.group(0)
    if not _valid_expr(expr):
        logger.error(f"LLM returned invalid expression: {expr}")
        return False, "LLM вернул невычислимое выражение"

    logger.info(f"LLM response for request '{request}': {expr}")
    _CACHE[request] = (now, expr)
    return True, expr
