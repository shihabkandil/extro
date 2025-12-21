import 'package:injectable/injectable.dart';

import '../../domain/feature_flag.dart';
import 'i_feature_flag_service.dart';

@Singleton(as: IFeatureFlagService)
class FeatureFlagService implements IFeatureFlagService {
  static const bool _defaultFlagValue = true;
  static const bool _disabled = false;

  final Map<String, bool> _flags = {FeatureFlag.oauthProviders.name: _disabled};

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
