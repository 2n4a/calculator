// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'id.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Id extends Id {
  @override
  final AnyOf anyOf;

  factory _$Id([void Function(IdBuilder)? updates]) =>
      (IdBuilder()..update(updates))._build();

  _$Id._({required this.anyOf}) : super._();
  @override
  Id rebuild(void Function(IdBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IdBuilder toBuilder() => IdBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Id && anyOf == other.anyOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, anyOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Id')..add('anyOf', anyOf)).toString();
  }
}

class IdBuilder implements Builder<Id, IdBuilder> {
  _$Id? _$v;

  AnyOf? _anyOf;
  AnyOf? get anyOf => _$this._anyOf;
  set anyOf(AnyOf? anyOf) => _$this._anyOf = anyOf;

  IdBuilder() {
    Id._defaults(this);
  }

  IdBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _anyOf = $v.anyOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Id other) {
    _$v = other as _$Id;
  }

  @override
  void update(void Function(IdBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Id build() => _build();

  _$Id _build() {
    final _$result = _$v ??
        _$Id._(
          anyOf: BuiltValueNullFieldError.checkNotNull(anyOf, r'Id', 'anyOf'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
