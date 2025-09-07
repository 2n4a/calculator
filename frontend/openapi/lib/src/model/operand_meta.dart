//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/span.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operand_meta.g.dart';

/// Метаданные операнда в выражении.
///
/// Properties:
/// * [span] - Диапазон символов операнда.
/// * [value] - Значение операнда.
@BuiltValue()
abstract class OperandMeta implements Built<OperandMeta, OperandMetaBuilder> {
  /// Диапазон символов операнда.
  @BuiltValueField(wireName: r'span')
  Span get span;

  /// Значение операнда.
  @BuiltValueField(wireName: r'value')
  String get value;

  OperandMeta._();

  factory OperandMeta([void updates(OperandMetaBuilder b)]) = _$OperandMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperandMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperandMeta> get serializer => _$OperandMetaSerializer();
}

class _$OperandMetaSerializer implements PrimitiveSerializer<OperandMeta> {
  @override
  final Iterable<Type> types = const [OperandMeta, _$OperandMeta];

  @override
  final String wireName = r'OperandMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperandMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'span';
    yield serializers.serialize(
      object.span,
      specifiedType: const FullType(Span),
    );
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OperandMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperandMetaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'span':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Span),
          ) as Span;
          result.span.replace(valueDes);
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.value = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperandMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperandMetaBuilder();
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

