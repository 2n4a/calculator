import 'package:calculator/features/calculator/domain/entities/calculation.dart';
import 'package:calculator/features/calculator/domain/usecases/calculate_expression.dart';
import 'package:calculator/features/calculator/domain/usecases/get_history.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

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

  Map<String, dynamic>? _parseResponse(String raw) {
    try {
      final fixed = raw
          .replaceAll(
              RegExp(r'(CalculationSuccess|CalculationError)\s*\{'), '{')
          .replaceAllMapped(
            RegExp(r'(\w+)\s*[=:]\s*([^,}]+)'),
            (match) {
              final key = match[1];
              var value = match[2]?.trim();

              if (value != null && !value.startsWith('"')) {
                if (double.tryParse(value) == null && value != 'null') {
                  value = '"$value"';
                }
              }
              return '"$key":$value';
            },
          )
          .replaceAll(RegExp(r',\s*}'), '}')
          .replaceAll(RegExp(r'}\s*$'), '}')
          .replaceAll(RegExp(r'\s+'), ' ');

      print('🛠 Исправленная строка для JSON-декодинга: $fixed');
      return jsonDecode(fixed) as Map<String, dynamic>;
    } catch (e) {
      print('⚠️ Ошибка парсинга строки: $e');
      return null;
    }
  }

  Future<void> calculate() async {
    print('🧮 CalculatorController.calculate() начато');
    _loading = true;
    notifyListeners();

    try {
      final response = await calculateExpression(_expression);
      print('📥 Raw response data:\n$response');

      final parsed = _parseResponse(response);
      if (parsed == null) {
        _result = 'Ошибка обработки ответа';
        return;
      }

      final result = parsed['result'] as String?;
      if (result == 'success') {
        final value = parsed['value'];
        if (value != null) {
          if (value is num) {
            _result = value.toString();
          } else {
            _result = double.tryParse(value.toString())?.toString() ??
                'Ошибка обработки числа';
          }
        } else {
          _result = 'Нет значения в ответе';
        }
      } else if (result == 'error') {
        final message = parsed['message'] as String?;
        final kind = parsed['kind'] as String?;
        _result = 'Ошибка: ${message ?? kind ?? 'Неизвестная ошибка'}';
      } else {
        _result = 'Неизвестный формат ответа';
      }

      print('✅ Результат получен: $_result');
      await fetchHistory();
    } catch (e, st) {
      print('⚠️ Ошибка выполнения: $e\n$st');
      if (e.toString().contains('CalculationError')) {
        _result = e.toString().replaceFirst('Exception: ', '');
      } else {
        _result = 'Ошибка выполнения запроса: ${e.toString()}';
      }
    } finally {
      _loading = false;
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
