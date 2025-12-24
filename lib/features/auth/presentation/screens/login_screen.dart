import 'package:auto_route/auto_route.dart';
import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/failures/display_error.dart';
import 'package:extro/core/feature_flags/domain/feature_flag.dart';
import 'package:extro/core/feature_flags/utils/feature_flag_extensions.dart';
import 'package:extro/features/auth/domain/cubits/auth_cubit/auth_cubit.dart';
import 'package:extro/features/auth/domain/entities/oauth_provider.dart';
import 'package:extro/features/auth/presentation/widgets/sign_in_button.dart';
import 'package:extro/core/theme/app_colors.dart';
import 'package:extro/core/router/app_router.gr.dart';
import 'package:flutter/material.dart';
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            state.whenOrNull(
              failure: (failure) {
                AppToast.showError(
                  DisplayError.fromFailure(context.localizer, failure),
                );
              },
              authenticated: (user) {
                AppToast.showSuccess(
                  '${context.localizer.welcomeBack} ${user.name ?? user.email}!',
                );
              },
            );
          },
          builder: (context, state) {
            final isLoading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.account_balance_wallet,
                      size: 80,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      context.localizer.appTitle,
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.localizer.welcomeBack,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    if (context.isFeatureEnabled(
                      FeatureFlag.oauthProviders,
                    )) ...[
                      Text(
                        context.localizer.signInToContinue,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      SignInButton(
                        provider: OAuthProvider.google,
                        isLoading: isLoading,
                        onPressed: () {
                          context.read<AuthCubit>().signInWithProvider(
                            OAuthProvider.google,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      SignInButton(
                        provider: OAuthProvider.apple,
                        isLoading: isLoading,
                        onPressed: () {
                          context.read<AuthCubit>().signInWithProvider(
                            OAuthProvider.apple,
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 24),
                    // Fallback: continue without login
                    _SocialLoginButtons(),
                    const SizedBox(height: 24),
                    _LoginFooter(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
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
=======
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            state.whenOrNull(
              failure: (failure) {
                AppToast.showError(
                  DisplayError.fromFailure(context.localizer, failure),
                );
              },
              authenticated: (user) {
                AppToast.showSuccess(
                  '${context.localizer.welcomeBack} ${user.name ?? user.email}!',
                );
              },
            );
          },
          builder: (context, state) {
            final isLoading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.account_balance_wallet,
                      size: 80,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      context.localizer.appTitle,
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.localizer.welcomeBack,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    if (context.isFeatureEnabled(
                      FeatureFlag.oauthProviders,
                    )) ...[
                      Text(
                        context.localizer.signInToContinue,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      SignInButton(
                        provider: OAuthProvider.google,
                        isLoading: isLoading,
                        onPressed: () {
                          context.read<AuthCubit>().signInWithProvider(
                            OAuthProvider.google,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      SignInButton(
                        provider: OAuthProvider.apple,
                        isLoading: isLoading,
                        onPressed: () {
                          context.read<AuthCubit>().signInWithProvider(
                            OAuthProvider.apple,
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
>>>>>>> develop
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
