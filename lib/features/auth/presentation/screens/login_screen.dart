import 'package:auto_route/auto_route.dart';
import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/router/app_router.gr.dart';
import 'package:extro/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final localizer = context.localizer;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 32),
                // Logo
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.backgroundDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(38),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundDark,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.account_balance_wallet,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Title
                Text(
                  localizer.masterYourMoney,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Subtitle
                Text(
                  localizer.trackExpensesSubtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withAlpha(179),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                // Social login buttons
                _SocialLoginButtons(),
                const SizedBox(height: 24),
                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        localizer.orContinueWithoutLogin,
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurface.withAlpha(153),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Continue without login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      shadowColor: AppColors.secondary.withAlpha(38),
                    ),
                    onPressed: () => context.pushRoute(const DashboardRoute()),
                    child: Text(
                      localizer.continueWithoutLogin,
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Footer
                _LoginFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialLoginButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizer = context.localizer;
    final textTheme = context.textTheme;
    return Column(
      children: [
        // Apple
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            minimumSize: const Size.fromHeight(48),
            elevation: 1,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: const BorderSide(color: Colors.transparent),
          ),
          icon: const Icon(Icons.apple, size: 22),
          label: Text(
            localizer.continueWithApple,
            style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          onPressed: () {},
        ),
        const SizedBox(height: 12),
        // Google
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4285F4),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            elevation: 1,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          label: Text(
            localizer.continueWithGoogle,
            style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _LoginFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizer = context.localizer;
    final textTheme = context.textTheme;
    return Column(
      children: [
        Text.rich(
          TextSpan(
            text: localizer.dontHaveAccount,
            style: textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface.withAlpha(179),
            ),
            children: [
              const TextSpan(text: ' '),
              TextSpan(
                text: localizer.signUp,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: context.colorScheme.onSurface.withAlpha(153),
              ),
              child: Text(localizer.privacyPolicy, style: textTheme.labelSmall),
            ),
            Text(
              '•',
              style: textTheme.labelSmall?.copyWith(
                color: context.colorScheme.onSurface.withAlpha(102),
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: context.colorScheme.onSurface.withAlpha(153),
              ),
              child: Text(
                localizer.termsOfService,
                style: textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
