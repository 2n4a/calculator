// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (Serializers().toBuilder()
      ..add(CalculationError.serializer)
      ..add(CalculationErrorKindEnum.serializer)
      ..add(CalculationErrorResultEnum.serializer)
      ..add(CalculationRequest.serializer)
      ..add(CalculationSuccess.serializer)
      ..add(CalculationSuccessResultEnum.serializer)
      ..add(HTTPValidationError.serializer)
      ..add(HistoryItem.serializer)
      ..add(Id.serializer)
      ..add(OperandMeta.serializer)
      ..add(Span.serializer)
      ..add(ValidationError.serializer)
      ..add(ValidationErrorLocInner.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OperandMeta)]),
          () => ListBuilder<OperandMeta>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ValidationError)]),
          () => ListBuilder<ValidationError>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ValidationErrorLocInner)]),
          () => ListBuilder<ValidationErrorLocInner>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
