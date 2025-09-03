from fastapi import APIRouter

from models import Unit

router = APIRouter()


@router.get(
    "/liveness",
    summary="Проверка состояния сервиса",
)
async def liveness() -> Unit:
    return Unit()
