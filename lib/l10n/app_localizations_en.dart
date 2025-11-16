// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Extro';

  @override
  String get welcomeMessage => 'Welcome to Extro';

  @override
  String get transactions => 'Transactions';

  @override
  String get expenses => 'Expenses';

  @override
  String get income => 'Income';

  @override
  String get categories => 'Categories';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get totalExpenses => 'Total Expenses';

  @override
  String get totalIncome => 'Total Income';

  @override
  String get balance => 'Balance';

  @override
  String get networkError =>
      'Network error occurred. Please check your connection and try again.';

  @override
  String get unknownError => 'An unknown error occurred. Please try again.';

  @override
  String get dataProcessingError => 'Failed to process data. Please try again.';

  @override
  String get success => 'Success';
}
