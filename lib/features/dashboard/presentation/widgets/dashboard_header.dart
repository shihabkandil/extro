import 'package:flutter/material.dart';
import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/theme/app_colors.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        'EXTRO',
        style: context.textTheme.headlineLarge?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
