import 'package:injectable/injectable.dart';

import '../../domain/feature_flag.dart';
import 'i_feature_flag_service.dart';

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
}
