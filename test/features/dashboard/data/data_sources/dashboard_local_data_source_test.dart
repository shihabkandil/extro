import 'package:drift/native.dart';
import 'package:extro/core/database/app_database.dart';
import 'package:extro/features/dashboard/data/data_sources/dashboard_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart' hide isNull, isNotNull;

void main() {
  group('DashboardLocalDataSource', () {
    late AppDatabase database;
    late DashboardLocalDataSource dataSource;

    setUp(() async {
      database = AppDatabase(NativeDatabase.memory());
      dataSource = DashboardLocalDataSource(database: database);
    });

    tearDown(() async {
      await database.close();
    });

    group('getAllWallets', () {
      test('returns all wallets from database', () async {
        final wallets = await dataSource.getAllWallets();

        expect(wallets.length, greaterThanOrEqualTo(3));
        expect(wallets.any((w) => w.label == 'Main Wallet'), isTrue);
        expect(wallets.any((w) => w.label == 'Savings'), isTrue);
        expect(wallets.any((w) => w.label == 'Investment'), isTrue);
      });
    });

    group('getRecentTransactions', () {
      test('returns transactions ordered by date descending', () async {
        final transactions = await dataSource.getRecentTransactions();

        expect(transactions, isNotEmpty);
        for (int i = 0; i < transactions.length - 1; i++) {
          expect(
            transactions[i].transactionDateTime.isAfter(
                  transactions[i + 1].transactionDateTime,
                ) ||
                transactions[i].transactionDateTime ==
                    transactions[i + 1].transactionDateTime,
            isTrue,
          );
        }
      });

      test('limits results to 10 transactions', () async {
        final transactions = await dataSource.getRecentTransactions();

        expect(transactions.length, lessThanOrEqualTo(10));
      });
    });

    group('getWeeklySpendingChart', () {
      test('returns spending chart when exists', () async {
        final chart = await dataSource.getWeeklySpendingChart();

        expect(chart, isA<SpendingChartTableData>());
        expect(chart!.totalAmount, isNotEmpty);
        expect(chart.percentageChange, isNotEmpty);
        expect(chart.spendingData, isNotEmpty);
      });
    });

    group('getTotalIncome', () {
      test('calculates total income from income transactions', () async {
        final totalIncome = await dataSource.getTotalIncome();

        expect(totalIncome, greaterThanOrEqualTo(0.0));
      });
    });

    group('getTotalExpenses', () {
      test('calculates total expenses from expense transactions', () async {
        final totalExpenses = await dataSource.getTotalExpenses();

        expect(totalExpenses, greaterThanOrEqualTo(0.0));
      });
    });

    group('insertWallet', () {
      test('inserts wallet into database', () async {
        await dataSource.insertWallet(
          WalletTableCompanion.insert(
            label: 'New Wallet',
            balance: 500.0,
            currency: 'USD',
            icon: '💳',
            accentColor: '#FF0000',
          ),
        );

        final wallets = await database.select(database.walletTable).get();

        expect(wallets.any((w) => w.label == 'New Wallet'), isTrue);
      });
    });

    group('insertTransaction', () {
      test('inserts transaction into database', () async {
        await dataSource.insertTransaction(
          TransactionTableCompanion.insert(
            title: 'Test Transaction',
            transactionDateTime: DateTime(2025, 12, 25),
            amount: 100.0,
            isIncome: true,
            icon: '💵',
            walletId: 1,
          ),
        );

        final transactions = await database
            .select(database.transactionTable)
            .get();

        expect(transactions.any((t) => t.title == 'Test Transaction'), isTrue);
      });
    });

    group('saveSpendingChart', () {
      test('saves spending chart to database', () async {
        await dataSource.saveSpendingChart(
          SpendingChartTableCompanion.insert(
            spendingData: '[200.0, 300.0]',
            totalAmount: '500.00',
            percentageChange: '+15.0',
          ),
        );

        final charts = await database.select(database.spendingChartTable).get();

        expect(charts.any((c) => c.totalAmount == '500.00'), isTrue);
      });
    });
  });
}
