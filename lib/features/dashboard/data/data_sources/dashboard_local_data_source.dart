import 'package:drift/drift.dart';
import 'package:extro/core/database/app_database.dart';
import 'package:extro/core/database/database_seeder.dart';
import 'package:injectable/injectable.dart';

import 'i_dashboard_local_data_source.dart';

@Singleton(as: IDashboardLocalDataSource)
class DashboardLocalDataSource implements IDashboardLocalDataSource {
  final AppDatabase _database;
  late final DatabaseSeeder _seeder;

  DashboardLocalDataSource({required AppDatabase database})
      : _database = database {
    _seeder = DatabaseSeeder(_database);
  }

  @override
  Future<void> seedInitialData() async {
    await _seeder.seedInitialData();
  }

  @override
  Future<List<WalletTableData>> getAllWallets() async {
    await seedInitialData();
    return _database.select(_database.walletTable).get();
  }

  @override
  Future<List<TransactionTableData>> getRecentTransactions() async {
    await seedInitialData();
    return (_database.select(_database.transactionTable)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.transactionDateTime,
                  mode: OrderingMode.desc,
                ),
          ])
          ..limit(10))
        .get();
  }

  @override
  Future<SpendingChartTableData?> getWeeklySpendingChart() async {
    await seedInitialData();
    return (_database.select(_database.spendingChartTable)..limit(1))
        .getSingleOrNull();
  }

  @override
  Future<double> getTotalIncome() async {
    await seedInitialData();
    final query = _database.selectOnly(_database.transactionTable)
      ..addColumns([_database.transactionTable.amount.sum()])
      ..where(_database.transactionTable.isIncome.equals(true));
    
    final result = await query.getSingle();
    return result.read(_database.transactionTable.amount.sum()) ?? 0.0;
  }

  @override
  Future<double> getTotalExpenses() async {
    await seedInitialData();
    final query = _database.selectOnly(_database.transactionTable)
      ..addColumns([_database.transactionTable.amount.sum()])
      ..where(_database.transactionTable.isIncome.equals(false));
    
    final result = await query.getSingle();
    final sum = result.read(_database.transactionTable.amount.sum()) ?? 0.0;
    return sum.abs();
  }

  @override
  Future<void> insertWallet(WalletTableCompanion wallet) async {
    await _database.into(_database.walletTable).insert(wallet);
  }

  @override
  Future<void> insertTransaction(TransactionTableCompanion transaction) async {
    await _database.into(_database.transactionTable).insert(transaction);
  }

  @override
  Future<void> saveSpendingChart(SpendingChartTableCompanion chart) async {
    await _database.delete(_database.spendingChartTable).go();
    await _database.into(_database.spendingChartTable).insert(chart);
  }

  @override
  Future<void> insertWallets(List<WalletTableCompanion> wallets) async {
    await _database.batch((batch) {
      batch.insertAll(_database.walletTable, wallets);
    });
  }

  @override
  Future<void> insertTransactions(
    List<TransactionTableCompanion> transactions,
  ) async {
    await _database.batch((batch) {
      batch.insertAll(_database.transactionTable, transactions);
    });
  }
}
