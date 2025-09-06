// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HistoryItem extends HistoryItem {
  @override
  final Id id;
  @override
  final String expression;
  @override
  final String result;
  @override
  final DateTime timestamp;

  factory _$HistoryItem([void Function(HistoryItemBuilder)? updates]) =>
      (HistoryItemBuilder()..update(updates))._build();

  _$HistoryItem._(
      {required this.id,
      required this.expression,
      required this.result,
      required this.timestamp})
      : super._();
  @override
  HistoryItem rebuild(void Function(HistoryItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HistoryItemBuilder toBuilder() => HistoryItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HistoryItem &&
        id == other.id &&
        expression == other.expression &&
        result == other.result &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, expression.hashCode);
    _$hash = $jc(_$hash, result.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HistoryItem')
          ..add('id', id)
          ..add('expression', expression)
          ..add('result', result)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class HistoryItemBuilder implements Builder<HistoryItem, HistoryItemBuilder> {
  _$HistoryItem? _$v;

  IdBuilder? _id;
  IdBuilder get id => _$this._id ??= IdBuilder();
  set id(IdBuilder? id) => _$this._id = id;

  String? _expression;
  String? get expression => _$this._expression;
  set expression(String? expression) => _$this._expression = expression;

  String? _result;
  String? get result => _$this._result;
  set result(String? result) => _$this._result = result;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  HistoryItemBuilder() {
    HistoryItem._defaults(this);
  }

  HistoryItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id.toBuilder();
      _expression = $v.expression;
      _result = $v.result;
      _timestamp = $v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HistoryItem other) {
    _$v = other as _$HistoryItem;
  }

  @override
  void update(void Function(HistoryItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HistoryItem build() => _build();

  _$HistoryItem _build() {
    _$HistoryItem _$result;
    try {
      _$result = _$v ??
          _$HistoryItem._(
            id: id.build(),
            expression: BuiltValueNullFieldError.checkNotNull(
                expression, r'HistoryItem', 'expression'),
            result: BuiltValueNullFieldError.checkNotNull(
                result, r'HistoryItem', 'result'),
            timestamp: BuiltValueNullFieldError.checkNotNull(
                timestamp, r'HistoryItem', 'timestamp'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'id';
        id.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'HistoryItem', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
