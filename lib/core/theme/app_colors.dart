import 'package:flutter/material.dart';

/// WARO Design System — Primitivas extraídas de front_nuxt/assets/css/design-tokens.css
abstract class AppColors {
  // === TITAN (grises claros) ===
  static const titan50 = Color(0xFFFFFFFF);
  static const titan100 = Color(0xFFF8F9FA);
  static const titan150 = Color(0xFFF4F6F8);
  static const titan200 = Color(0xFFEBF0FF);
  static const titan300 = Color(0xFFE0E5EB);
  static const titan400 = Color(0xFFD5DBE1);
  static const titan500 = Color(0xFFC9D0D8);
  static const titan600 = Color(0xFFB4BCC5);
  static const titan700 = Color(0xFF9FA8B2);
  static const titan800 = Color(0xFF8A949F);
  static const titan900 = Color(0xFF75808C);

  // === CROCUS (púrpura marca) ===
  static const crocus50 = Color(0xFFF5F3FF);
  static const crocus100 = Color(0xFFEDE9FE);
  static const crocus200 = Color(0xFFDDD6FE);
  static const crocus300 = Color(0xFFC4B5FD);
  static const crocus400 = Color(0xFFA78BFA);
  static const crocus500 = Color(0xFF9687F5);
  static const crocus600 = Color(0xFF7C3AED); // PRIMARY light
  static const crocus700 = Color(0xFF6D28D9);
  static const crocus800 = Color(0xFF5B21B6);
  static const crocus900 = Color(0xFF4C1D95);

  // === EBONY (grises oscuros / texto) ===
  static const ebony50 = Color(0xFFF0F1F3);
  static const ebony100 = Color(0xFFDBDDE2);
  static const ebony200 = Color(0xFFB7BBC4);
  static const ebony300 = Color(0xFF9399A6);
  static const ebony400 = Color(0xFF6F7788);
  static const ebony500 = Color(0xFF4B5565);
  static const ebony600 = Color(0xFF3D4555);
  static const ebony700 = Color(0xFF323845);
  static const ebony800 = Color(0xFF2D284B);
  static const ebony900 = Color(0xFF1F1D35);

  // === NEUTRAL ===
  static const neutral50 = Color(0xFFFAFAFA);
  static const neutral300 = Color(0xFFBDBDBD);
  static const neutral850 = Color(0xFF292929);
  static const neutral950 = Color(0xFF000000);

  // === SEMÁNTICOS ===
  static const success = Color(0xFF209653); // hsl 142 71% 45%
  static const warning = Color(0xFFF59E0B); // hsl 38 92% 50%
  static const info = Color(0xFF2563EB); // hsl 218 68% 47% approx
  static const destructive = Color(0xFFEF4444); // hsl 0 84% 60%

  // === ALIASES semánticos (tema claro) ===
  static const primary = crocus600;
  static const primaryDark = crocus400; // para dark mode
  static const background = titan50;
  static const foreground = ebony900;
  static const surface = titan50;
  static const surfaceSecondary = titan200;
  static const surfaceTertiary = titan300;
  static const border = titan400;
  static const textPrimary = ebony900;
  static const textSecondary = ebony600;
  static const textTertiary = ebony500;

  // === STATE BGs ===
  static const stateDangerBg = Color(0xFFFEF2F2);
  static const stateWarningBg = Color(0xFFFFFBEB);
  static const stateSuccessBg = Color(0xFFF0FDF4);
  static const stateInfoBg = Color(0xFFEFF6FF);
}
