import '../entities/calculation.dart';

abstract class CalculatorRepository {
  Future<String> calculate(String expression);

  Future<List<Calculation>> getHistory();

  Future<bool> checkIsAlive();
}
