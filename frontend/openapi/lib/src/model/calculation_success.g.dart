// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculation_success.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CalculationSuccessResultEnum _$calculationSuccessResultEnum_success =
    const CalculationSuccessResultEnum._('success');

CalculationSuccessResultEnum _$calculationSuccessResultEnumValueOf(
    String name) {
  switch (name) {
    case 'success':
      return _$calculationSuccessResultEnum_success;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CalculationSuccessResultEnum>
    _$calculationSuccessResultEnumValues =
    BuiltSet<CalculationSuccessResultEnum>(const <CalculationSuccessResultEnum>[
  _$calculationSuccessResultEnum_success,
]);

Serializer<CalculationSuccessResultEnum>
    _$calculationSuccessResultEnumSerializer =
    _$CalculationSuccessResultEnumSerializer();

class _$CalculationSuccessResultEnumSerializer
    implements PrimitiveSerializer<CalculationSuccessResultEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'success': 'success',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'success': 'success',
  };

  @override
  final Iterable<Type> types = const <Type>[CalculationSuccessResultEnum];
  @override
  final String wireName = 'CalculationSuccessResultEnum';

  @override
  Object serialize(Serializers serializers, CalculationSuccessResultEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CalculationSuccessResultEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CalculationSuccessResultEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CalculationSuccess extends CalculationSuccess {
  @override
  final CalculationSuccessResultEnum? result;
  @override
  final String value;
  @override
  final String? parenthesized;

  factory _$CalculationSuccess(
          [void Function(CalculationSuccessBuilder)? updates]) =>
      (CalculationSuccessBuilder()..update(updates))._build();

  _$CalculationSuccess._({this.result, required this.value, this.parenthesized})
      : super._();
  @override
  CalculationSuccess rebuild(
          void Function(CalculationSuccessBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CalculationSuccessBuilder toBuilder() =>
      CalculationSuccessBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CalculationSuccess &&
        result == other.result &&
        value == other.value &&
        parenthesized == other.parenthesized;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, result.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, parenthesized.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CalculationSuccess')
          ..add('result', result)
          ..add('value', value)
          ..add('parenthesized', parenthesized))
        .toString();
  }
}

class CalculationSuccessBuilder
    implements Builder<CalculationSuccess, CalculationSuccessBuilder> {
  _$CalculationSuccess? _$v;

  CalculationSuccessResultEnum? _result;
  CalculationSuccessResultEnum? get result => _$this._result;
  set result(CalculationSuccessResultEnum? result) => _$this._result = result;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  String? _parenthesized;
  String? get parenthesized => _$this._parenthesized;
  set parenthesized(String? parenthesized) =>
      _$this._parenthesized = parenthesized;

  CalculationSuccessBuilder() {
    CalculationSuccess._defaults(this);
  }

  CalculationSuccessBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _result = $v.result;
      _value = $v.value;
      _parenthesized = $v.parenthesized;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CalculationSuccess other) {
    _$v = other as _$CalculationSuccess;
  }

  @override
  void update(void Function(CalculationSuccessBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CalculationSuccess build() => _build();

  _$CalculationSuccess _build() {
    final _$result = _$v ??
        _$CalculationSuccess._(
          result: result,
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'CalculationSuccess', 'value'),
          parenthesized: parenthesized,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
