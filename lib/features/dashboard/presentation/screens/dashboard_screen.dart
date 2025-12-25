import 'package:auto_route/auto_route.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/cubits/spending_chart_cubit/spending_chart_cubit.dart';
import '../../domain/cubits/transaction_cubit/transaction_cubit.dart';
import '../../domain/cubits/wallet_cubit/wallet_cubit.dart';

@RoutePage()
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentNavIndex = 0;

  void _onNavTap(int index) => setState(() => _currentNavIndex = index);

  void _onAddTap() {}

  void _onNotificationTap() {}

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WalletCubit>(
          create: (context) => WalletCubit()..fetchWallets(),
        ),
        BlocProvider<TransactionCubit>(
          create: (context) => TransactionCubit()..fetchRecentTransactions(),
        ),
        BlocProvider<SpendingChartCubit>(
          create: (context) => SpendingChartCubit()..fetchWeeklySpendingChart(),
        ),
      ],
      child: Scaffold(
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
                  DashboardAppHeader(
                    userName: 'Alex Morgan',
                    onNotificationTap: _onNotificationTap,
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<WalletCubit, WalletState>(
                    builder: (context, walletState) {
                      return walletState.maybeWhen(
                        success: (wallets) => TotalBalanceCard(
                          balance: wallets.isNotEmpty
                              ? wallets.first.balance.toString()
                              : '0',
                          currency: wallets.isNotEmpty
                              ? wallets.first.currency
                              : '',
                          percentageChange: '+2.5%',
                        ),
                        orElse: () => const TotalBalanceCard(
                          balance: '0',
                          currency: '',
                          percentageChange: '+0%',
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: context.localizer.wallets,
                    actionText: context.localizer.viewAll,
                    onActionTap: () {},
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<WalletCubit, WalletState>(
                    builder: (context, walletState) {
                      return walletState.maybeWhen(
                        success: (wallets) => SizedBox(
                          height: 128,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: wallets.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final wallet = wallets[index];
                              return WalletCard(
                                wallet: WalletData(
                                  label: wallet.label,
                                  balance: wallet.balance.toStringAsFixed(2),
                                  currencySymbol: wallet.currency,
                                  accentColor: Color(
                                    int.parse(
                                      wallet.accentColor.replaceFirst(
                                        '#',
                                        '0xFF',
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        orElse: () => const SizedBox(height: 128),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<TransactionCubit, TransactionState>(
                    builder: (context, transactionState) {
                      return transactionState.maybeWhen(
                        success: (transactions) => Row(
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
                        orElse: () => Row(
                          children: [
                            Expanded(
                              child: StatsCard(
                                label: context.localizer.income,
                                value: '+\$0',
                                isIncome: true,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: StatsCard(
                                label: context.localizer.expenses,
                                value: '-\$0',
                                isIncome: false,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<SpendingChartCubit, SpendingChartState>(
                    builder: (context, chartState) {
                      return chartState.maybeWhen(
                        success: (chart) => WeeklySpendingChart(
                          totalAmount: chart.totalAmount,
                          percentageChange: chart.percentageChange,
                          spendingData: chart.spendingData,
                        ),
                        orElse: () => const WeeklySpendingChart(
                          totalAmount: '0',
                          percentageChange: '+0%',
                          spendingData: [],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: context.localizer.recentTransactions,
                    actionText: context.localizer.seeAll,
                    onActionTap: () {},
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<TransactionCubit, TransactionState>(
                    builder: (context, transactionState) {
                      return transactionState.maybeWhen(
                        success: (transactions) => ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: transactions.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            return RecentTransactionItem(
                              transaction: RecentTransactionData(
                                title: transaction.title,
                                dateTime: transaction.dateTime.toString(),
                                amount:
                                    '${transaction.isIncome ? '+' : ''}\$${transaction.amount.abs().toStringAsFixed(2)}',
                                isIncome: transaction.isIncome,
                                icon: Icons.shopping_bag,
                              ),
                            );
                          },
                        ),
                        orElse: () => const SizedBox.shrink(),
                      );
                    },
                  ),
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
      ),
    );
  }
}
