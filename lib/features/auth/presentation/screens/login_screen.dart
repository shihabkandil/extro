import 'package:extro/common/presentation/ui_utils/app_toast.dart';
import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/failures/display_error.dart';
import 'package:extro/features/auth/domain/cubits/auth_cubit/auth_cubit.dart';
import 'package:extro/features/auth/domain/cubits/auth_cubit/auth_state.dart';
import 'package:extro/features/auth/domain/entities/oauth_provider.dart';
import 'package:extro/features/auth/presentation/widgets/sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
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
                      '${context.localizer.welcomeBack} ${user.name ?? user.email}!');
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
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
