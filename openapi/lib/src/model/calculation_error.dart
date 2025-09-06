//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/span.dart';
import 'package:openapi/src/model/operand_meta.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'calculation_error.g.dart';

/// CalculationError
///
/// Properties:
/// * [result] - Статус ответа, всегда 'error'.
/// * [kind] - Тип ошибки, всегда 'CalculationError'.
/// * [message] - Описание ошибки, человеко-читаемое.
/// * [span] 
/// * [operatorSpan] 
/// * [operands] 
/// * [parenthesized] 
@BuiltValue()
abstract class CalculationError implements Built<CalculationError, CalculationErrorBuilder> {
  /// Статус ответа, всегда 'error'.
  @BuiltValueField(wireName: r'result')
  CalculationErrorResultEnum? get result;
  // enum resultEnum {  error,  };

  /// Тип ошибки, всегда 'CalculationError'.
  @BuiltValueField(wireName: r'kind')
  CalculationErrorKindEnum? get kind;
  // enum kindEnum {  CalculationError,  };

  /// Описание ошибки, человеко-читаемое.
  @BuiltValueField(wireName: r'message')
  String get message;

  @BuiltValueField(wireName: r'span')
  Span? get span;

  @BuiltValueField(wireName: r'operator_span')
  Span? get operatorSpan;

  @BuiltValueField(wireName: r'operands')
  BuiltList<OperandMeta>? get operands;

  @BuiltValueField(wireName: r'parenthesized')
  String? get parenthesized;

  CalculationError._();

  factory CalculationError([void updates(CalculationErrorBuilder b)]) = _$CalculationError;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CalculationErrorBuilder b) => b
      ..result = CalculationErrorResultEnum.error
      ..kind = CalculationErrorKindEnum.calculationError;

  @BuiltValueSerializer(custom: true)
  static Serializer<CalculationError> get serializer => _$CalculationErrorSerializer();
}

class _$CalculationErrorSerializer implements PrimitiveSerializer<CalculationError> {
  @override
  final Iterable<Type> types = const [CalculationError, _$CalculationError];

  @override
  final String wireName = r'CalculationError';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CalculationError object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.result != null) {
      yield r'result';
      yield serializers.serialize(
        object.result,
        specifiedType: const FullType(CalculationErrorResultEnum),
      );
    }
    if (object.kind != null) {
      yield r'kind';
      yield serializers.serialize(
        object.kind,
        specifiedType: const FullType(CalculationErrorKindEnum),
      );
    }
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
    if (object.span != null) {
      yield r'span';
      yield serializers.serialize(
        object.span,
        specifiedType: const FullType.nullable(Span),
      );
    }
    if (object.operatorSpan != null) {
      yield r'operator_span';
      yield serializers.serialize(
        object.operatorSpan,
        specifiedType: const FullType.nullable(Span),
      );
    }
    if (object.operands != null) {
      yield r'operands';
      yield serializers.serialize(
        object.operands,
        specifiedType: const FullType.nullable(BuiltList, [FullType(OperandMeta)]),
      );
    }
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
    CalculationError object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CalculationErrorBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'result':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CalculationErrorResultEnum),
          ) as CalculationErrorResultEnum;
          result.result = valueDes;
          break;
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CalculationErrorKindEnum),
          ) as CalculationErrorKindEnum;
          result.kind = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        case r'span':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Span),
          ) as Span?;
          if (valueDes == null) continue;
          result.span.replace(valueDes);
          break;
        case r'operator_span':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Span),
          ) as Span?;
          if (valueDes == null) continue;
          result.operatorSpan.replace(valueDes);
          break;
        case r'operands':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(OperandMeta)]),
          ) as BuiltList<OperandMeta>?;
          if (valueDes == null) continue;
          result.operands.replace(valueDes);
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
  CalculationError deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CalculationErrorBuilder();
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

class CalculationErrorResultEnum extends EnumClass {

  /// Статус ответа, всегда 'error'.
  @BuiltValueEnumConst(wireName: r'error')
  static const CalculationErrorResultEnum error = _$calculationErrorResultEnum_error;

  static Serializer<CalculationErrorResultEnum> get serializer => _$calculationErrorResultEnumSerializer;

  const CalculationErrorResultEnum._(String name): super(name);

  static BuiltSet<CalculationErrorResultEnum> get values => _$calculationErrorResultEnumValues;
  static CalculationErrorResultEnum valueOf(String name) => _$calculationErrorResultEnumValueOf(name);
}

class CalculationErrorKindEnum extends EnumClass {

  /// Тип ошибки, всегда 'CalculationError'.
  @BuiltValueEnumConst(wireName: r'CalculationError')
  static const CalculationErrorKindEnum calculationError = _$calculationErrorKindEnum_calculationError;

  static Serializer<CalculationErrorKindEnum> get serializer => _$calculationErrorKindEnumSerializer;

  const CalculationErrorKindEnum._(String name): super(name);

  static BuiltSet<CalculationErrorKindEnum> get values => _$calculationErrorKindEnumValues;
  static CalculationErrorKindEnum valueOf(String name) => _$calculationErrorKindEnumValueOf(name);
}

