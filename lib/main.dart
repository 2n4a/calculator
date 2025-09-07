import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/calculator/data/calculator_remote_data_source.dart';
import 'features/calculator/domain/usecases/calculate_expression.dart';
import 'features/calculator/domain/usecases/get_history.dart';
import 'features/calculator/presentation/calculator_controller.dart';
import 'features/calculator/presentation/calculator_page.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final repository = CalculatorRemoteDataSource();
  final controller = CalculatorController(
    calculateExpression: CalculateExpression(repository),
    getHistory: GetHistory(repository),
  );
  runApp(CalculatorApp(controller: controller));
}

class CalculatorApp extends StatelessWidget {
  final CalculatorController controller;

  const CalculatorApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор',
      theme: ThemeProvider.lightTheme,
      darkTheme: ThemeProvider.darkTheme,
      themeMode: ThemeProvider.themeMode,
      home: CalculatorPage(controller: controller),
    );
  }
}
