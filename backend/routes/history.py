from typing import Literal, Annotated
import logging

from fastapi import APIRouter, Query, status
from pydantic import Field, BaseModel
import datetime

from models import HistoryItem

import sqlite3

history_db_name = 'history.db'

table_name = 'history'

logger = logging.getLogger("calculator.history")


class HistoryParams(BaseModel):
    limit: int = Field(25, ge=1, le=500, description="Максимальное количество элементов в ответе.")
    offset: int = Field(0, ge=0, description="Смещение от начала истории.")
    order: Literal["asc", "desc"] = Field("desc",
                                          description="Порядок сортировки: 'asc' - по возрастанию, 'desc' - по убыванию.")
    from_timestamp: datetime.datetime = Field(None,
                                              description="Начальная временная метка для фильтрации истории (включительно).")
    to_timestamp: datetime.datetime = Field(None,
                                            description="Конечная временная метка для фильтрации истории (исключительно).")


def handle_history_table_create():
    logger.info("Creating history table if not exists.")
    connection = sqlite3.connect(history_db_name)
    cursor = connection.cursor()
    cursor.execute(
        f"CREATE TABLE IF NOT EXISTS {table_name} ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "query TEXT,"
        "response TEXT,"
        "created_at INTEGER);"
    )

    connection.commit()

    connection.close()


def add_new_history_item(item: HistoryItem):
    logger.info(f"Adding new history item: {item.expression} = {item.result}")
    connection = sqlite3.connect(history_db_name)
    cursor = connection.cursor()

    expression: str = item.expression
    result: str = item.result
    timestamp: datetime.datetime = item.timestamp

    try:
        cursor.execute(
            f"""
            INSERT INTO {table_name} (query, response, created_at)
            VALUES (?, ?, ?)
            """,
            (expression, result, timestamp.timestamp())
        )
    except sqlite3.OperationalError:
        handle_history_table_create()
        cursor.execute(
            f"""
                    INSERT INTO {table_name} (query, response, created_at)
                    VALUES (?, ?, ?)
                    """,
            (expression, result, timestamp.timestamp())
        )

    connection.commit()

    connection.close()


def get_history(cursor: sqlite3.Cursor, query: HistoryParams):
    logger.info(f"Fetching history: limit={query.limit}, offset={query.offset}, order={query.order}")
    from_ts = query.from_timestamp
    to_ts = query.to_timestamp
    order = query.order
    if order is None:
        order = "desc"
    limit = query.limit
    offset = query.offset

    where_params = []
    additional_params = []

    if from_ts is not None:
        where_params.append(f"created_at >= {from_ts}")

    if to_ts is not None:
        where_params.append(f"created_at < {to_ts}")

    where_sql = "WHERE " + " AND ".join(where_params) if where_params else ""

    if limit is not None:
        additional_params.append(f"LIMIT {limit}")

    if offset is not None:
        additional_params.append(f"OFFSET {offset}")

    additional_params_sql = " ".join(additional_params) if additional_params else ""

    try:
        raw_data = cursor.execute(
            f"""
                            SELECT id, query, response, created_at
                            FROM {table_name}
                            {where_sql}
                            ORDER BY created_at {order}
                            {additional_params_sql}
                            """)
    except sqlite3.OperationalError:
        handle_history_table_create()
        return []

    result = []

    for row in raw_data:
        result.append(
            HistoryItem(
                id=row[0],
                expression=row[1],
                result=row[2],
                timestamp=row[3]
            )
        )

    return result


router = APIRouter()

handle_history_table_create()


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
    connection = sqlite3.connect(history_db_name)
    cursor = connection.cursor()

    data = get_history(cursor, query)

    connection.commit()

    connection.close()

    return data