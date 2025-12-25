import 'package:flutter/material.dart';
import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/theme/app_colors.dart';

/// Data model for a recent transaction.
class RecentTransactionData {
  final String title;
  final String dateTime;
  final String amount;
  final bool isIncome;
  final IconData icon;

  const RecentTransactionData({
    required this.title,
    required this.dateTime,
    required this.amount,
    required this.isIncome,
    required this.icon,
  });
}

/// A widget that displays a single transaction item in the recent transactions list.
class RecentTransactionItem extends StatelessWidget {
  final RecentTransactionData transaction;
  final VoidCallback? onTap;

  const RecentTransactionItem({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.slate200),
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: transaction.isIncome
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.slate100,
                ),
                child: Icon(
                  transaction.icon,
                  color: transaction.isIncome
                      ? AppColors.primary
                      : AppColors.slate600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Title and Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      transaction.dateTime,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: AppColors.slate500,
                      ),
                    ),
                  ],
                ),
              ),
              // Amount
              Text(
                transaction.amount,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: transaction.isIncome
                      ? AppColors.primary
                      : AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
