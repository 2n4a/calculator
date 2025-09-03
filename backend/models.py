from typing import Literal
from pydantic import BaseModel, Field

class Unit(BaseModel):
    """
    Пустой объект
    """
    pass


class Span(BaseModel):
    """Диапазон символов в строке (0-индексация)."""
    start: int = Field(..., description="Начальная позиция (включительно, 0-индексация).")
    end: int = Field(..., description="Конечная позиция (исключительно, 0-индексация).")


class BaseRequest(BaseModel):
    pass


class BaseResponse(BaseModel):
    result: Literal["success", "error"] = Field(..., description="Статус ответа, 'success' или 'error'.")


class BaseSuccessResponse(BaseResponse):
    result: Literal["success"] = Field("success", description="Статус ответа, всегда 'success'.")


class BaseErrorResponse(BaseResponse):
    result: Literal["error"] = Field("error", description="Статус ответа, всегда 'error'.")
    kind: str = Field(..., description="Тип ошибки. Например, 'SyntaxError', 'ZeroDivisionError' и т.д.")
    message: str = Field(..., description="Описание ошибки, человеко-читаемое.")
