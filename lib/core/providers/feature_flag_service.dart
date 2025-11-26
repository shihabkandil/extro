import 'package:extro/core/providers/i_feature_flag_service.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: IFeatureFlagService)
class FeatureFlagService implements IFeatureFlagService {
  final Map<String, bool> _featureFlags = {};

  FeatureFlagService() {
    _initializeFeatureFlags();
  }

  void _initializeFeatureFlags() {
    // Initialize default feature flags
    // In the future, this can be loaded from a remote service
    _featureFlags['example_feature'] = true;
    _featureFlags['new_dashboard'] = false;
    _featureFlags['advanced_analytics'] = false;
  }

  @override
  bool isFeatureEnabled(String featureKey) {
    return _featureFlags[featureKey] ?? false;
  }

  @override
  Map<String, bool> getAllFeatureFlags() {
    return Map.unmodifiable(_featureFlags);
  }

  @override
  bool getFeatureFlag(String featureKey, {bool defaultValue = false}) {
    return _featureFlags[featureKey] ?? defaultValue;
  }

  /// Update a feature flag value
  /// This can be called when fetching from a remote service in the future
  @override
  void updateFeatureFlag(String featureKey, bool value) {
    _featureFlags[featureKey] = value;
  }

  /// Update multiple feature flags at once
  /// This can be called when fetching from a remote service in the future
  @override
  void updateFeatureFlags(Map<String, bool> flags) {
    _featureFlags.addAll(flags);
  }
}
