import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TransactionData {
  final String title;
  final String category;
  final double amount;
  final bool isIncome;

  const TransactionData({
    required this.title,
    required this.category,
    required this.amount,
    required this.isIncome,
  });
}

class TransactionTile extends StatelessWidget {
  final TransactionData transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.colorScheme.onSurface,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.inverseSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.category,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.inverseSurface,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: transaction.isIncome
                      ? AppColors.incomeGreen
                      : AppColors.expenseRed,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${(transaction.amount * 0.1).toStringAsFixed(2)}',
                style: context.textTheme.bodySmall?.copyWith(
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
