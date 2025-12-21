import 'dart:ui';

class AppColors {
  /// Private constructor to prevent instantiation.
  const AppColors._();

  // Primary brand colors
  static const Color primary = Color(0xFF1AA299); // Deep Teal
  static const Color secondary = Color(0xFFD9534F); // Modern Coral/Red

  // Background colors
  static const Color backgroundLight = Color(0xFFF6F8F8);
  static const Color backgroundDark = Color(0xFF12201F);

  // Surface colors (for cards, containers)
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1D2A29);

  // Navigation bar dark background
  static const Color navBarDark = Color(0xFF151F1E);

  // Dashboard gradient colors
  static const Color incomeDark = Color(0xFF1D7070); // Dark Teal/Green
  static const Color incomeLight = Color(0xFF3CB371); // Light Turquoise

  static const Color expensesDark = Color(0xFFD35400); // Dark Red/Orange
  static const Color expensesLight = Color(0xFFE74C3C); // Vibrant Red

  static const Color fabOrange = Color(0xFFD35400); // Orange
  static const Color fabRed = Color(0xFFE74C3C); // Red

  // Wallet/Currency accent colors
  static const Color usdBlue = Color(0xFF3B82F6);
  static const Color gbpPurple = Color(0xFFA855F7);
  static const Color egpEmerald = Color(0xFF10B981);

  // UI colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color incomeGreen = Color(0xFF3CB371);
  static const Color expenseRed = Color(0xFFE74C3C);
  static const Color textDark = Color(0xFF212121);
  static const Color textGrey = Color(0xFF757575);

  // Slate colors (for secondary text and icons)
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
}
