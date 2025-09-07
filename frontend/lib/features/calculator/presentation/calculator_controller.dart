import 'package:calculator/features/calculator/domain/entities/calculation.dart';
import 'package:calculator/features/calculator/domain/usecases/calculate_expression.dart';
import 'package:calculator/features/calculator/domain/usecases/get_history.dart';
import 'package:flutter/material.dart';

class CalculatorController extends ChangeNotifier {
  final CalculateExpression calculateExpression;
  final GetHistory getHistory;

  CalculatorController({
    required this.calculateExpression,
    required this.getHistory,
  });

  String _expression = '';
  String _result = '';
  List<Calculation> _history = [];
  bool _loading = false;

  String get expression => _expression;

  String get result => _result;

  List<Calculation> get history => _history;

  bool get loading => _loading;

  void setExpression(String value) {
    print('🔄 CalculatorController.setExpression: "$value"');
    _expression = value;
    print('📢 notifyListeners() вызван из setExpression');
    notifyListeners();
  }

  Future<void> calculate() async {
    print('🧮 CalculatorController.calculate() начато');
    _loading = true;
    print('📢 notifyListeners() вызван из calculate (loading = true)');
    notifyListeners();
    try {
      _result = await calculateExpression(_expression);
      print('✅ Результат получен: $_result');
      await fetchHistory();
    } finally {
      _loading = false;
      print('📢 notifyListeners() вызван из calculate (loading = false)');
      notifyListeners();
      print('🧮 CalculatorController.calculate() завершено');
    }
  }

  Future<void> fetchHistory() async {
    print('📜 CalculatorController.fetchHistory() начато');
    _history = await getHistory();
    print('📜 История получена: ${_history.length} элементов');
    print('📢 notifyListeners() вызван из fetchHistory');
    notifyListeners();
    print('📜 CalculatorController.fetchHistory() завершено');
  }
}
