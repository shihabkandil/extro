import 'package:flutter/material.dart';
import 'package:extro/core/theme/app_colors.dart';
import 'package:extro/core/extensions/context_extensions.dart';

/// Financial Dashboard Screen
/// A self-contained Flutter screen that replicates the EXTRO financial dashboard UI
class FinancialDashboardScreen extends StatelessWidget {
  const FinancialDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Custom App Header
                const _AppHeader(),
                const SizedBox(height: 32),
                // Metric Cards Section (Income & Expenses)
                _MetricCardsSection(
                  incomeValue: '+\$5,200.00',
                  expensesValue: '-\$1,850.50',
                  cardPeriod: context.localizer.thisMonth,
                ),
                const SizedBox(height: 32),
                // Recent Transactions Section
                _RecentTransactionsSection(
                  title: context.localizer.recentTransactions,
                  transactions: const [
                    _TransactionData(
                      title: 'Salary Deposit',
                      category: 'Tnem Pection',
                      amount: 2500.00,
                      isIncome: true,
                    ),
                    _TransactionData(
                      title: 'Grocery Shopping',
                      category: 'Food & Dining',
                      amount: 15.50,
                      isIncome: false,
                    ),
                    _TransactionData(
                      title: 'Freelance Payment',
                      category: 'Income',
                      amount: 800.00,
                      isIncome: true,
                    ),
                    _TransactionData(
                      title: 'Electricity Bill',
                      category: 'Utilities',
                      amount: 125.00,
                      isIncome: false,
                    ),
                  ],
                ),
                const SizedBox(height: 100), // Space for FAB
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _GradientFAB(
        label: context.localizer.addNew,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

/// Custom App Header with EXTRO title
class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        'EXTRO',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

/// Metric Cards Section containing Income and Expenses cards
class _MetricCardsSection extends StatelessWidget {
  final String incomeValue;
  final String expensesValue;
  final String cardPeriod;

  const _MetricCardsSection({
    required this.incomeValue,
    required this.expensesValue,
    required this.cardPeriod,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            value: incomeValue,
            period: cardPeriod,
            label: context.localizer.income,
            gradientColors: const [AppColors.incomeDark, AppColors.incomeLight],
            isIncome: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _MetricCard(
            value: expensesValue,
            period: cardPeriod,
            label: context.localizer.expenses,
            gradientColors: const [AppColors.expensesDark, AppColors.expensesLight],
            isIncome: false,
          ),
        ),
      ],
    );
  }
}

/// Individual Metric Card with gradient background
class _MetricCard extends StatelessWidget {
  final String value;
  final String period;
  final String label;
  final List<Color> gradientColors;
  final bool isIncome;

  const _MetricCard({
    required this.value,
    required this.period,
    required this.label,
    required this.gradientColors,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Currency icons or arrow
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isIncome)
                const Row(
                  children: [
                    Text('€', style: TextStyle(color: AppColors.white, fontSize: 16)),
                    SizedBox(width: 4),
                    Text('¥', style: TextStyle(color: AppColors.white, fontSize: 16)),
                    SizedBox(width: 4),
                    Text('£', style: TextStyle(color: AppColors.white, fontSize: 16)),
                  ],
                ),
              if (!isIncome) const SizedBox.shrink(),
              Icon(
                isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                color: AppColors.white,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Label
          Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          // Value
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          // Period
          Text(
            period,
            style: TextStyle(
              color: AppColors.white.withOpacity(0.8),
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Recent Transactions Section
class _RecentTransactionsSection extends StatelessWidget {
  final String title;
  final List<_TransactionData> transactions;

  const _RecentTransactionsSection({
    required this.title,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 16),
        ...transactions.map((transaction) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _TransactionTile(transaction: transaction),
            )),
      ],
    );
  }
}

/// Transaction Data Model
class _TransactionData {
  final String title;
  final String category;
  final double amount;
  final bool isIncome;

  const _TransactionData({
    required this.title,
    required this.category,
    required this.amount,
    required this.isIncome,
  });
}

/// Individual Transaction Tile
class _TransactionTile extends StatelessWidget {
  final _TransactionData transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: transaction.isIncome 
                    ? AppColors.incomeGreen 
                    : AppColors.expenseRed,
                width: 2,
              ),
            ),
            child: Icon(
              transaction.isIncome ? Icons.add : Icons.remove,
              color: transaction.isIncome 
                  ? AppColors.incomeGreen 
                  : AppColors.expenseRed,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Title and Category
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.category,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: transaction.isIncome 
                      ? AppColors.incomeGreen 
                      : AppColors.expenseRed,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${(transaction.amount * 0.1).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Gradient Floating Action Button
class _GradientFAB extends StatelessWidget {
  final String label;

  const _GradientFAB({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.fabOrange, AppColors.fabRed],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.fabOrange.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle add new action
          },
          borderRadius: BorderRadius.circular(28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add,
                color: AppColors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
