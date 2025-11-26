import 'package:extro/core/feature_flags/feature_flag.dart';
import 'package:extro/core/feature_flags/i_feature_flag_service.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: IFeatureFlagService)
class FeatureFlagService implements IFeatureFlagService {
  final Map<String, bool> _flags = {};
  static const bool _defaultFlagValue = true;

  @override
  bool isEnabled(FeatureFlag flag) {
    return _flags[flag.name] ?? _defaultFlagValue;
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
