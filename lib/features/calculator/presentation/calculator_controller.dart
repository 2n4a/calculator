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
    _expression = value;
    notifyListeners();
  }

  Future<void> calculate() async {
    _loading = true;
    notifyListeners();
    try {
      _result = await calculateExpression(_expression);
      await fetchHistory();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHistory() async {
    _history = await getHistory();
    notifyListeners();
  }
}
