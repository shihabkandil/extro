import 'package:flutter/material.dart';
import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/features/auth/domain/entities/oauth_provider.dart';

class SignInButton extends StatelessWidget {
  final OAuthProvider provider;
  final bool isLoading;
  final VoidCallback onPressed;

  const SignInButton({
    super.key,
    required this.provider,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final buttonConfig = _getButtonConfig(context);

    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonConfig.backgroundColor,
          foregroundColor: buttonConfig.foregroundColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: buttonConfig.borderColor,
              width: 1,
            ),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    buttonConfig.icon,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    buttonConfig.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  _ButtonConfig _getButtonConfig(BuildContext context) {
    switch (provider) {
      case OAuthProvider.google:
        return _ButtonConfig(
          label: context.localizer.signInWithGoogle,
          icon: Icons.g_mobiledata,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          borderColor: Colors.grey[300]!,
        );
      case OAuthProvider.apple:
        return _ButtonConfig(
          label: context.localizer.signInWithApple,
          icon: Icons.apple,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          borderColor: Colors.black,
        );
    }
  }
}

class _ButtonConfig {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;

  _ButtonConfig({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
  });
}
