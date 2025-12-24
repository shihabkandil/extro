import '../models/wallet_response.dart';
import '../models/transaction_response.dart';
import '../models/spending_chart_response.dart';

abstract class IDashboardLocalDataSource {
  Future<List<WalletResponse>> getAllWallets();
  Future<List<TransactionResponse>> getRecentTransactions();
  Future<SpendingChartResponse> getWeeklySpendingChart();
}
