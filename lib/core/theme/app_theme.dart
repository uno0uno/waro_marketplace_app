import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // Aliases legacy (compat)
  static const primary = AppColors.primary;
  static const accent = AppColors.crocus600;

  static final ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.titan400,
    onSecondary: AppColors.ebony900,
    error: AppColors.destructive,
    onError: Colors.white,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: AppColors.surfaceSecondary,
    outline: AppColors.border,
  );

  static final ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryDark,
    onPrimary: AppColors.ebony900,
    secondary: AppColors.ebony600,
    onSecondary: AppColors.titan200,
    error: const Color(0xFFF87171),
    onError: AppColors.titan100,
    surface: AppColors.ebony800,
    onSurface: AppColors.titan100,
    surfaceContainerHighest: AppColors.ebony700,
    outline: AppColors.ebony600,
  );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: _lightScheme,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Lato',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceSecondary,
          selectedColor: AppColors.crocus50,
          labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        dividerColor: AppColors.border,
        extensions: const [WaroColors.light],
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: _darkScheme,
        scaffoldBackgroundColor: AppColors.ebony900,
        fontFamily: 'Lato',
        extensions: const [WaroColors.dark],
      );
}

/// Extension con tokens extra (accesibles via ThemeExtension)
@immutable
class WaroColors extends ThemeExtension<WaroColors> {
  final Color success;
  final Color warning;
  final Color info;
  final Color stateDangerBg;
  final Color stateSuccessBg;

  const WaroColors({
    required this.success,
    required this.warning,
    required this.info,
    required this.stateDangerBg,
    required this.stateSuccessBg,
  });

  static const light = WaroColors(
    success: AppColors.success,
    warning: AppColors.warning,
    info: AppColors.info,
    stateDangerBg: AppColors.stateDangerBg,
    stateSuccessBg: AppColors.stateSuccessBg,
  );
  static const dark = WaroColors(
    success: AppColors.success,
    warning: AppColors.warning,
    info: Color(0xFF60A5FA),
    stateDangerBg: Color(0xFF450A0A),
    stateSuccessBg: Color(0xFF052E16),
  );

  @override
  WaroColors copyWith({Color? success, Color? warning, Color? info}) => WaroColors(
        success: success ?? this.success,
        warning: warning ?? this.warning,
        info: info ?? this.info,
        stateDangerBg: stateDangerBg,
        stateSuccessBg: stateSuccessBg,
      );

  @override
  WaroColors lerp(WaroColors? other, double t) => other ?? this;
}
