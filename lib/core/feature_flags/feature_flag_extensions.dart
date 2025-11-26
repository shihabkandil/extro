import 'package:extro/core/feature_flags/cubit/feature_flag_cubit.dart';
import 'package:extro/core/feature_flags/feature_flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Extension on BuildContext to easily check feature flags using the cubit.
///
/// This follows clean architecture by accessing feature flags through
/// the presentation layer's cubit instead of directly using the service locator.
extension FeatureFlagContext on BuildContext {
  /// Checks if a specific feature flag is enabled.
  ///
  /// Example usage:
  /// ```dart
  /// if (context.isFeatureEnabled(FeatureFlag.dashboard)) {
  ///   // Show dashboard
  /// }
  /// ```
  ///
  /// Requires [FeatureFlagCubit] to be present in the widget tree via BlocProvider.
  bool isFeatureEnabled(FeatureFlag flag) {
    return read<FeatureFlagCubit>().isEnabled(flag);
  }
}
