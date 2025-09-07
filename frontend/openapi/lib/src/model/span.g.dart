// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'span.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Span extends Span {
  @override
  final int start;
  @override
  final int end;

  factory _$Span([void Function(SpanBuilder)? updates]) =>
      (SpanBuilder()..update(updates))._build();

  _$Span._({required this.start, required this.end}) : super._();
  @override
  Span rebuild(void Function(SpanBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SpanBuilder toBuilder() => SpanBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Span && start == other.start && end == other.end;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, start.hashCode);
    _$hash = $jc(_$hash, end.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Span')
          ..add('start', start)
          ..add('end', end))
        .toString();
  }
}

class SpanBuilder implements Builder<Span, SpanBuilder> {
  _$Span? _$v;

  int? _start;
  int? get start => _$this._start;
  set start(int? start) => _$this._start = start;

  int? _end;
  int? get end => _$this._end;
  set end(int? end) => _$this._end = end;

  SpanBuilder() {
    Span._defaults(this);
  }

  SpanBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _start = $v.start;
      _end = $v.end;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Span other) {
    _$v = other as _$Span;
  }

  @override
  void update(void Function(SpanBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Span build() => _build();

  _$Span _build() {
    final _$result = _$v ??
        _$Span._(
          start: BuiltValueNullFieldError.checkNotNull(start, r'Span', 'start'),
          end: BuiltValueNullFieldError.checkNotNull(end, r'Span', 'end'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
