import 'package:auto_route/auto_route.dart';
import 'package:extro/common/presentation/ui_utils/app_toast.dart';
import 'package:extro/common/presentation/widgets/primary_button.dart';
import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/failures/display_error.dart';
import 'package:extro/core/feature_flags/domain/feature_flag.dart';
import 'package:extro/core/feature_flags/utils/feature_flag_extensions.dart';
import 'package:extro/core/router/app_router.gr.dart';
import 'package:extro/core/theme/app_colors.dart';
import 'package:extro/features/auth/domain/cubits/auth_cubit/auth_cubit.dart';
import 'package:extro/features/auth/domain/entities/oauth_provider.dart';
import 'package:extro/features/auth/presentation/widgets/feature_indicators.dart';
import 'package:extro/features/auth/presentation/widgets/login_footer.dart';
import 'package:extro/features/auth/presentation/widgets/login_header.dart';
import 'package:extro/features/auth/presentation/widgets/login_headline.dart';
import 'package:extro/features/auth/presentation/widgets/sign_in_button.dart';
import 'package:extro/features/auth/presentation/widgets/transaction_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: Column(
        children: [
          Container(
            height: 6,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
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

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.viewPaddingOf(context).top),
                        const LoginHeader(),
                        const SizedBox(height: 16),
                        const LoginHeadline(),
                        const SizedBox(height: 32),
                        const TransactionPreviewCard(),
                        const SizedBox(height: 16),
                        const FeatureIndicators(),
                        const Spacer(),
                        if (context.isFeatureEnabled(
                          FeatureFlag.oauthProviders,
                        )) ...[
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
                        PrimaryButton(
                          text: context.localizer.continueAsGuest,
                          onPressed: () =>
                              context.pushRoute(const DashboardRoute()),
                        ),
                        const SizedBox(height: 20),
                        const LoginFooter(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
