// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operand_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OperandMeta extends OperandMeta {
  @override
  final Span span;
  @override
  final String value;

  factory _$OperandMeta([void Function(OperandMetaBuilder)? updates]) =>
      (OperandMetaBuilder()..update(updates))._build();

  _$OperandMeta._({required this.span, required this.value}) : super._();
  @override
  OperandMeta rebuild(void Function(OperandMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperandMetaBuilder toBuilder() => OperandMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperandMeta && span == other.span && value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, span.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OperandMeta')
          ..add('span', span)
          ..add('value', value))
        .toString();
  }
}

class OperandMetaBuilder implements Builder<OperandMeta, OperandMetaBuilder> {
  _$OperandMeta? _$v;

  SpanBuilder? _span;
  SpanBuilder get span => _$this._span ??= SpanBuilder();
  set span(SpanBuilder? span) => _$this._span = span;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  OperandMetaBuilder() {
    OperandMeta._defaults(this);
  }

  OperandMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _span = $v.span.toBuilder();
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperandMeta other) {
    _$v = other as _$OperandMeta;
  }

  @override
  void update(void Function(OperandMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperandMeta build() => _build();

  _$OperandMeta _build() {
    _$OperandMeta _$result;
    try {
      _$result = _$v ??
          _$OperandMeta._(
            span: span.build(),
            value: BuiltValueNullFieldError.checkNotNull(
                value, r'OperandMeta', 'value'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'span';
        span.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OperandMeta', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
