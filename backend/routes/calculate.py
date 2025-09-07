from decimal import Decimal
from typing import Literal

from math import sqrt, sin, cos, log, tan

from fastapi import APIRouter, status
from starlette.responses import JSONResponse
from pydantic import Field, BaseModel

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


class CalculationError(BaseErrorResponse):
    # Дополнительные детали для ошибок вычисления
    kind: Literal["CalculationError"] = Field("CalculationError", description="Тип ошибки, всегда 'CalculationError'.")
    span: Span | None = Field(None, description="Диапазон символов, вызвавших ошибку.")
    operator_span: Span | None = Field(None, description="Диапазон символов оператора, вызвавшего ошибку.")
    operands: list[OperandMeta] | None = Field(None, description="Список операндов на момент ошибки.")
    parenthesized: str | None = Field(None, description="Выражение с расставленными скобками на момент ошибки.")



def check_first_symbol_error(expression : str):  # just checking for a dumb errors
    if expression[0] == '+' or expression[0] == '*' or expression[0] == '/' or expression[0] == '^':
        return False
    return True

def check_brackets_error(expression : str):      # checking for a correct brackets sequence
    stack = []
    for char in expression:
        if len(stack) != 0 and char == ')' and stack[-1] == '(':
            stack.pop()
        elif char == '(' or char == ')':
            stack.append(char)

    if len(stack) == 0:
        return True
    else:
        return False

def refactor_unary_minuses(expression : str):     # refactoring given expression:  -x  ->  0-x    and skipping spaces
    new_expression = ""
    for i in range(len(expression)):
        if expression[i] != ' ':
            new_expression += expression[i]

        if i + 1 < len(expression) and expression[i] == '(' and expression[i + 1] == '-':
            new_expression += '0'

    if new_expression[0] == '-':
        new_expression = '0' + new_expression

    return new_expression

def wrong_format_of_expression_error(expression : str):
    for i in range(len(expression) - 1):
        if ((expression[i] == '-' or expression[i] == '+' or expression[i] == '*' or expression[i] == '/' or expression[i] == '^') and
            (expression[i + 1] != '(' and expression[i + 1] != 's' and expression[i + 1] != 'c' and expression[i + 1] != 't' and
             expression[i + 1] != 'l') and (not (expression[i + 1] >= '0' and expression[i + 1] <= '9'))):
            return False


        if (not (expression[i] >= '0' and expression[i] <= '9')) and expression[i] != ')' and (
                expression[i + 1] == '/' or expression[i + 1] == '*'):
            return False

    if expression[-1] == '+' or expression[-1] == '-' or expression[-1] == '*' or expression[-1] == '/' or expression[-1] == '^':
        return False


    count_of_numbers = 0
    i = 0
    while i < len(expression):
        if expression[i] >= '0' and expression[i] <= '9':
            count_of_numbers += 1
        elif expression[i] == '(' or expression[i] == ')' or expression[i] == '+' or expression[i] == '-' or expression[i] == '*' or expression[
            i] == '/' or expression[i] == '^':
            ok = ':)'
        elif i + 5 < len(expression) and expression[i] == 's' and expression[i + 1] == 'q' and expression[
            i + 2] == 'r' and expression[i + 3] == 't' and expression[i + 4] == '(' and expression[i + 5] != ')':
            i += 4
        elif i + 4 < len(expression) and expression[i] == 's' and expression[i + 1] == 'i' and expression[
            i + 2] == 'n' and expression[i + 3] == '(' and expression[i + 4] != ')':
            i += 3
        elif i + 4 < len(expression) and expression[i] == 'c' and expression[i + 1] == 'o' and expression[
            i + 2] == 's' and expression[i + 3] == '(' and expression[i + 4] != ')':
            i += 3
        elif i + 3 < len(expression) and expression[i] == 't' and expression[i + 1] == 'g' and expression[
            i + 2] == '(' and expression[i + 3] != ')':
            i += 2
        elif i + 3 < len(expression) and expression[i] == 'l' and expression[i + 1] == 'n' and expression[
            i + 2] == '(' and expression[i + 3] != ')':
            i += 2
        else:
            return False

        i += 1

    if count_of_numbers == 0:
        return False

    return True


def parse_expression(expression : str, operations_priorities):  # parsing from default expression to RPN
    v = []
    leftstack, rightstack = [], []

    i = 0
    while i < len(expression):
        count = 0
        current_number = ''
        while i < len(expression) and expression[i] >= '0' and expression[i] <= '9':
            count += 1
            current_number += expression[i]
            i += 1

        if count != 0:
            leftstack.append(current_number)
            i -= 1

        if expression[i] == '(':
            rightstack.append(expression[i])

        if expression[i] == ')':
            while len(rightstack) > 0 and rightstack[-1] != '(':
                current_element = ''
                current_element += rightstack[-1]
                rightstack.pop()
                leftstack.append(current_element)

            rightstack.pop()

        if expression[i] == '+' or expression[i] == '-' or expression[i] == '*' or expression[i] == '/' or (
                    expression[i] == 's' and expression[i + 1] == 'i') or (
                    expression[i] == 's' and expression[i + 1] == 'q') or (
                    expression[i] == 'l' and expression[i + 1] == 'n') or (
                    expression[i] == 't' and expression[i + 1] == 'g') or expression[i] == '^' or (
                    expression[i] == 'c' and expression[i + 1] == 'o'):
            while len(rightstack) > 0 and operations_priorities[expression[i]] <= operations_priorities[rightstack[-1]]:
                current_element = ''
                current_element += rightstack[-1]
                rightstack.pop()
                leftstack.append(current_element)

            if expression[i] == '+' or expression[i] == '-' or expression[i] == '*' or expression[i] == '/' or \
                    expression[i] == '^':
                rightstack.append(expression[i])
            else:
                if expression[i] == 's' and expression[i + 1] == 'i':
                    rightstack.append('s')
                elif expression[i] == 's' and expression[i + 1] == 'q':
                    rightstack.append('k')     # nu tipo koren
                elif expression[i] == 'l' and expression[i + 1] == 'n':
                    rightstack.append('l')
                elif expression[i] == 'c' and expression[i + 1] == 'o':
                    rightstack.append('c')
                elif expression[i] == 't' and expression[i + 1] == 'g':
                    rightstack.append('t')

        i += 1

    while len(rightstack) > 0:
        current_element = rightstack[-1]
        rightstack.pop()
        leftstack.append(current_element)

    while len(leftstack) > 0:
        v.append(leftstack[-1])
        leftstack.pop()

    v = reversed(v)

    return v

def get_first_second(stack):
    second = stack[-1]
    stack.pop()
    first = stack[-1]
    stack.pop()

    return first, second, stack

def get_first(stack):
    first = stack[-1]
    stack.pop()

    return first, stack


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
    expression = req.expression

    operations_priorities = dict()   # priorities of operations
    operations_priorities['('] = 0;
    operations_priorities['+'] = 1;
    operations_priorities['-'] = 1;
    operations_priorities['*'] = 2;
    operations_priorities['/'] = 2;
    operations_priorities['^'] = 3;
    operations_priorities['l'] = 4;
    operations_priorities['s'] = 4;
    operations_priorities['c'] = 4;
    operations_priorities['t'] = 4;
    operations_priorities['k'] = 4;

    flag = True & check_first_symbol_error(expression) & check_brackets_error(expression)
    if (flag == False):
        return JSONResponse(
            CalculationError(
                message="wrong format of expression",
            ).model_dump(),
            status_code=status.HTTP_412_PRECONDITION_FAILED
        )

    expression = refactor_unary_minuses(expression)

    flag = flag & wrong_format_of_expression_error(expression)
    if (flag == False):
        return JSONResponse(
            CalculationError(
                message="wrong format of expression",
            ).model_dump(),
            status_code=status.HTTP_412_PRECONDITION_FAILED
        )

    # main calculations
    vec = parse_expression(expression, operations_priorities)
    stack = []
    for char in vec:
        if char == '+':
            first, second, stack = get_first_second(stack)

            stack.append(first + second)
        elif char == '-':
            first, second, stack = get_first_second(stack)

            stack.append(first - second)
        elif char == '*':
            first, second, stack = get_first_second(stack)

            stack.append(first * second)
        elif char == '/':
            first, second, stack = get_first_second(stack)

            if second == 0:
                return JSONResponse(
                    CalculationError(
                        message="division by zero",
                    ).model_dump(),
                    status_code=status.HTTP_412_PRECONDITION_FAILED
                )

            stack.append(first / second)
        elif char == '^':
            first, second, stack = get_first_second(stack)

            stack.append(first ** second)
        elif char == "s":
            first, stack = get_first(stack)

            stack.append(sin(first))
        elif char == "c":
            first, stack = get_first(stack)

            stack.append(cos(first))
        elif char == "k":
            first, stack = get_first(stack)

            if first < 0:
                return JSONResponse(
                    CalculationError(
                        message="sqrt of a negative number",
                    ).model_dump(),
                    status_code=status.HTTP_412_PRECONDITION_FAILED
                )

            stack.append(sqrt(first))
        elif char == "t":
            first, stack = get_first(stack)

            if (cos(first) == 0):
                return JSONResponse(
                    CalculationError(
                        message="trigonometry error",
                    ).model_dump(),
                    status_code=status.HTTP_412_PRECONDITION_FAILED
                )

            stack.append(tan(first));
        elif char == "l":
            first, stack = get_first(stack)

            if first <= 0:
                return JSONResponse(
                    CalculationError(
                        message="ln of a non-positive number",
                    ).model_dump(),
                    status_code=status.HTTP_412_PRECONDITION_FAILED
                )

            stack.append(log(first))
        else:
            stack.append(float(char))

    result_of_expression = "{:.8f}".format(stack[0])
    return CalculationSuccess(value=Decimal(result_of_expression))
    #return JSONResponse(
    #    CalculationError(
    #        message="Not implemented yet"
    #    ),
    #    status_code=status.HTTP_412_PRECONDITION_FAILED
    #)

