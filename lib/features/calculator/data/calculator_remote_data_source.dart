import 'package:calculator/core/api_client.dart';
import 'package:calculator/features/calculator/domain/entities/calculation.dart';
import 'package:calculator/features/calculator/domain/repositories/calculator_repository.dart';
import 'package:openapi/openapi.dart';

class CalculatorRemoteDataSource implements CalculatorRepository {
  final Openapi client;

  CalculatorRemoteDataSource({Openapi? client})
    : client = client ?? ApiClientProvider.getClient();

  @override
  Future<String> calculate(String expression) async {
    final defaultApi = client.getDefaultApi();
    final response = await defaultApi.calculateCalculatePost(
      calculationRequest: CalculationRequest((b) => b..expression = expression),
    );
    final result = response.data?.result;
    return result?.toString() ?? '';
  }

  @override
  Future<List<Calculation>> getHistory() async {
    final defaultApi = client.getDefaultApi();
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
  }

  @override
  Future<bool> checkIsAlive() async {
    final defaultApi = client.getDefaultApi();
    try {
      await defaultApi.livenessLivenessGet();
      return true;
    } catch (_) {
      return false;
    }
  }
}
