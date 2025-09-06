//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'span.g.dart';

/// Диапазон символов в строке (0-индексация).
///
/// Properties:
/// * [start] - Начальная позиция (включительно, 0-индексация).
/// * [end] - Конечная позиция (исключительно, 0-индексация).
@BuiltValue()
abstract class Span implements Built<Span, SpanBuilder> {
  /// Начальная позиция (включительно, 0-индексация).
  @BuiltValueField(wireName: r'start')
  int get start;

  /// Конечная позиция (исключительно, 0-индексация).
  @BuiltValueField(wireName: r'end')
  int get end;

  Span._();

  factory Span([void updates(SpanBuilder b)]) = _$Span;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SpanBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Span> get serializer => _$SpanSerializer();
}

class _$SpanSerializer implements PrimitiveSerializer<Span> {
  @override
  final Iterable<Type> types = const [Span, _$Span];

  @override
  final String wireName = r'Span';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Span object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'start';
    yield serializers.serialize(
      object.start,
      specifiedType: const FullType(int),
    );
    yield r'end';
    yield serializers.serialize(
      object.end,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Span object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SpanBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'start':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.start = valueDes;
          break;
        case r'end':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.end = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Span deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SpanBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

