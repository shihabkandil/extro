import 'i_dashboard_local_data_source.dart';
import '../models/wallet_response.dart';
import '../models/transaction_response.dart';
import '../models/spending_chart_response.dart';

class DashboardLocalDataSource implements IDashboardLocalDataSource {
  DashboardLocalDataSource();

  @override
  Future<List<WalletResponse>> getAllWallets() async {
    return [
      const WalletResponse(
        id: 1,
        label: 'Main Wallet',
        balance: 15000.0,
        currency: 'USD',
        icon: '💳',
        accentColor: '#4A90E2',
      ),
      const WalletResponse(
        id: 2,
        label: 'Savings',
        balance: 8500.0,
        currency: 'USD',
        icon: '💰',
        accentColor: '#50C878',
      ),
    ];
  }

  @override
  Future<List<TransactionResponse>> getRecentTransactions() async {
    return [
      const TransactionResponse(
        id: 1,
        title: 'Grocery Shopping',
        dateTime: '2025-12-24T10:30:00Z',
        amount: -85.50,
        isIncome: false,
        icon: '🛒',
        walletId: 1,
      ),
      const TransactionResponse(
        id: 2,
        title: 'Salary',
        dateTime: '2025-12-20T09:00:00Z',
        amount: 3500.00,
        isIncome: true,
        icon: '💵',
        walletId: 1,
      ),
      const TransactionResponse(
        id: 3,
        title: 'Netflix Subscription',
        dateTime: '2025-12-15T12:00:00Z',
        amount: -15.99,
        isIncome: false,
        icon: '🎬',
        walletId: 1,
      ),
    ];
  }

  @override
  Future<SpendingChartResponse> getWeeklySpendingChart() async {
    return const SpendingChartResponse(
      spendingData: [120.0, 85.0, 150.0, 95.0, 200.0, 175.0, 110.0],
      totalAmount: '935.00',
      percentageChange: '+12.5',
    );
  }
}
