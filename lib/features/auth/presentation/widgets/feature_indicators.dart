import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FeatureIndicators extends StatelessWidget {
  const FeatureIndicators({super.key});

  @override
  Widget build(BuildContext context) {
    final localizer = context.localizer;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _FeatureIndicator(
          icon: Icons.cloud_off_outlined,
          label: localizer.offline,
        ),
        _buildDivider(context),
        _FeatureIndicator(icon: Icons.lock_outline, label: localizer.secure),
        _buildDivider(context),
        _FeatureIndicator(
          icon: Icons.currency_exchange,
          label: localizer.multiCur,
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      color: AppColors.slate800,
    );
  }
}

class _FeatureIndicator extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureIndicator({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.slate500, size: 24),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: context.textTheme.labelSmall?.copyWith(
            color: AppColors.slate500,
            fontWeight: FontWeight.bold,
            fontSize: 10,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
