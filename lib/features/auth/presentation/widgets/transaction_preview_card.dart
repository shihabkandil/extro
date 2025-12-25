import 'dart:ui';

import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TransactionPreviewCard extends StatelessWidget {
  const TransactionPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final localizer = context.localizer;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.slate800),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(64),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(40),
                  shape: BoxShape.circle,
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: const SizedBox.square(dimension: 120),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left: -40,
              child: Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withAlpha(40),
                  shape: BoxShape.circle,
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: const SizedBox.square(dimension: 120),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizer.totalBalance.toUpperCase(),
                            style: context.textTheme.labelSmall?.copyWith(
                              color: AppColors.slate400,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            r'$ 1352.00',
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(26),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.sync,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _TransactionItem(
                    icon: Icons.payments_outlined,
                    iconBackgroundColor: AppColors.primary.withAlpha(51),
                    iconColor: AppColors.primary,
                    title: localizer.freelance,
                    subtitle: localizer.receivedToday,
                    amount: r'+ $ 1,200.00',
                    amountColor: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  _TransactionItem(
                    icon: Icons.train_outlined,
                    iconBackgroundColor: AppColors.secondary.withAlpha(38),
                    iconColor: AppColors.secondary,
                    title: localizer.londonTravel,
                    subtitle: localizer.tubeYesterday,
                    amount: '- £ 14.50',
                    amountColor: AppColors.secondary,
                  ),
                  const SizedBox(height: 16),
                  _TransactionItem(
                    icon: Icons.restaurant_outlined,
                    iconBackgroundColor: AppColors.secondary.withAlpha(38),
                    iconColor: AppColors.secondary,
                    title: localizer.dinnerInCairo,
                    subtitle: localizer.foodTwoDaysAgo,
                    amount: '- EGP 850.00',
                    amountColor: AppColors.secondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String amount;
  final Color amountColor;

  const _TransactionItem({
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: context.textTheme.labelSmall?.copyWith(
                  color: AppColors.slate400,
                ),
              ),
            ],
          ),
        ),
        Text(
          amount,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: amountColor,
          ),
        ),
      ],
    );
  }
}
