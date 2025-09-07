//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/id.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'history_item.g.dart';

/// HistoryItem
///
/// Properties:
/// * [id] 
/// * [expression] - Математическое выражение.
/// * [result] - Результат вычисления выражения.
/// * [timestamp] - Временная метка вычисления.
@BuiltValue()
abstract class HistoryItem implements Built<HistoryItem, HistoryItemBuilder> {
  @BuiltValueField(wireName: r'id')
  Id get id;

  /// Математическое выражение.
  @BuiltValueField(wireName: r'expression')
  String get expression;

  /// Результат вычисления выражения.
  @BuiltValueField(wireName: r'result')
  String get result;

  /// Временная метка вычисления.
  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  HistoryItem._();

  factory HistoryItem([void updates(HistoryItemBuilder b)]) = _$HistoryItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(HistoryItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<HistoryItem> get serializer => _$HistoryItemSerializer();
}

class _$HistoryItemSerializer implements PrimitiveSerializer<HistoryItem> {
  @override
  final Iterable<Type> types = const [HistoryItem, _$HistoryItem];

  @override
  final String wireName = r'HistoryItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    HistoryItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(Id),
    );
    yield r'expression';
    yield serializers.serialize(
      object.expression,
      specifiedType: const FullType(String),
    );
    yield r'result';
    yield serializers.serialize(
      object.result,
      specifiedType: const FullType(String),
    );
    yield r'timestamp';
    yield serializers.serialize(
      object.timestamp,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    HistoryItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required HistoryItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Id),
          ) as Id;
          result.id.replace(valueDes);
          break;
        case r'expression':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.expression = valueDes;
          break;
        case r'result':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.result = valueDes;
          break;
        case r'timestamp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.timestamp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  HistoryItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HistoryItemBuilder();
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

