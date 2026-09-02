import 'package:flutter/material.dart';

class AppTheme {
  static const primary = Color(0xFF0E7A5A);
  static const accent = Color(0xFFF5A623);

  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primary),
    appBarTheme: const AppBarTheme(backgroundColor: primary, foregroundColor: Colors.white),
  );
}
