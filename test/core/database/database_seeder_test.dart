import 'package:drift/drift.dart';
import 'package:extro/core/database/app_database.dart';
import 'package:extro/core/database/database_seeder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';

void main() {
  group('DatabaseSeeder', () {
    late AppDatabase database;
    late DatabaseSeeder seeder;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      seeder = DatabaseSeeder(database);
    });

    tearDown(() async {
      await database.close();
    });

    group('seedInitialData', () {
      test('seeds data when database is empty', () async {
        await seeder.seedInitialData();

        final wallets = await database.select(database.walletTable).get();
        final transactions = await database
            .select(database.transactionTable)
            .get();
        final spendingCharts = await database
            .select(database.spendingChartTable)
            .get();

        expect(wallets.length, equals(3));
        expect(transactions.length, equals(8));
        expect(spendingCharts.length, equals(1));
      });

      test('does not seed data when database already has wallets', () async {
        await database
            .into(database.walletTable)
            .insert(
              WalletTableCompanion.insert(
                label: 'Test Wallet',
                balance: 100.0,
                currency: 'USD',
                icon: '💰',
                accentColor: '#000000',
              ),
            );

        await seeder.seedInitialData();

        final wallets = await database.select(database.walletTable).get();
        final transactions = await database
            .select(database.transactionTable)
            .get();

        expect(wallets.length, equals(1));
        expect(transactions.length, equals(0));
      });

      test('seeds correct wallet data', () async {
        await seeder.seedInitialData();

        final wallets = await database.select(database.walletTable).get();

        expect(wallets[0].label, equals('Main Wallet'));
        expect(wallets[0].balance, equals(15000.0));
        expect(wallets[0].currency, equals('USD'));
        expect(wallets[0].icon, equals('💳'));

        expect(wallets[1].label, equals('Savings'));
        expect(wallets[1].balance, equals(8500.0));

        expect(wallets[2].label, equals('Investment'));
        expect(wallets[2].balance, equals(12300.0));
      });

      test('seeds correct transaction data with income and expenses', () async {
        await seeder.seedInitialData();

        final transactions = await database
            .select(database.transactionTable)
            .get();

        final incomeTransactions = transactions
            .where((t) => t.isIncome)
            .toList();
        final expenseTransactions = transactions
            .where((t) => !t.isIncome)
            .toList();

        expect(incomeTransactions.length, equals(3));
        expect(expenseTransactions.length, equals(5));

        expect(incomeTransactions[0].title, equals('Salary'));
        expect(incomeTransactions[0].amount, equals(3500.00));

        expect(expenseTransactions[0].title, equals('Grocery Shopping'));
        expect(expenseTransactions[0].amount, equals(-85.50));
      });

      test('seeds spending chart data', () async {
        await seeder.seedInitialData();

        final spendingCharts = await database
            .select(database.spendingChartTable)
            .get();

        expect(spendingCharts[0].totalAmount, equals('935.00'));
        expect(spendingCharts[0].percentageChange, equals('+12.5'));
        expect(spendingCharts[0].spendingData, isNotEmpty);
      });
    });
  });
}
