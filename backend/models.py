import datetime
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

    def __or__(self, other):
        """Объединение двух диапазонов."""
        return Span(start=min(self.start, other.start), end=max(self.end, other.end))


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


class HistoryItem(BaseModel):
    id: str | int = Field(..., description="Уникальный идентификатор записи в истории.")
    expression: str = Field(..., description="Математическое выражение.")
    result: str = Field(..., description="Результат вычисления выражения.")
    timestamp: datetime.datetime = Field(..., description="Временная метка вычисления.")
