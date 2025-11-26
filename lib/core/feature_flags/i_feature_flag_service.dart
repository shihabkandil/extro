import 'package:extro/core/feature_flags/feature_flag.dart';

abstract interface class IFeatureFlagService {
  bool isEnabled(FeatureFlag flag);
  Map<String, bool> getAllFlags();
  void enable(FeatureFlag flag);
  void disable(FeatureFlag flag);
  void updateFlags(Map<String, bool> flags);
}
