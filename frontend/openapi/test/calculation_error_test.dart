import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

// tests for CalculationError
void main() {
  final instance = CalculationErrorBuilder();
  // TODO add properties to the builder and call build()

  group(CalculationError, () {
    // Статус ответа, всегда 'error'.
    // String result (default value: 'error')
    test('to test the property `result`', () async {
      // TODO
    });

    // Тип ошибки, всегда 'CalculationError'.
    // String kind (default value: 'CalculationError')
    test('to test the property `kind`', () async {
      // TODO
    });

    // Описание ошибки, человеко-читаемое.
    // String message
    test('to test the property `message`', () async {
      // TODO
    });

    // Span span
    test('to test the property `span`', () async {
      // TODO
    });

    // Span operatorSpan
    test('to test the property `operatorSpan`', () async {
      // TODO
    });

    // BuiltList<OperandMeta> operands
    test('to test the property `operands`', () async {
      // TODO
    });

    // String parenthesized
    test('to test the property `parenthesized`', () async {
      // TODO
    });

  });
}
