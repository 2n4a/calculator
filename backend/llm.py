# backend/llm.py
from __future__ import annotations
import os, re, time
from typing import Tuple, Dict
import aiohttp  # HTTP для gen-api

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
GEN_API_MODEL = os.getenv("GEN_API_MODEL", "gpt-4.1-nano")
GEN_API_ENDPOINT = os.getenv("GEN_API_ENDPOINT", "https://api.gen-api.ru/api/v1/networks/gpt-4-1")

#тут еще нужно закэшировать в бд, но пока ветка бд еще не готова
# кэш в памяти (TTL 24ч)
_CACHE_TTL = 24 * 3600
_CACHE: Dict[str, tuple[float, str]] = {}

_SYSTEM_PROMPT = (
    "Ты помощник для калькулятора. Пользователь даёт запрос (RU/EN) о реальных величинах. "
    "Верни ТОЛЬКО одно математическое выражение, пригодное для локального вычисления. "
    "Без слов и единиц измерения\величины. Разрешены цифры, точка, + - * / ^ и скобки. "
    "Если нужно — выполни конвертацию/поиск и подставь числа. "
    "Примеры: 324+100, 2+2*2, (299792458/1000), 3.1425926."
)
_EXPR_RX = re.compile(r'^[\d\s+*\-\/^().]+$')
def _valid_expr(s: str) -> bool:
    return bool(s.strip()) and _EXPR_RX.match(s.strip()) is not None

async def ask_llm(request: str) -> Tuple[bool, str]:
    """Вернёт (True, '<выражение>') либо (False, '<ошибка>')."""
    if not request or not request.strip():
        return False, "пустой запрос"

    now = time.time()
    cached = _CACHE.get(request)
    if cached and now - cached[0] < _CACHE_TTL:
        return True, cached[1]

    if not GEN_API_KEY:
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
        r = aiohttp.post(GEN_API_ENDPOINT, json=payload, headers=headers, timeout=30)
    except Exception as e:
        return False, f"ошибка сети к LLM: {e}"
    if r.status_code != 200:
        return False, f"AI provider error: {r.text[:200]}"

    try:
        data = r.json()
    except ValueError:
        txt = (r.text or "")[:200]
        return False, f"некорректный JSON от LLM: {txt}"


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
        return False, "пустой ответ LLM"

    expr = (content or "").strip().strip("`").replace(",", ".")
    if not _valid_expr(expr):
        m = re.search(r'[\d(][\d\s+*\-\/^().]*[\d)]', expr)
        if m:
            expr = m.group(0)
    if not _valid_expr(expr):
        return False, "LLM вернул невычислимое выражение"

    _CACHE[request] = (now, expr)
    return True, expr
