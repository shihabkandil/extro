import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class DashboardBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAddTap;

  const DashboardBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.onSurface,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavBarItem(
              icon: Icons.dashboard_outlined,
              activeIcon: Icons.dashboard,
              label: context.localizer.overview,
              isSelected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavBarItem(
              icon: Icons.receipt_long_outlined,
              activeIcon: Icons.receipt_long,
              label: context.localizer.history,
              isSelected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: onAddTap,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
            _NavBarItem(
              icon: Icons.account_balance_wallet_outlined,
              activeIcon: Icons.account_balance_wallet,
              label: context.localizer.wallets,
              isSelected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            _NavBarItem(
              icon: Icons.settings_outlined,
              activeIcon: Icons.settings,
              label: context.localizer.settings,
              isSelected: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.slate400;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: const BoxConstraints(minWidth: 64),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isSelected ? activeIcon : icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: context.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
