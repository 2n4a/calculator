import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/calculator/data/calculator_remote_data_source.dart';
import 'features/calculator/domain/usecases/calculate_expression.dart';
import 'features/calculator/domain/usecases/get_history.dart';
import 'features/calculator/presentation/calculator_controller.dart';
import 'features/calculator/presentation/calculator_page.dart';

void main() {
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      home: CalculatorPage(controller: controller),
    );
  }
}
