import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider {
  ThemeProvider._();

  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    useMaterial3: true,
    brightness: Brightness.light,
    textTheme: GoogleFonts.robotoTextTheme(ThemeData.light().textTheme)
        .apply(bodyColor: Colors.grey[800], displayColor: Colors.grey[800]),
    hintColor: Colors.grey[600],
    scaffoldBackgroundColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.blue),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.blue),
      foregroundColor: Colors.grey[800],
      titleTextStyle: GoogleFonts.roboto(
        color: Colors.grey[800],
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
        .copyWith(background: Colors.white, brightness: Brightness.light),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
    hintColor: Colors.grey[400],
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue, brightness: Brightness.dark),
  );

  static const ThemeMode themeMode = ThemeMode.system;
}
