import '../entities/calculation.dart';
import '../repositories/calculator_repository.dart';

class GetHistory {
  final CalculatorRepository repository;
  GetHistory(this.repository);

  Future<List<Calculation>> call() {
    return repository.getHistory();
  }
}
