import '../../domain/feature_flag.dart';

abstract interface class IFeatureFlagService {
  bool isEnabled(FeatureFlag flag);
  Map<String, bool> getAllFlags();
}
