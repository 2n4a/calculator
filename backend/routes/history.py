from typing import Literal, Annotated

from fastapi import APIRouter, Query, status
from pydantic import Field, BaseModel
import datetime

from models import HistoryItem


class HistoryParams(BaseModel):
    limit: int = Field(25, ge=1, le=500, description="Максимальное количество элементов в ответе.")
    offset: int = Field(0, ge=0, description="Смещение от начала истории.")
    order: Literal["asc", "desc"] = Field("desc", description="Порядок сортировки: 'asc' - по возрастанию, 'desc' - по убыванию.")
    from_timestamp: datetime.datetime = Field(None, description="Начальная временная метка для фильтрации истории (включительно).")
    to_timestamp: datetime.datetime = Field(None, description="Конечная временная метка для фильтрации истории (исключительно).")


router = APIRouter()


@router.get(
    "/history",
    summary="Получение истории вычислений",
    responses={
        status.HTTP_200_OK: {
            "model": list[HistoryItem],
            "description": "История вычислений",
        },
    },
)
async def history(query: Annotated[HistoryParams, Query()]):
    # Заглушка: пока возвращаем пустую историю
    return []

