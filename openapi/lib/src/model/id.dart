//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'dart:core';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/any_of.dart';

part 'id.g.dart';

/// Уникальный идентификатор записи в истории.
@BuiltValue()
abstract class Id implements Built<Id, IdBuilder> {
  /// Any Of [String], [int]
  AnyOf get anyOf;

  Id._();

  factory Id([void updates(IdBuilder b)]) = _$Id;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IdBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Id> get serializer => _$IdSerializer();
}

class _$IdSerializer implements PrimitiveSerializer<Id> {
  @override
  final Iterable<Type> types = const [Id, _$Id];

  @override
  final String wireName = r'Id';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Id object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    Id object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final anyOf = object.anyOf;
    return serializers.serialize(anyOf, specifiedType: FullType(AnyOf, anyOf.valueTypes.map((type) => FullType(type)).toList()))!;
  }

  @override
  Id deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IdBuilder();
    Object? anyOfDataSrc;
    final targetType = const FullType(AnyOf, [FullType(String), FullType(int), ]);
    anyOfDataSrc = serialized;
    result.anyOf = serializers.deserialize(anyOfDataSrc, specifiedType: targetType) as AnyOf;
    return result.build();
  }
}

