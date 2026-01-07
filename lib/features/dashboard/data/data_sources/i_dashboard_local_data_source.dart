import 'package:extro/core/database/app_database.dart';

abstract class IDashboardLocalDataSource {
  Future<List<WalletTableData>> getAllWallets();
  Future<List<TransactionTableData>> getRecentTransactions();
  Future<SpendingChartTableData?> getWeeklySpendingChart();

  Future<void> insertWallet(WalletTableCompanion wallet);
  Future<void> insertTransaction(TransactionTableCompanion transaction);
  Future<void> saveSpendingChart(SpendingChartTableCompanion chart);

  Future<void> insertWallets(List<WalletTableCompanion> wallets);
  Future<void> insertTransactions(List<TransactionTableCompanion> transactions);

  Future<double> getTotalIncome();
  Future<double> getTotalExpenses();
  Future<void> seedInitialData();
}
