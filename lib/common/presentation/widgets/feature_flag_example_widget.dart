import 'package:flutter/material.dart';
import 'package:extro/core/di/locator.dart';
import 'package:extro/core/providers/i_feature_flag_service.dart';

/// Example widget demonstrating feature flag usage
class FeatureFlagExampleWidget extends StatelessWidget {
  const FeatureFlagExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final featureFlags = locator<IFeatureFlagService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Flags Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Example 1: Conditional feature display
          if (featureFlags.isFeatureEnabled('example_feature'))
            const Card(
              child: ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('Example Feature'),
                subtitle: Text('This feature is currently enabled'),
              ),
            ),

          const SizedBox(height: 16),

          // Example 2: Alternative UI based on flag
          featureFlags.isFeatureEnabled('new_dashboard')
              ? const Card(
                  color: Colors.blue,
                  child: ListTile(
                    leading: Icon(Icons.dashboard, color: Colors.white),
                    title: Text(
                      'New Dashboard',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Using the new dashboard design',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                )
              : const Card(
                  child: ListTile(
                    leading: Icon(Icons.dashboard_outlined),
                    title: Text('Classic Dashboard'),
                    subtitle: Text('Using the classic dashboard design'),
                  ),
                ),

          const SizedBox(height: 16),

          // Example 3: Feature with default value
          Card(
            child: ListTile(
              leading: Icon(
                featureFlags.getFeatureFlag(
                  'advanced_analytics',
                  defaultValue: false,
                )
                    ? Icons.analytics
                    : Icons.analytics_outlined,
              ),
              title: const Text('Advanced Analytics'),
              subtitle: Text(
                featureFlags.getFeatureFlag(
                  'advanced_analytics',
                  defaultValue: false,
                )
                    ? 'Advanced analytics enabled'
                    : 'Advanced analytics disabled',
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Example 4: Debug panel showing all flags
          Card(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'All Feature Flags',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...featureFlags.getAllFeatureFlags().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                entry.value
                                    ? Icons.toggle_on
                                    : Icons.toggle_off,
                                color: entry.value ? Colors.green : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                              Text(
                                entry.value.toString(),
                                style: TextStyle(
                                  color: entry.value
                                      ? Colors.green
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
