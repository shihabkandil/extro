import 'package:auto_route/auto_route.dart';
import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/theme/app_colors.dart';
import 'package:extro/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:extro/features/dashboard/presentation/widgets/gradient_fab.dart';
import 'package:extro/features/dashboard/presentation/widgets/metric_card.dart';
import 'package:extro/features/dashboard/presentation/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';

@RoutePage()
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
                const DashboardHeader(),
                const SizedBox(height: 32),
                _MetricCardsSection(
                  incomeValue: '+\$5,200.00',
                  expensesValue: '-\$1,850.50',
                  cardPeriod: context.localizer.thisMonth,
                ),
                const SizedBox(height: 32),
                _RecentTransactionsSection(
                  title: context.localizer.recentTransactions,
                  transactions: const [
                    TransactionData(
                      title: 'Salary Deposit',
                      category: 'Tnem Pection',
                      amount: 2500.00,
                      isIncome: true,
                    ),
                    TransactionData(
                      title: 'Grocery Shopping',
                      category: 'Food & Dining',
                      amount: 15.50,
                      isIncome: false,
                    ),
                    TransactionData(
                      title: 'Freelance Payment',
                      category: 'Income',
                      amount: 800.00,
                      isIncome: true,
                    ),
                    TransactionData(
                      title: 'Electricity Bill',
                      category: 'Utilities',
                      amount: 125.00,
                      isIncome: false,
                    ),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: GradientFAB(label: context.localizer.addNew),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

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
          child: MetricCard(
            value: incomeValue,
            period: cardPeriod,
            label: context.localizer.income,
            gradientColors: const [AppColors.incomeDark, AppColors.incomeLight],
            isIncome: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: MetricCard(
            value: expensesValue,
            period: cardPeriod,
            label: context.localizer.expenses,
            gradientColors: const [
              AppColors.expensesDark,
              AppColors.expensesLight,
            ],
            isIncome: false,
          ),
        ),
      ],
    );
  }
}

class _RecentTransactionsSection extends StatelessWidget {
  final String title;
  final List<TransactionData> transactions;

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
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 16),
        ...transactions.map(
          (transaction) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TransactionTile(transaction: transaction),
          ),
        ),
      ],
    );
  }
}
