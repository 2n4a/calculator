import 'package:calculator/core/api_client.dart';
import 'package:calculator/features/calculator/domain/entities/calculation.dart';
import 'package:calculator/features/calculator/domain/repositories/calculator_repository.dart';
import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart';

class CalculatorRemoteDataSource implements CalculatorRepository {
  final Openapi client;

  CalculatorRemoteDataSource({Openapi? client})
      : client = client ?? ApiClientProvider.getClient();

  @override
  Future<String> calculate(String expression) async {
    final defaultApi = client.getDefaultApi();
    try {
      final response = await defaultApi.calculateCalculatePost(
        calculationRequest:
            CalculationRequest((b) => b..expression = expression),
      );
      if (response.statusCode == 200) {
        return response.data.toString();
      } else {
        return 'Ошибка: Неожиданный статус ответа ${response.statusCode}';
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 && e.response?.data != null) {
        return 'CalculationError ${e.response?.data}';
      }
      return 'Ошибка сервера: ${e.message}';
    } catch (e) {
      return 'Непредвиденная ошибка: $e';
    }
  }

  @override
  Future<List<Calculation>> getHistory() async {
    final defaultApi = client.getDefaultApi();
    try {
      final response = await defaultApi.historyHistoryGet();
      final items = response.data?.toList() ?? <HistoryItem>[];
      return items
          .map(
            (item) => Calculation(
              expression: item.expression,
              result: item.result,
              timestamp: item.timestamp,
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw Exception('Ошибка при получении истории: ${e.message}');
    }
  }

  @override
  Future<bool> checkIsAlive() async {
    final defaultApi = client.getDefaultApi();
    try {
      await defaultApi.livenessLivenessGet();
      return true;
    } on DioException catch (e) {
      print('Ошибка проверки состояния сервера: ${e.message}');
      return false;
    }
  }
}
