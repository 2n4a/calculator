from decimal import Decimal
from pyexpat.errors import messages
from typing import Literal

from fastapi import APIRouter, status
from starlette.responses import JSONResponse
from pydantic import Field, BaseModel, field_serializer

from models import (
    BaseRequest,
    BaseSuccessResponse,
    BaseErrorResponse,
    Span,
)


class OperandMeta(BaseModel):
    """Метаданные операнда в выражении."""
    span: Span = Field(..., description="Диапазон символов операнда.")
    value: Decimal = Field(..., description="Значение операнда.")


class CalculationRequest(BaseRequest):
    expression: str = Field(..., description="Математическое выражение для вычисления.")
    record: bool = Field(True, description="Флаг, указывающий, нужно ли сохранять результат в историю.")


class CalculationSuccess(BaseSuccessResponse):
    value: Decimal = Field(..., description="Результат вычисления.")
    parenthesized: str | None = Field(None, description="Выражение с расставленными скобками, если применимо.")

    @field_serializer("value")
    def serialize_value(self, value: Decimal) -> str:
        return str(value)


class CalculationError(BaseErrorResponse):
    # Дополнительные детали для ошибок вычисления
    kind: Literal["CalculationError"] = Field("CalculationError", description="Тип ошибки, всегда 'CalculationError'.")
    span: Span | None = Field(None, description="Диапазон символов, вызвавших ошибку.")
    operator_span: Span | None = Field(None, description="Диапазон символов оператора, вызвавшего ошибку.")
    operands: list[OperandMeta] | None = Field(None, description="Список операндов на момент ошибки.")
    parenthesized: str | None = Field(None, description="Выражение с расставленными скобками на момент ошибки.")


router = APIRouter()


@router.post(
    "/calculate",
    summary="Вычисление значения и сохранение в историю",
    responses={
        status.HTTP_200_OK: {
            "model": CalculationSuccess,
            "description": "Успешное вычисление",
        },
        status.HTTP_400_BAD_REQUEST: {
            "model": CalculationError,
            "description": "Ошибка при вычислении",
        },
    },
)
async def calculate(req: CalculationRequest):
    requested_expression = req.expression
    # return CalculationSuccess(value=Decimal(0))

    result: JSONResponse = calculate_values(requested_expression)

    return result


def calculate_values(req: str):

    #тут уже делаем вычисления

    if req.find("1") != -1:
        return JSONResponse(
            CalculationSuccess(value=Decimal(1337)).dict(),
            status_code=status.HTTP_200_OK
        )
    return JSONResponse(
        CalculationError(
            message="Calculation Error"
        ).dict(),
        status_code=status.HTTP_412_PRECONDITION_FAILED
    )
