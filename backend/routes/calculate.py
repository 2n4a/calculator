import datetime
import itertools
import math
import dataclasses
from decimal import Decimal
from typing import Literal, Callable
import logging

from llm import ask_llm

from fastapi import APIRouter, status
from starlette.responses import JSONResponse
from pydantic import Field, BaseModel

from models import HistoryItem
from routes.history import add_new_history_item

from models import (
    BaseRequest,
    BaseSuccessResponse,
    BaseErrorResponse,
    Span,
)


logger = logging.getLogger("calculator.calculate")


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


@dataclasses.dataclass
class Token:
    span: Span

@dataclasses.dataclass
class NumberToken(Token):
    value: Decimal

@dataclasses.dataclass
class OperatorToken(Token):
    left_spaces: int
    op: str
    right_spaces: int

@dataclasses.dataclass
class ParenToken(Token):
    paren: str

@dataclasses.dataclass
class LlmQueryToken(Token):
    parts: list[str | list[Token]]


@dataclasses.dataclass
class BinaryOperator:
    binding_power: tuple[int, int]
    op: str
    fn: Callable[[Decimal], Decimal] | Callable[[Decimal, Decimal], Decimal]

@dataclasses.dataclass
class UnaryOperator:
    binding_power: int
    op: str
    fn: Callable[[Decimal], Decimal]


BINARY_OPERATORS = {op.op: op for op in [
    BinaryOperator((50, 51), '+', lambda x, y: x + y),
    BinaryOperator((50, 51), '-', lambda x, y: x - y),
    BinaryOperator((60, 61), '*', lambda x, y: x * y),
    BinaryOperator((60, 61), '/', lambda x, y: x / y),
    BinaryOperator((91, 90), '^', lambda x, y: x ** y),
]}

PREFIX_OPERATORS = {
    op.op: op for op in [
        UnaryOperator(70, '+', lambda x: x),
        UnaryOperator(70, '-', lambda x: -x),
        UnaryOperator(70, 'sqrt', lambda x: x.sqrt()),
        UnaryOperator(70, 'sin', lambda x: Decimal(math.sin(float(x)))),
        UnaryOperator(70, 'cos', lambda x: Decimal(math.cos(float(x)))),
        UnaryOperator(70, 'tan', lambda x: Decimal(math.tan(float(x)))),
        UnaryOperator(70, 'tg', lambda x: Decimal(math.tan(float(x)))),
        UnaryOperator(70, 'ln', lambda x: Decimal(math.log(float(x)))),
        UnaryOperator(70, 'log', lambda x: Decimal(math.log(float(x)))),
        UnaryOperator(70, 'abs', lambda x: abs(x)),
        UnaryOperator(70, 'exp', lambda x: Decimal(math.exp(float(x)))),
        UnaryOperator(70, 'asin', lambda x: Decimal(math.asin(float(x)))),
        UnaryOperator(70, 'acos', lambda x: Decimal(math.acos(float(x)))),
        UnaryOperator(70, 'atan', lambda x: Decimal(math.atan(float(x)))),
        UnaryOperator(70, 'floor', lambda x: Decimal(math.floor(float(x)))),
        UnaryOperator(70, 'ceil', lambda x: Decimal(math.ceil(float(x)))),
        UnaryOperator(70, 'deg', lambda x: Decimal(math.degrees(float(x)))),
        UnaryOperator(70, 'rad', lambda x: Decimal(math.radians(float(x)))),
    ]
}

SUFFIX_OPERATORS = {
    op.op: op for op in [
        UnaryOperator(80, '!', lambda x: Decimal(math.gamma(float(x) + 1))),
        UnaryOperator(69, '|>sqrt', lambda x: x.sqrt()),
        UnaryOperator(69, '|>sin', lambda x: Decimal(math.sin(float(x)))),
        UnaryOperator(69, '|>cos', lambda x: Decimal(math.cos(float(x)))),
        UnaryOperator(69, '|>tan', lambda x: Decimal(math.tan(float(x)))),
        UnaryOperator(69, '|>tg', lambda x: Decimal(math.tan(float(x)))),
        UnaryOperator(69, '|>ln', lambda x: Decimal(math.log(float(x)))),
        UnaryOperator(69, '|>log', lambda x: Decimal(math.log(float(x)))),
        UnaryOperator(69, '|>abs', lambda x: abs(x)),
        UnaryOperator(69, '|>exp', lambda x: Decimal(math.exp(float(x)))),
        UnaryOperator(69, '|>asin', lambda x: Decimal(math.asin(float(x)))),
        UnaryOperator(69, '|>acos', lambda x: Decimal(math.acos(float(x)))),
        UnaryOperator(69, '|>atan', lambda x: Decimal(math.atan(float(x)))),
        UnaryOperator(69, '|>floor', lambda x: Decimal(math.floor(float(x)))),
        UnaryOperator(69, '|>ceil', lambda x: Decimal(math.ceil(float(x)))),
        UnaryOperator(69, '|>deg', lambda x: Decimal(math.degrees(float(x)))),
        UnaryOperator(69, '|>rad', lambda x: Decimal(math.radians(float(x)))),
    ]
}


@dataclasses.dataclass
class CalculationException(Exception):
    message: str
    span: Span


def tokenize(expression: str, until: str = None, start_from: int = 0) -> tuple[int, list[Token]]:
    expression = expression.lower()
    i = start_from
    tokens = []
    braces = []
    while i < len(expression):
        if expression[i].isspace():
            i += 1
            continue

        if expression[i].isdigit() or (expression[i] == '.' and i + 1 < len(expression) and expression[i + 1].isdigit()):
            start = i
            has_dot = False
            while i < len(expression) and (expression[i].isdigit() or (expression[i] == '.' and not has_dot)):
                if expression[i] == '.':
                    has_dot = True
                i += 1
            tokens.append(NumberToken(span=Span(start=start, end=i), value=Decimal(expression[start:i])))
            continue

        found_operator = False
        for op in sorted(itertools.chain(
            BINARY_OPERATORS.keys(),
            PREFIX_OPERATORS.keys(),
            SUFFIX_OPERATORS.keys()
        ), key=len, reverse=True):
            op: str
            if expression.startswith(op, i):
                num_spaces_before = 0
                while i - num_spaces_before > 0 and expression[i - num_spaces_before - 1].isspace():
                    num_spaces_before += 1
                num_spaces_after = 0
                while i + len(op) + num_spaces_after < len(expression) and expression[i + len(op) + num_spaces_after].isspace():
                    num_spaces_after += 1
                tokens.append(OperatorToken(
                    span=Span(start=i, end=i+len(op)),
                    op=op,
                    left_spaces=num_spaces_before,
                    right_spaces=num_spaces_after
                ))
                i += len(op)
                found_operator = True
                break
        if found_operator:
            continue

        if expression[i] in '()[]{}':
            if expression[i] in '([{':
                braces.append(expression[i])
                tokens.append(ParenToken(span=Span(start=i, end=i+1), paren='('))
            else:
                flip = {
                    '(': ')', '[': ']', '{': '}',
                    ')': '(', ']': '[', '}': '{',
                }
                closing = expression[i]
                opening = flip[closing]
                while len(braces) > 0:
                    brace = braces.pop()
                    if brace == opening:
                        tokens.append(ParenToken(span=Span(start=i, end=i+1), paren=')'))
                        break
                    else:
                        tokens.append(ParenToken(span=Span(start=i, end=i), paren=')'))
                else:
                    if closing == until:
                        return i, tokens
                    raise CalculationException(
                        message=f"Unopened {opening} closed at {i}",
                        span=Span(start=i, end=i+1)
                    )
            i += 1
            continue

        if (
                expression.startswith('ai', i) or
                expression.startswith('gpt', i) or
                expression.startswith('llm', i) or
                expression.startswith('✨', i)
        ):
            start = i
            i += 2
            while i < len(expression) and expression[i].isspace():
                i += 1
            if i == len(expression) or expression[i] != '(':
                raise CalculationException(
                    message=f"Expected '(' after LLM query at position {start}",
                    span=Span(start=start, end=i),
                )
            i += 1  # skip '('
            parts: list[str | list[Token]] = [""]
            while i < len(expression):
                if expression[i] == ')':
                    i += 1
                    break
                if expression[i] == '{':
                    i, inner_parts = tokenize(expression, until='}', start_from=i + 1)
                    parts.append(inner_parts)
                    parts.append("")
                    i += 1
                else:
                    parts[-1] += expression[i]
                    i += 1
            tokens.append(LlmQueryToken(span=Span(start=start, end=i), parts=parts))
            continue

        raise CalculationException(
            message=f"Unexpected character '{expression[i]}' at position {i}",
            span=Span(start=i, end=i+1)
        )

    while len(braces) > 0:
        braces.pop()
        tokens.append(ParenToken(span=Span(start=i, end=i), paren=')'))

    if until is None:
        assert i == len(expression)

    return i, tokens


@dataclasses.dataclass
class Ast:
    span: Span

@dataclasses.dataclass
class Parenthesized(Ast):
    expr: Ast

@dataclasses.dataclass
class Number(Ast):
    value: Decimal

@dataclasses.dataclass
class BinOp(Ast):
    left: Ast
    op: BinaryOperator
    right: Ast

@dataclasses.dataclass
class UnaryOp(Ast):
    op: UnaryOperator
    operand: Ast
    prefix: bool

@dataclasses.dataclass
class LlmQuery(Ast):
    parts: list[str | Ast]


def parse_expression(tokens: list[Token]) -> Ast:
    if len(tokens) == 0:
        raise CalculationException(
            message="Empty expression",
            span=Span(start=0, end=0)
        )

    def parse_bp(index: int, min_bp: int | float) -> tuple[int, Ast]:
        assert index < len(tokens)
        token = tokens[index]
        lhs = None
        if isinstance(token, NumberToken):
            lhs = Number(span=token.span, value=token.value)
            index += 1
        elif isinstance(token, ParenToken) and token.paren == '(':
            index, inner = parse_bp(index + 1, -float('inf'))
            if index >= len(tokens) or not (isinstance(tokens[index], ParenToken) and tokens[index].paren == ')'):
                raise CalculationException(
                    message=f"Unclosed parenthesis starting at {token.span.start}",
                    span=token.span
                )
            lhs = Parenthesized(span=token.span | tokens[index].span, expr=inner)
            index += 1
        elif isinstance(token, OperatorToken) and token.op in PREFIX_OPERATORS:
            op = token.op
            operator = PREFIX_OPERATORS[op]
            index, rhs = parse_bp(index + 1, operator.binding_power)
            lhs = UnaryOp(span=token.span | rhs.span, op=operator, operand=rhs, prefix=True)
        elif isinstance(token, LlmQueryToken):
            parts: list[str | Ast] = []
            for part in token.parts:
                if isinstance(part, str):
                    parts.append(part)
                else:
                    parts.append(parse_expression(part))
            lhs = LlmQuery(span=token.span, parts=parts)
            index += 1
        else:
            raise CalculationException(
                message=f"Unexpected token {token} at position {token.span.start}",
                span=token.span
            )

        while True:
            if index >= len(tokens):
                break
            token = tokens[index]
            if isinstance(token, OperatorToken) and token.op in SUFFIX_OPERATORS:
                op = token.op
                operator = SUFFIX_OPERATORS[op]
                if operator.binding_power < min_bp:
                    break
                lhs = UnaryOp(span=lhs.span | token.span, op=operator, operand=lhs, prefix=False)
                index += 1
                continue
            if isinstance(token, OperatorToken) and token.op in BINARY_OPERATORS:
                op = token.op
                operator = BINARY_OPERATORS[op]
                lbp, rbp = operator.binding_power
                if lbp < min_bp:
                    break
                index, rhs = parse_bp(index + 1, rbp)
                lhs = BinOp(span=lhs.span | rhs.span, left=lhs, op=operator, right=rhs)
                continue
            break

        return index, lhs

    index, ast = parse_bp(0, -float('inf'))
    if index != len(tokens):
        raise CalculationException(
            message=f"Unexpected token {tokens[index]} at position {tokens[index].span.start}",
            span=tokens[index].span
        )
    return ast


async def eval_ast(node: Ast) -> Decimal:
    if isinstance(node, Number):
        return node.value
    elif isinstance(node, Parenthesized):
        return await eval_ast(node.expr)
    elif isinstance(node, BinOp):
        left_val = await eval_ast(node.left)
        right_val = await eval_ast(node.right)
        try:
            result = node.op.fn(left_val, right_val)
        except Exception as e:
            raise CalculationException(
                message=str(e),
                span=node.span,
            )
        return result
    elif isinstance(node, UnaryOp):
        try:
            result = node.op.fn(await eval_ast(node.operand))
        except Exception as e:
            raise CalculationException(
                message=str(e),
                span=node.span,
            )
        return result
    elif isinstance(node, LlmQuery):
        prompt = ""
        for part in node.parts:
            if isinstance(part, str):
                prompt += part
            else:
                prompt += str(eval_ast(part))
        success, result = await ask_llm(prompt)
        if not success:
            raise CalculationException(
                message=f"LLM error: {result}",
                span=node.span,
            )

        _, tokens = tokenize(result)
        ast = parse_expression(tokens)
        value = await eval_ast(ast)
        return value
    else:
        raise ValueError("Unknown AST node")


async def calculate_expression(expression: str):
    try:
        _, tokens = tokenize(expression)
        ast = parse_expression(tokens)
        value = await eval_ast(ast)
    except CalculationException as e:
        return CalculationError(
            message=e.message,
            span=e.span,
            operator_span=None,
            operands=None,
            parenthesized=None,
        )

    return CalculationSuccess(value=value)


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
    if len(req.expression) > 5000:
        return JSONResponse(
            CalculationError(
                message="Expression too long",
                span=Span(start=5000, end=len(req.expression)),
                operator_span=None,
                operands=None,
                parenthesized=None,
            ).model_dump(),
            status_code=status.HTTP_400_BAD_REQUEST
        )
    logger.info(f"Received calculation request: {req.expression}")
    result = await calculate_expression(req.expression)
    if isinstance(result, CalculationError):
        logger.error(f"Calculation error: {result.message} (span={result.span})")
        return JSONResponse(
            result.model_dump(),
            status_code=status.HTTP_400_BAD_REQUEST
        )
    elif req.record:
        logger.info(f"Storing calculation result for expression: {req.expression}")
        add_new_history_item(
            HistoryItem(
                id=0,
                expression=req.expression,
                result=str(result.value),
                timestamp=datetime.datetime.now()
            )
        )
    logger.info(f"Calculation result: {getattr(result, 'value', None)} for expression: {req.expression}")
    return result

async def test_calculate():
    assert (await calculate_expression("2 + 2")).value == 4
    assert (await calculate_expression("2 + 2 * 2")).value == 6
    assert (await calculate_expression("2 * 2 + 2")).value == 6
    assert (await calculate_expression("2 * (2 + 2)")).value == 8
    assert (await calculate_expression("2 + 2 * 2 ^ 2")).value == 10
    assert (await calculate_expression("2 ^ 2 * 2 + 2")).value == 10
    assert (await calculate_expression("2 ^ (2 * (2 + 2))")).value == 256
    assert (await calculate_expression("2 ^ (2 * (2 + 2")).value == 256
    assert (await calculate_expression("2 ^ [2 * (2 + 2] + 1")).value == 257
    assert (await calculate_expression("sqrt(4)")).value == 2
    assert (await calculate_expression("sqrt(4) + 2")).value == 4
    assert (await calculate_expression("sqrt(4) * 2")).value == 4
    assert (await calculate_expression("sqrt(4 + 5)")).value == 3
    assert (await calculate_expression("sin(0)")).value == 0
    assert (await calculate_expression("cos(0)")).value == 1
    assert (await calculate_expression("tg(0)")).value == 0
    assert (await calculate_expression("ln(1)")).value == 0
    assert abs((await calculate_expression("ln(2)")).value - Decimal(math.log(2))) < Decimal('1e-7')
    assert (await calculate_expression("sin(0) + cos(0) + tg(0) + ln(1)")).value == 1
    assert (await calculate_expression("2 + -2")).value == 0
    assert (await calculate_expression("-2 + 2")).value == 0
    assert (await calculate_expression("2 - -2")).value == 4
    assert (await calculate_expression("2 * -2")).value == -4
    assert (await calculate_expression("2 * -+  -2")).value == 4
    assert (await calculate_expression("2 * --+  -2")).value == -4
    assert (await calculate_expression("1 / 0")).result == "error"
    assert (await calculate_expression("-1 |>log")).result == "error"
    assert (await calculate_expression("--1 |>log")).value == 0
    assert (await calculate_expression("5!")).value == 120
    assert (await calculate_expression("5 !")).value == 120


def test_parsing():
    tokens = tokenize("ai(Сколько будет 2 + 2?)")[1]
    assert len(tokens) == 1
    _ = parse_expression(tokens)
