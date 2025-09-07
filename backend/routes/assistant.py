# backend/routes/assistant.py
from __future__ import annotations
import re
from typing import Dict, Tuple

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from llm import ask_llm
from routes.calculate import calculate_expression

router = APIRouter(prefix="/assistant", tags=["assistant"])

class AICalcRequest(BaseModel):
    expression: str

class AICalcResponse(BaseModel):
    resolved_expression: str
    value: float
    explanation: dict

_AI_RX = re.compile(r'AI\s*\(', re.I)

def _find_ai_calls(s: str) -> Dict[Tuple[int, int], str]:
    """Находит все AI(...), поддерживает вложенные скобки."""
    out = {}; i = 0
    while True:
        m = _AI_RX.search(s, i)
        if not m: break
        j, depth, k = m.end(), 1, m.end()
        while k < len(s) and depth > 0:
            if s[k] == '(': depth += 1
            elif s[k] == ')': depth -= 1
            k += 1
        if depth != 0:
            raise ValueError("Unbalanced parentheses in AI()")
        out[(m.start(), k)] = s[j:k-1].strip()
        i = k
    return out

@router.post("/ai-eval", response_model=AICalcResponse, summary="Вычислить выражение с AI()")
def ai_eval(req: AICalcRequest):
    expr_in = req.expression
    calls = _find_ai_calls(expr_in)

    resolved = expr_in
    replacements: Dict[str, str] = {}

    for (start, end), inner in sorted(calls.items(), key=lambda kv: kv[0][0], reverse=True):
        ok, expr = ask_llm(inner)
        if not ok:
            # по тз: 500 только когда метод используется и ключа/ответа нет
            raise HTTPException(status_code=500, detail=expr)
        resolved = resolved[:start] + f"({expr})" + resolved[end:]
        replacements[inner] = expr

    # считаем локальным калькулятором
    result = calculate_expression(resolved)
    # конвератция к типу ответа (модель/словарь/число)
    if isinstance(result, dict) and "value" in result:
        val = float(result["value"])
    elif hasattr(result, "value"):
        val = float(result.value)
    elif isinstance(result, (int, float)):
        val = float(result)
    else:
        msg = getattr(result, "message", "calculation error")
        raise HTTPException(status_code=400, detail=msg)

    return AICalcResponse(
        resolved_expression=resolved,
        value=val,
        explanation={
            "original": expr_in,
            "replacements": replacements,
            "notes": "AI() → выражение через gen-api; кэш 24ч",
        },
    )
