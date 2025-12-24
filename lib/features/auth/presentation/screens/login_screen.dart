// Clean LoginScreen implementation (single, non-duplicated)
import 'package:auto_route/auto_route.dart';
import 'package:extro/common/presentation/ui_utils/app_toast.dart';
import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/failures/display_error.dart';
import 'package:extro/core/feature_flags/domain/feature_flag.dart';
import 'package:extro/core/feature_flags/utils/feature_flag_extensions.dart';
import 'package:extro/core/router/app_router.gr.dart';
import 'package:extro/core/theme/app_colors.dart';
import 'package:extro/features/auth/domain/cubits/auth_cubit/auth_cubit.dart';
import 'package:extro/features/auth/domain/entities/oauth_provider.dart';
import 'package:extro/features/auth/presentation/widgets/sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            state.whenOrNull(
              failure: (failure) => AppToast.showError(
                DisplayError.fromFailure(context.localizer, failure),
              ),
              authenticated: (user) => AppToast.showSuccess(
                '${context.localizer.welcomeBack} ${user.name ?? user.email}!',
              ),
            );
          },
          builder: (context, state) {
            final isLoading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    Text(
                      context.localizer.masterYourMoney,
                      textAlign: TextAlign.center,
                      style: context.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    if (context.isFeatureEnabled(
                      FeatureFlag.oauthProviders,
                    )) ...[
                      Text(
                        context.localizer.signInToContinue,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      SignInButton(
                        provider: OAuthProvider.google,
                        isLoading: isLoading,
                        onPressed: () => context
                            .read<AuthCubit>()
                            .signInWithProvider(OAuthProvider.google),
                      ),
                      const SizedBox(height: 12),
                      SignInButton(
                        provider: OAuthProvider.apple,
                        isLoading: isLoading,
                        onPressed: () => context
                            .read<AuthCubit>()
                            .signInWithProvider(OAuthProvider.apple),
                      ),
                      const SizedBox(height: 16),
                    ],
                    ElevatedButton(
                      onPressed: () =>
                          context.pushRoute(const DashboardRoute()),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(context.localizer.continueWithoutLogin),
                    ),
                    const SizedBox(height: 16),
                    const _LoginFooter(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LoginFooter extends StatelessWidget {
  const _LoginFooter();

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
