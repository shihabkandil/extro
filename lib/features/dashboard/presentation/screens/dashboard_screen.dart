import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/theme/app_colors.dart';
import 'package:extro/features/dashboard/presentation/widgets/bottom_nav_bar.dart';
import 'package:extro/features/dashboard/presentation/widgets/dashboard_app_header.dart';
import 'package:extro/features/dashboard/presentation/widgets/recent_transaction_item.dart';
import 'package:extro/features/dashboard/presentation/widgets/section_header.dart';
import 'package:extro/features/dashboard/presentation/widgets/stats_card.dart';
import 'package:extro/features/dashboard/presentation/widgets/total_balance_card.dart';
import 'package:extro/features/dashboard/presentation/widgets/wallet_card.dart';
import 'package:extro/features/dashboard/presentation/widgets/weekly_spending_chart.dart';
import 'package:flutter/material.dart';

/// The main dashboard screen displaying financial overview, wallets,
/// income/expense stats, spending chart, and recent transactions.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentNavIndex = 0;

  // Sample wallet data
  final List<WalletData> _wallets = const [
    WalletData(
      label: 'USD Balance',
      balance: '\$4,500.00',
      icon: Icons.attach_money,
      accentColor: AppColors.usdBlue,
    ),
    WalletData(
      balance: '£3,200.00',
      icon: Icons.currency_pound,
      accentColor: AppColors.gbpPurple,
    ),
    WalletData(
      label: 'EGP Balance',
      balance: '50,000',
      currencySymbol: 'E£',
      accentColor: AppColors.egpEmerald,
    ),
  ];

  // Sample transactions data
  final List<RecentTransactionData> _transactions = const [
    RecentTransactionData(
      title: 'Grocery Market',
      dateTime: 'Today, 10:23 AM',
      amount: '-\$45.20',
      isIncome: false,
      icon: Icons.shopping_bag_outlined,
    ),
      title: 'Uber Ride',
      dateTime: 'Yesterday, 6:15 PM',
      amount: '-\$12.50',
      isIncome: false,
      icon: Icons.directions_car_outlined,
    ),
    RecentTransactionData(
      title: 'Freelance Project',
      dateTime: 'Oct 24, 2023',
      amount: '+\$850.00',
      isIncome: true,
      icon: Icons.payments_outlined,
    ),
  ];

  // Sample chart data (represents spending values for Mon-Sun)
  final List<double> _spendingData = const [35, 40, 20, 30, 15, 25, 10];

  void _onNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });
  }

    // TODO: Navigate to add transaction screen
  }

  void _onNotificationTap() {
    // TODO: Navigate to notifications
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Header
                DashboardAppHeader(
                  userName: 'Alex Morgan',
                  onNotificationTap: _onNotificationTap,
                ),
                const SizedBox(height: 24),
                // Total Balance Card
                const TotalBalanceCard(
                  balance: '£12,450.00',
                  currency: 'GBP',
                  percentageChange: '+2.5%',
                ),
                const SizedBox(height: 24),
                // Wallets Section
                SectionHeader(
                  title: context.localizer.wallets,
                  actionText: context.localizer.viewAll,
                  onActionTap: () {
                    // TODO: Navigate to wallets
                  },
                ),
                const SizedBox(height: 12),
                // Wallets Horizontal Scroll
                SizedBox(
                  height: 128,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _wallets.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return WalletCard(wallet: _wallets[index]);
                    },
                  ),
                ),
                const SizedBox(height: 24),
                // Income/Expense Stats Row
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        label: context.localizer.income,
                        value: '+\$2,000',
                        isIncome: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatsCard(
                        label: context.localizer.expenses,
                        value: '-\$850',
                        isIncome: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Weekly Spending Chart
                WeeklySpendingChart(
                  totalAmount: '£850',
                  percentageChange: '-5%',
                  spendingData: _spendingData,
                ),
                const SizedBox(height: 24),
                // Recent Transactions Section
                SectionHeader(
                  title: context.localizer.recentTransactions,
                  actionText: context.localizer.seeAll,
                  onActionTap: () {
                    // TODO: Navigate to all transactions
                  },
                ),
                const SizedBox(height: 12),
                // Transactions List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _transactions.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return RecentTransactionItem(
                      transaction: _transactions[index],
                    );
                  },
                ),
                // Bottom padding for navigation bar
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: DashboardBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
        onAddTap: _onAddTap,
      ),
    );
  }
}
