import 'package:flutter/material.dart';
import 'package:extro/core/theme/app_colors.dart';

class MetricCard extends StatelessWidget {
  final String value;
  final String period;
  final String label;
  final List<Color> gradientColors;
  final bool isIncome;

  const MetricCard({
    super.key,
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
          Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
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
