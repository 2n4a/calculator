import '../repositories/calculator_repository.dart';

class CalculateExpression {
  final CalculatorRepository repository;
  CalculateExpression(this.repository);

  Future<String> call(String expression) {
    return repository.calculate(expression);
  }
}
