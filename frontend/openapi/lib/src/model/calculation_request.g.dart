// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculation_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CalculationRequest extends CalculationRequest {
  @override
  final String expression;
  @override
  final bool? record;

  factory _$CalculationRequest(
          [void Function(CalculationRequestBuilder)? updates]) =>
      (CalculationRequestBuilder()..update(updates))._build();

  _$CalculationRequest._({required this.expression, this.record}) : super._();
  @override
  CalculationRequest rebuild(
          void Function(CalculationRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CalculationRequestBuilder toBuilder() =>
      CalculationRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CalculationRequest &&
        expression == other.expression &&
        record == other.record;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expression.hashCode);
    _$hash = $jc(_$hash, record.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CalculationRequest')
          ..add('expression', expression)
          ..add('record', record))
        .toString();
  }
}

class CalculationRequestBuilder
    implements Builder<CalculationRequest, CalculationRequestBuilder> {
  _$CalculationRequest? _$v;

  String? _expression;
  String? get expression => _$this._expression;
  set expression(String? expression) => _$this._expression = expression;

  bool? _record;
  bool? get record => _$this._record;
  set record(bool? record) => _$this._record = record;

  CalculationRequestBuilder() {
    CalculationRequest._defaults(this);
  }

  CalculationRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expression = $v.expression;
      _record = $v.record;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CalculationRequest other) {
    _$v = other as _$CalculationRequest;
  }

  @override
  void update(void Function(CalculationRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CalculationRequest build() => _build();

  _$CalculationRequest _build() {
    final _$result = _$v ??
        _$CalculationRequest._(
          expression: BuiltValueNullFieldError.checkNotNull(
              expression, r'CalculationRequest', 'expression'),
          record: record,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
