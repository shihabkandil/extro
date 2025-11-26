import 'package:extro/core/di/locator.dart';
import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/feature_flags/feature_flag.dart';
import 'package:extro/core/feature_flags/i_feature_flag_service.dart';
import 'package:flutter/material.dart';

/// Example demonstrating various ways to use the Feature Flag Service.
///
/// This file shows how to:
/// 1. Use feature flags in widget build methods
/// 2. Access feature flags via context extensions
/// 3. Access feature flags directly from the service
/// 4. Conditionally render UI elements
/// 5. Create feature gates for navigation
class FeatureFlagExamples {
  /// Example 1: Simple conditional rendering in a widget
  static Widget conditionalWidgetExample(BuildContext context) {
    return Column(
      children: [
        const Text('Welcome to the app!'),
        
        // Only show this widget if the dashboard feature is enabled
        if (context.isFeatureEnabled(FeatureFlag.dashboard))
          const Text('Dashboard is available'),
        
        // Only show OAuth providers if enabled
        if (context.isFeatureEnabled(FeatureFlag.oauthProviders))
          ElevatedButton(
            onPressed: () {},
            child: const Text('Sign in with Google'),
          ),
      ],
    );
  }

  /// Example 2: Navigation guard - only navigate if feature is enabled
  static void navigateToFeature(BuildContext context, FeatureFlag flag, Widget screen) {
    if (context.isFeatureEnabled(flag)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This feature is not available yet')),
      );
    }
  }

  /// Example 3: Direct service access (useful in cubits, repositories, etc.)
  static bool checkFeatureInService(FeatureFlag flag) {
    final service = locator<IFeatureFlagService>();
    return service.isEnabled(flag);
  }

  /// Example 4: Widget that adapts based on feature flags
  static Widget adaptiveMenuExample(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text('Menu')),
          const ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
          ),
          
          // Conditionally show dashboard menu item
          if (context.isFeatureEnabled(FeatureFlag.dashboard))
            const ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
            ),
          
          // Conditionally show example feature
          if (context.isFeatureEnabled(FeatureFlag.exampleFeature))
            const ListTile(
              leading: Icon(Icons.science),
              title: Text('Example Feature'),
            ),
          
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }

  /// Example 5: Feature flag admin/debug screen
  static Widget featureFlagDebugScreen(BuildContext context) {
    final service = locator<IFeatureFlagService>();
    final flags = service.getAllFlags();

    return Scaffold(
      appBar: AppBar(title: const Text('Feature Flags')),
      body: ListView.builder(
        itemCount: flags.length,
        itemBuilder: (context, index) {
          final entry = flags.entries.elementAt(index);
          final flagName = entry.key;
          final isEnabled = entry.value;
          
          // Find the corresponding enum value
          final flag = FeatureFlag.values.firstWhere(
            (f) => f.name == flagName,
          );

          return SwitchListTile(
            title: Text(flagName),
            subtitle: Text(isEnabled ? 'Enabled' : 'Disabled'),
            value: isEnabled,
            onChanged: (value) {
              if (value) {
                service.enable(flag);
              } else {
                service.disable(flag);
              }
              // Rebuild the screen to reflect changes
              (context as Element).markNeedsBuild();
            },
          );
        },
      ),
    );
  }

  /// Example 6: Programmatically updating flags (e.g., from remote config)
  static Future<void> simulateRemoteFlagUpdate() async {
    final service = locator<IFeatureFlagService>();
    
    // Simulate fetching flags from a remote service
    await Future.delayed(const Duration(seconds: 1));
    
    // Update multiple flags at once
    service.updateFlags({
      'dashboard': true,
      'authentication': true,
      'oauthProviders': false,
      'exampleFeature': true,
    });
  }

  /// Example 7: A/B testing or gradual rollout simulation
  static Widget abTestExample(BuildContext context) {
    // You could extend this with user segmentation
    if (context.isFeatureEnabled(FeatureFlag.exampleFeature)) {
      // Show new version
      return Container(
        color: Colors.blue,
        child: const Center(child: Text('New Design (A/B Test)')),
      );
    } else {
      // Show old version
      return Container(
        color: Colors.grey,
        child: const Center(child: Text('Original Design')),
      );
    }
  }

  /// Example 8: Using in a Cubit or Service
  static void exampleInCubit() {
    // In a real cubit, you'd inject the service via constructor
    final service = locator<IFeatureFlagService>();
    
    if (service.isEnabled(FeatureFlag.exampleFeature)) {
      // Execute new feature logic
      print('Using new feature implementation');
    } else {
      // Execute old logic
      print('Using legacy implementation');
    }
  }

  /// Example 9: Conditional API endpoint based on feature flag
  static String getApiEndpoint() {
    final service = locator<IFeatureFlagService>();
    
    if (service.isEnabled(FeatureFlag.exampleFeature)) {
      return '/api/v2/data'; // New API endpoint
    } else {
      return '/api/v1/data'; // Old API endpoint
    }
  }

  /// Example 10: Feature flag wrapper widget
  static Widget featureGateWidget({
    required BuildContext context,
    required FeatureFlag flag,
    required Widget child,
    Widget? fallback,
  }) {
    if (context.isFeatureEnabled(flag)) {
      return child;
    } else {
      return fallback ?? const SizedBox.shrink();
    }
  }
}

/// A reusable widget that wraps content with a feature flag check
class FeatureGate extends StatelessWidget {
  final FeatureFlag flag;
  final Widget child;
  final Widget? fallback;

  const FeatureGate({
    super.key,
    required this.flag,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isFeatureEnabled(flag)) {
      return child;
    }
    return fallback ?? const SizedBox.shrink();
  }
}

/// Example usage of FeatureGate widget
class FeatureGateUsageExample extends StatelessWidget {
  const FeatureGateUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feature Gate Example')),
      body: Column(
        children: [
          // This will only show if dashboard is enabled
          FeatureGate(
            flag: FeatureFlag.dashboard,
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () {},
              ),
            ),
            fallback: const Card(
              child: ListTile(
                leading: Icon(Icons.lock),
                title: Text('Dashboard (Coming Soon)'),
              ),
            ),
          ),
          
          // This will only show if OAuth providers are enabled
          FeatureGate(
            flag: FeatureFlag.oauthProviders,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.login),
              label: const Text('Sign in with Google'),
            ),
          ),
        ],
      ),
    );
  }
}
