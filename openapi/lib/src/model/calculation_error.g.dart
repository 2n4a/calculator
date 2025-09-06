// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculation_error.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CalculationErrorResultEnum _$calculationErrorResultEnum_error =
    const CalculationErrorResultEnum._('error');

CalculationErrorResultEnum _$calculationErrorResultEnumValueOf(String name) {
  switch (name) {
    case 'error':
      return _$calculationErrorResultEnum_error;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CalculationErrorResultEnum> _$calculationErrorResultEnumValues =
    BuiltSet<CalculationErrorResultEnum>(const <CalculationErrorResultEnum>[
  _$calculationErrorResultEnum_error,
]);

const CalculationErrorKindEnum _$calculationErrorKindEnum_calculationError =
    const CalculationErrorKindEnum._('calculationError');

CalculationErrorKindEnum _$calculationErrorKindEnumValueOf(String name) {
  switch (name) {
    case 'calculationError':
      return _$calculationErrorKindEnum_calculationError;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CalculationErrorKindEnum> _$calculationErrorKindEnumValues =
    BuiltSet<CalculationErrorKindEnum>(const <CalculationErrorKindEnum>[
  _$calculationErrorKindEnum_calculationError,
]);

Serializer<CalculationErrorResultEnum> _$calculationErrorResultEnumSerializer =
    _$CalculationErrorResultEnumSerializer();
Serializer<CalculationErrorKindEnum> _$calculationErrorKindEnumSerializer =
    _$CalculationErrorKindEnumSerializer();

class _$CalculationErrorResultEnumSerializer
    implements PrimitiveSerializer<CalculationErrorResultEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'error': 'error',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'error': 'error',
  };

  @override
  final Iterable<Type> types = const <Type>[CalculationErrorResultEnum];
  @override
  final String wireName = 'CalculationErrorResultEnum';

  @override
  Object serialize(Serializers serializers, CalculationErrorResultEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CalculationErrorResultEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CalculationErrorResultEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CalculationErrorKindEnumSerializer
    implements PrimitiveSerializer<CalculationErrorKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'calculationError': 'CalculationError',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CalculationError': 'calculationError',
  };

  @override
  final Iterable<Type> types = const <Type>[CalculationErrorKindEnum];
  @override
  final String wireName = 'CalculationErrorKindEnum';

  @override
  Object serialize(Serializers serializers, CalculationErrorKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CalculationErrorKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CalculationErrorKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CalculationError extends CalculationError {
  @override
  final CalculationErrorResultEnum? result;
  @override
  final CalculationErrorKindEnum? kind;
  @override
  final String message;
  @override
  final Span? span;
  @override
  final Span? operatorSpan;
  @override
  final BuiltList<OperandMeta>? operands;
  @override
  final String? parenthesized;

  factory _$CalculationError(
          [void Function(CalculationErrorBuilder)? updates]) =>
      (CalculationErrorBuilder()..update(updates))._build();

  _$CalculationError._(
      {this.result,
      this.kind,
      required this.message,
      this.span,
      this.operatorSpan,
      this.operands,
      this.parenthesized})
      : super._();
  @override
  CalculationError rebuild(void Function(CalculationErrorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CalculationErrorBuilder toBuilder() =>
      CalculationErrorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CalculationError &&
        result == other.result &&
        kind == other.kind &&
        message == other.message &&
        span == other.span &&
        operatorSpan == other.operatorSpan &&
        operands == other.operands &&
        parenthesized == other.parenthesized;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, result.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, span.hashCode);
    _$hash = $jc(_$hash, operatorSpan.hashCode);
    _$hash = $jc(_$hash, operands.hashCode);
    _$hash = $jc(_$hash, parenthesized.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CalculationError')
          ..add('result', result)
          ..add('kind', kind)
          ..add('message', message)
          ..add('span', span)
          ..add('operatorSpan', operatorSpan)
          ..add('operands', operands)
          ..add('parenthesized', parenthesized))
        .toString();
  }
}

class CalculationErrorBuilder
    implements Builder<CalculationError, CalculationErrorBuilder> {
  _$CalculationError? _$v;

  CalculationErrorResultEnum? _result;
  CalculationErrorResultEnum? get result => _$this._result;
  set result(CalculationErrorResultEnum? result) => _$this._result = result;

  CalculationErrorKindEnum? _kind;
  CalculationErrorKindEnum? get kind => _$this._kind;
  set kind(CalculationErrorKindEnum? kind) => _$this._kind = kind;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  SpanBuilder? _span;
  SpanBuilder get span => _$this._span ??= SpanBuilder();
  set span(SpanBuilder? span) => _$this._span = span;

  SpanBuilder? _operatorSpan;
  SpanBuilder get operatorSpan => _$this._operatorSpan ??= SpanBuilder();
  set operatorSpan(SpanBuilder? operatorSpan) =>
      _$this._operatorSpan = operatorSpan;

  ListBuilder<OperandMeta>? _operands;
  ListBuilder<OperandMeta> get operands =>
      _$this._operands ??= ListBuilder<OperandMeta>();
  set operands(ListBuilder<OperandMeta>? operands) =>
      _$this._operands = operands;

  String? _parenthesized;
  String? get parenthesized => _$this._parenthesized;
  set parenthesized(String? parenthesized) =>
      _$this._parenthesized = parenthesized;

  CalculationErrorBuilder() {
    CalculationError._defaults(this);
  }

  CalculationErrorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _result = $v.result;
      _kind = $v.kind;
      _message = $v.message;
      _span = $v.span?.toBuilder();
      _operatorSpan = $v.operatorSpan?.toBuilder();
      _operands = $v.operands?.toBuilder();
      _parenthesized = $v.parenthesized;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CalculationError other) {
    _$v = other as _$CalculationError;
  }

  @override
  void update(void Function(CalculationErrorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CalculationError build() => _build();

  _$CalculationError _build() {
    _$CalculationError _$result;
    try {
      _$result = _$v ??
          _$CalculationError._(
            result: result,
            kind: kind,
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'CalculationError', 'message'),
            span: _span?.build(),
            operatorSpan: _operatorSpan?.build(),
            operands: _operands?.build(),
            parenthesized: parenthesized,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'span';
        _span?.build();
        _$failedField = 'operatorSpan';
        _operatorSpan?.build();
        _$failedField = 'operands';
        _operands?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CalculationError', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
