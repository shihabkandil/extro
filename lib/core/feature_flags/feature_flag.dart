/// Enum representing all available feature flags in the application.
///
/// Each feature flag can be used to control the visibility or behavior
/// of specific features in the app.
enum FeatureFlag {
  /// Example: Controls whether the example feature is visible
  exampleFeature,

  /// Controls whether the dashboard feature is visible
  dashboard,

  /// Controls whether authentication features are visible
  authentication,

  /// Controls whether OAuth providers (Google, Apple) are available
  oauthProviders,
}
