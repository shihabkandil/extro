import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:extro/common/utils/transaction_type_icon.dart';
import 'package:extro/core/database/app_database.dart';

class DatabaseSeeder {
  final AppDatabase _database;

  DatabaseSeeder(this._database);

  Future<void> seedInitialData() async {
    final walletCount = await _countWallets();

    if (walletCount == 0) {
      await _seedWallets();
      await _seedTransactions();
      await _seedSpendingChart();
    }
  }

  Future<int> _countWallets() async {
    final query = _database.selectOnly(_database.walletTable)
      ..addColumns([_database.walletTable.id.count()]);
    final result = await query.getSingle();
    return result.read(_database.walletTable.id.count()) ?? 0;
  }

  Future<void> _seedWallets() async {
    await _database.batch((batch) {
      batch.insertAll(_database.walletTable, [
        WalletTableCompanion.insert(
          label: 'Main Wallet',
          balance: 15000.0,
          currency: 'USD',
          icon: TransactionTypeIcon.card.value,
          accentColor: '#4A90E2',
        ),
        WalletTableCompanion.insert(
          label: 'Savings',
          balance: 8500.0,
          currency: 'USD',
          icon: TransactionTypeIcon.coinsBag.value,
          accentColor: '#50C878',
        ),
        WalletTableCompanion.insert(
          label: 'Investment',
          balance: 12300.0,
          currency: 'USD',
          icon: TransactionTypeIcon.stockChart.value,
          accentColor: '#FF6B6B',
        ),
      ]);
    });
  }

  Future<void> _seedTransactions() async {
    await _database.batch((batch) {
      batch.insertAll(_database.transactionTable, [
        TransactionTableCompanion.insert(
          title: 'Salary',
          transactionDateTime: DateTime(2025, 12, 20, 9),
          amount: 3500.00,
          isIncome: true,
          icon: TransactionTypeIcon.dollarSign.value,
          walletId: 1,
        ),
        TransactionTableCompanion.insert(
          title: 'Freelance Project',
          transactionDateTime: DateTime(2025, 12, 22, 14, 30),
          amount: 1200.00,
          isIncome: true,
          icon: TransactionTypeIcon.officeBriefcase.value,
          walletId: 1,
        ),
        TransactionTableCompanion.insert(
          title: 'Grocery Shopping',
          transactionDateTime: DateTime(2025, 12, 24, 10, 30),
          amount: -85.50,
          isIncome: false,
          icon: TransactionTypeIcon.cart.value,
          walletId: 1,
        ),
        TransactionTableCompanion.insert(
          title: 'Restaurant',
          transactionDateTime: DateTime(2025, 12, 23, 19),
          amount: -45.00,
          isIncome: false,
          icon: TransactionTypeIcon.forkKnife.value,
          walletId: 1,
        ),
        TransactionTableCompanion.insert(
          title: 'Netflix Subscription',
          transactionDateTime: DateTime(2025, 12, 15, 12),
          amount: -15.99,
          isIncome: false,
          icon: TransactionTypeIcon.watchTv.value,
          walletId: 1,
        ),
        TransactionTableCompanion.insert(
          title: 'Electricity Bill',
          transactionDateTime: DateTime(2025, 12, 18, 8),
          amount: -120.00,
          isIncome: false,
          icon: TransactionTypeIcon.electricity.value,
          walletId: 1,
        ),
        TransactionTableCompanion.insert(
          title: 'Gas Station',
          transactionDateTime: DateTime(2025, 12, 21, 16, 30),
          amount: -60.00,
          isIncome: false,
          icon: TransactionTypeIcon.fuelPump.value,
          walletId: 1,
        ),
        TransactionTableCompanion.insert(
          title: 'Investment Return',
          transactionDateTime: DateTime(2025, 12, 25, 10),
          amount: 850.00,
          isIncome: true,
          icon: TransactionTypeIcon.chartIncreasing.value,
          walletId: 3,
        ),
      ]);
    });
  }

  Future<void> _seedSpendingChart() async {
    final spendingData = [120.0, 85.0, 150.0, 95.0, 200.0, 175.0, 110.0];

    await _database
        .into(_database.spendingChartTable)
        .insert(
          SpendingChartTableCompanion.insert(
            spendingData: jsonEncode(spendingData),
            totalAmount: '935.00',
            percentageChange: '+12.5',
          ),
        );
  }
}
