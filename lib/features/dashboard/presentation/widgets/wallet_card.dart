import 'package:flutter/material.dart';
import 'package:extro/core/extensions/context_extensions.dart';

/// Data model for a wallet/currency card.
class WalletData {
  final String label;
  final String balance;
  final String? currencySymbol;
  final IconData? icon;
  final Color accentColor;

  const WalletData({
    required this.label,
    required this.balance,
    this.currencySymbol,
    this.icon,
    required this.accentColor,
  });
}

/// A widget that displays a wallet/currency card with balance.
class WalletCard extends StatelessWidget {
  final WalletData wallet;
  final VoidCallback? onTap;

  const WalletCard({super.key, required this.wallet, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 140),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colorScheme.onSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colorScheme.onSurface),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.onSurface.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Container
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: wallet.accentColor.withValues(alpha: 0.1),
              ),
              child: Center(
                child: wallet.icon != null
                    ? Icon(wallet.icon, color: wallet.accentColor, size: 20)
                    : Text(
                        wallet.currencySymbol ?? '',
                        style: context.textTheme.labelMedium?.copyWith(
                          color: wallet.accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            // Label
            Text(
              wallet.label,
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.inverseSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            // Balance
            Text(
              wallet.balance,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.inverseSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
