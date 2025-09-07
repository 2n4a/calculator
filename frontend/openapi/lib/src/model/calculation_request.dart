//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'calculation_request.g.dart';

/// CalculationRequest
///
/// Properties:
/// * [expression] - Математическое выражение для вычисления.
/// * [record] - Флаг, указывающий, нужно ли сохранять результат в историю.
@BuiltValue()
abstract class CalculationRequest implements Built<CalculationRequest, CalculationRequestBuilder> {
  /// Математическое выражение для вычисления.
  @BuiltValueField(wireName: r'expression')
  String get expression;

  /// Флаг, указывающий, нужно ли сохранять результат в историю.
  @BuiltValueField(wireName: r'record')
  bool? get record;

  CalculationRequest._();

  factory CalculationRequest([void updates(CalculationRequestBuilder b)]) = _$CalculationRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CalculationRequestBuilder b) => b
      ..record = true;

  @BuiltValueSerializer(custom: true)
  static Serializer<CalculationRequest> get serializer => _$CalculationRequestSerializer();
}

class _$CalculationRequestSerializer implements PrimitiveSerializer<CalculationRequest> {
  @override
  final Iterable<Type> types = const [CalculationRequest, _$CalculationRequest];

  @override
  final String wireName = r'CalculationRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CalculationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expression';
    yield serializers.serialize(
      object.expression,
      specifiedType: const FullType(String),
    );
    if (object.record != null) {
      yield r'record';
      yield serializers.serialize(
        object.record,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CalculationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CalculationRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'expression':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.expression = valueDes;
          break;
        case r'record':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.record = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CalculationRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CalculationRequestBuilder();
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

