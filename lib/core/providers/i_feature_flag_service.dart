abstract interface class IFeatureFlagService {
  /// Check if a feature is enabled by its key
  bool isFeatureEnabled(String featureKey);

  /// Get all feature flags as a map of key-value pairs
  Map<String, bool> getAllFeatureFlags();

  /// Get feature flag value with a default fallback
  bool getFeatureFlag(String featureKey, {bool defaultValue = false});
}
