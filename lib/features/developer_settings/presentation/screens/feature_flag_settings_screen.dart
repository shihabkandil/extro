import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/feature_flags/cubit/feature_flag_cubit.dart';
import 'package:extro/core/feature_flags/cubit/feature_flag_state.dart';
import 'package:extro/core/feature_flags/feature_flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A developer settings screen to manage feature flags.
///
/// This screen allows developers to:
/// - View all feature flags and their current status
/// - Toggle feature flags on/off
/// - See the effects immediately in the app
///
/// This is useful for:
/// - Testing features during development
/// - QA testing different feature combinations
/// - Demonstrating features to stakeholders
/// - Debugging feature-specific issues
class FeatureFlagSettingsScreen extends StatelessWidget {
  const FeatureFlagSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Flags'),
        backgroundColor: context.colorScheme.primary,
        foregroundColor: context.colorScheme.onPrimary,
      ),
      body: BlocBuilder<FeatureFlagCubit, FeatureFlagState>(
        builder: (context, state) {
          final cubit = context.read<FeatureFlagCubit>();
          
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: context.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Developer Settings',
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Toggle feature flags to enable or disable features in the app. '
                        'Changes take effect immediately.',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Feature Flags',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...FeatureFlag.values.map((flag) {
                final isEnabled = state.flags[flag.name] ?? true;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: SwitchListTile(
                    title: Text(
                      _formatFlagName(flag.name),
                      style: context.textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      _getFlagDescription(flag),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    value: isEnabled,
                    onChanged: (value) {
                      if (value) {
                        cubit.enable(flag);
                      } else {
                        cubit.disable(flag);
                      }
                    },
                    secondary: Icon(
                      isEnabled ? Icons.check_circle : Icons.cancel,
                      color: isEnabled
                          ? context.colorScheme.primary
                          : context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              Card(
                color: context.colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.code,
                            color: context.colorScheme.onSecondaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Usage Example',
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: context.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: context.colorScheme.outline.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          "if (context.isFeatureEnabled(\n"
                          "    FeatureFlag.dashboard)) {\n"
                          "  // Show dashboard\n"
                          "}",
                          style: context.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatFlagName(String name) {
    return name
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(0)}',
        )
        .trim()
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _getFlagDescription(FeatureFlag flag) {
    switch (flag) {
      case FeatureFlag.exampleFeature:
        return 'Controls the visibility of example features and demo content';
      case FeatureFlag.dashboard:
        return 'Enables the financial dashboard with metrics and transactions';
      case FeatureFlag.authentication:
        return 'Controls authentication and user account features';
      case FeatureFlag.oauthProviders:
        return 'Enables OAuth login providers (Google, Apple)';
    }
  }
}
