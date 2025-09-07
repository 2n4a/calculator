import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for DefaultApi
void main() {
  final instance = Openapi().getDefaultApi();

  group(DefaultApi, () {
    // Вычисление значения и сохранение в историю
    //
    //Future<CalculationSuccess> calculateCalculatePost(CalculationRequest calculationRequest) async
    test('test calculateCalculatePost', () async {
      // TODO
    });

    // Получение истории вычислений
    //
    //Future<BuiltList<HistoryItem>> historyHistoryGet({ int limit, int offset, String order, DateTime fromTimestamp, DateTime toTimestamp }) async
    test('test historyHistoryGet', () async {
      // TODO
    });

    // Проверка состояния сервиса
    //
    //Future<JsonObject> livenessLivenessGet() async
    test('test livenessLivenessGet', () async {
      // TODO
    });

  });
}
