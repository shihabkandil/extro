import 'package:extro/core/feature_flags/feature_flag.dart';

/// Interface for feature flag service.
///
/// This service provides access to feature flags that control the visibility
/// and behavior of features in the application.
///
/// The implementation can be:
/// - Local (in-memory or shared preferences)
/// - Remote (fetching from a backend service)
/// - Hybrid (local with remote updates)
abstract interface class IFeatureFlagService {
  /// Checks if a specific feature is enabled.
  ///
  /// Returns `true` if the feature is enabled, `false` otherwise.
  /// By default, all features are enabled unless explicitly disabled.
  bool isEnabled(FeatureFlag flag);

  /// Gets all feature flags with their current values.
  ///
  /// Returns a map where keys are feature flag names and values are their
  /// enabled/disabled status.
  Map<String, bool> getAllFlags();

  /// Enables a specific feature flag.
  ///
  /// This method can be used to dynamically enable features at runtime.
  void enable(FeatureFlag flag);

  /// Disables a specific feature flag.
  ///
  /// This method can be used to dynamically disable features at runtime.
  void disable(FeatureFlag flag);

  /// Updates multiple feature flags at once.
  ///
  /// This is useful when receiving feature flag updates from a remote service.
  /// The [flags] map should contain feature flag names as keys and their
  /// enabled/disabled status as values.
  void updateFlags(Map<String, bool> flags);
}
