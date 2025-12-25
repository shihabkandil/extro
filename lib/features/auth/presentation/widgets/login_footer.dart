import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final localizer = context.localizer;
    final textTheme = context.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: AppColors.slate600,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child: Text(
            localizer.privacyPolicy,
            style: textTheme.labelSmall?.copyWith(color: AppColors.slate600),
          ),
        ),
        Text(
          '•',
          style: textTheme.labelSmall?.copyWith(color: AppColors.slate600),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: AppColors.slate600,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child: Text(
            localizer.termsOfService,
            style: textTheme.labelSmall?.copyWith(color: AppColors.slate600),
          ),
        ),
      ],
    );
  }
}
