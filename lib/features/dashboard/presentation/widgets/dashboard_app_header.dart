import 'package:flutter/material.dart';
import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/theme/app_colors.dart';

/// A widget that displays the dashboard header with user profile,
/// greeting message, sync indicator, and notification button.
class DashboardAppHeader extends StatelessWidget {
  final String userName;
  final String? avatarUrl;
  final VoidCallback? onNotificationTap;
  final bool isSynced;

  const DashboardAppHeader({
    super.key,
    required this.userName,
    this.avatarUrl,
    this.onNotificationTap,
    this.isSynced = true,
  });

  String _getGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return context.localizer.goodMorning;
    } else if (hour < 17) {
      return context.localizer.goodAfternoon;
    } else {
      return context.localizer.goodEvening;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // User Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 2,
                ),
                image: avatarUrl != null
                    ? DecorationImage(
                        image: NetworkImage(avatarUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: avatarUrl == null
                  ? Center(
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                        style: context.textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            // Greeting and Name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(context),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.slate500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  userName,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ],
        ),
        // Right side icons
        Row(
          children: [
            // Sync Indicator
            if (isSynced)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
                child: const Icon(
                  Icons.cloud_done_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            const SizedBox(width: 8),
            // Notifications Button
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onNotificationTap,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.slate700,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
