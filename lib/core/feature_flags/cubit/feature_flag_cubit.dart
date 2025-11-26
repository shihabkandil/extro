import 'package:extro/core/di/locator.dart';
import 'package:extro/core/feature_flags/cubit/feature_flag_state.dart';
import 'package:extro/core/feature_flags/feature_flag.dart';
import 'package:extro/core/feature_flags/i_feature_flag_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for managing feature flags in the presentation layer.
///
/// This cubit follows clean architecture by:
/// - Living in the core layer (shared across features)
/// - Injecting the feature flag service via constructor
/// - Managing state for the presentation layer
///
/// Usage:
/// ```dart
/// BlocProvider(
///   create: (context) => FeatureFlagCubit(),
///   child: MyApp(),
/// )
///
/// // In widgets
/// final isEnabled = context.read<FeatureFlagCubit>().isEnabled(FeatureFlag.dashboard);
/// ```
class FeatureFlagCubit extends Cubit<FeatureFlagState> {
  final IFeatureFlagService _service;

  FeatureFlagCubit({
    IFeatureFlagService? service,
  })  : _service = service ?? locator<IFeatureFlagService>(),
        super(FeatureFlagState(flags: {})) {
    _loadFlags();
  }

  void _loadFlags() {
    final flags = _service.getAllFlags();
    emit(FeatureFlagState(flags: flags));
  }

  /// Checks if a specific feature flag is enabled.
  bool isEnabled(FeatureFlag flag) {
    return _service.isEnabled(flag);
  }

  /// Enables a specific feature flag.
  void enable(FeatureFlag flag) {
    _service.enable(flag);
    _loadFlags();
  }

  /// Disables a specific feature flag.
  void disable(FeatureFlag flag) {
    _service.disable(flag);
    _loadFlags();
  }

  /// Updates multiple feature flags at once.
  void updateFlags(Map<String, bool> flags) {
    _service.updateFlags(flags);
    _loadFlags();
  }

  /// Gets all feature flags with their current values.
  Map<String, bool> getAllFlags() {
    return state.flags;
  }
}
