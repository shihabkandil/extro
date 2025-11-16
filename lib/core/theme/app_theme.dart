import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  /// Private constructor to prevent instantiation.
  const AppTheme._();

  static ThemeData light = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: Colors.red,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
