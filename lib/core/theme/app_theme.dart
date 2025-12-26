import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_theme.dart';

class AppTheme {
  /// Private constructor to prevent instantiation.
  const AppTheme._();

  static ThemeData light = _buildLightTheme();
  static ThemeData dark = _buildDarkTheme();

  static ThemeData _buildLightTheme() {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: Colors.red,
      surface: AppColors.backgroundLight,
      inverseSurface: Colors.black,
      onSurface: AppColors.surfaceLight,
      onInverseSurface: AppColors.surfaceDark,
    );

    return ThemeData(
      colorScheme: colorScheme,
      textTheme: AppTextTheme.light(colorScheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  static ThemeData _buildDarkTheme() {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: Colors.red,
      surface: AppColors.backgroundDark,
      inverseSurface: Colors.white,
      onSurface: AppColors.surfaceDark,
      onInverseSurface: AppColors.surfaceLight,
    );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: AppTextTheme.dark(colorScheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
