import 'package:extro/core/feature_flags/feature_flag.dart';
import 'package:extro/core/feature_flags/i_feature_flag_service.dart';
import 'package:injectable/injectable.dart';

/// Local implementation of the feature flag service.
///
/// This implementation stores feature flags in memory and provides methods
/// to enable, disable, and query feature flags.
///
/// By default, all features are enabled unless explicitly disabled.
///
/// Future enhancements:
/// - Persist flags to local storage (SharedPreferences)
/// - Fetch flags from a remote service
/// - Support flag variants/values (not just boolean)
/// - Add analytics for feature flag usage
@Singleton(as: IFeatureFlagService)
class FeatureFlagService implements IFeatureFlagService {
  final Map<String, bool> _flags = {};

  /// Default value for flags that haven't been explicitly set
  static const bool _defaultFlagValue = true;

  @override
  bool isEnabled(FeatureFlag flag) {
    final flagName = flag.name;
    return _flags[flagName] ?? _defaultFlagValue;
  }

  @override
  Map<String, bool> getAllFlags() {
    final allFlags = <String, bool>{};
    
    for (final flag in FeatureFlag.values) {
      allFlags[flag.name] = isEnabled(flag);
    }
    
    return allFlags;
  }

  @override
  void enable(FeatureFlag flag) {
    _flags[flag.name] = true;
  }

  @override
  void disable(FeatureFlag flag) {
    _flags[flag.name] = false;
  }

  @override
  void updateFlags(Map<String, bool> flags) {
    _flags.addAll(flags);
  }
}
