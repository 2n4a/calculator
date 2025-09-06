//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:openapi/src/date_serializer.dart';
import 'package:openapi/src/model/date.dart';

import 'package:openapi/src/model/calculation_error.dart';
import 'package:openapi/src/model/calculation_request.dart';
import 'package:openapi/src/model/calculation_success.dart';
import 'package:openapi/src/model/http_validation_error.dart';
import 'package:openapi/src/model/history_item.dart';
import 'package:openapi/src/model/id.dart';
import 'package:openapi/src/model/operand_meta.dart';
import 'package:openapi/src/model/span.dart';
import 'package:openapi/src/model/validation_error.dart';
import 'package:openapi/src/model/validation_error_loc_inner.dart';

part 'serializers.g.dart';

@SerializersFor([
  CalculationError,
  CalculationRequest,
  CalculationSuccess,
  HTTPValidationError,
  HistoryItem,
  Id,
  OperandMeta,
  Span,
  ValidationError,
  ValidationErrorLocInner,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(HistoryItem)]),
        () => ListBuilder<HistoryItem>(),
      )
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer())
    ).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
