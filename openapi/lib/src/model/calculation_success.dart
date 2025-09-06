//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'calculation_success.g.dart';

/// CalculationSuccess
///
/// Properties:
/// * [result] - Статус ответа, всегда 'success'.
/// * [value] - Результат вычисления.
/// * [parenthesized] 
@BuiltValue()
abstract class CalculationSuccess implements Built<CalculationSuccess, CalculationSuccessBuilder> {
  /// Статус ответа, всегда 'success'.
  @BuiltValueField(wireName: r'result')
  CalculationSuccessResultEnum? get result;
  // enum resultEnum {  success,  };

  /// Результат вычисления.
  @BuiltValueField(wireName: r'value')
  String get value;

  @BuiltValueField(wireName: r'parenthesized')
  String? get parenthesized;

  CalculationSuccess._();

  factory CalculationSuccess([void updates(CalculationSuccessBuilder b)]) = _$CalculationSuccess;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CalculationSuccessBuilder b) => b
      ..result = CalculationSuccessResultEnum.success;

  @BuiltValueSerializer(custom: true)
  static Serializer<CalculationSuccess> get serializer => _$CalculationSuccessSerializer();
}

class _$CalculationSuccessSerializer implements PrimitiveSerializer<CalculationSuccess> {
  @override
  final Iterable<Type> types = const [CalculationSuccess, _$CalculationSuccess];

  @override
  final String wireName = r'CalculationSuccess';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CalculationSuccess object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.result != null) {
      yield r'result';
      yield serializers.serialize(
        object.result,
        specifiedType: const FullType(CalculationSuccessResultEnum),
      );
    }
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(String),
    );
    if (object.parenthesized != null) {
      yield r'parenthesized';
      yield serializers.serialize(
        object.parenthesized,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CalculationSuccess object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CalculationSuccessBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'result':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CalculationSuccessResultEnum),
          ) as CalculationSuccessResultEnum;
          result.result = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.value = valueDes;
          break;
        case r'parenthesized':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.parenthesized = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CalculationSuccess deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CalculationSuccessBuilder();
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

class CalculationSuccessResultEnum extends EnumClass {

  /// Статус ответа, всегда 'success'.
  @BuiltValueEnumConst(wireName: r'success')
  static const CalculationSuccessResultEnum success = _$calculationSuccessResultEnum_success;

  static Serializer<CalculationSuccessResultEnum> get serializer => _$calculationSuccessResultEnumSerializer;

  const CalculationSuccessResultEnum._(String name): super(name);

  static BuiltSet<CalculationSuccessResultEnum> get values => _$calculationSuccessResultEnumValues;
  static CalculationSuccessResultEnum valueOf(String name) => _$calculationSuccessResultEnumValueOf(name);
}

