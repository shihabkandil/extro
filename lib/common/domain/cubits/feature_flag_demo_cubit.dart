import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:extro/core/di/locator.dart';
import 'package:extro/core/providers/i_feature_flag_service.dart';

/// Example cubit demonstrating feature flag usage in state management
class FeatureFlagDemoCubit extends Cubit<FeatureFlagDemoState> {
  FeatureFlagDemoCubit({
    IFeatureFlagService? featureFlagService,
  })  : _featureFlagService = featureFlagService ?? locator<IFeatureFlagService>(),
        super(const FeatureFlagDemoState());

  final IFeatureFlagService _featureFlagService;

  void loadFeatures() {
    final allFlags = _featureFlagService.getAllFeatureFlags();
    emit(state.copyWith(featureFlags: allFlags));
  }

  void checkDashboardFeature() {
    final useNewDashboard = _featureFlagService.isFeatureEnabled('new_dashboard');
    emit(state.copyWith(useNewDashboard: useNewDashboard));
  }

  void checkAnalyticsFeature() {
    final useAdvancedAnalytics = _featureFlagService.getFeatureFlag(
      'advanced_analytics',
      defaultValue: false,
    );
    emit(state.copyWith(useAdvancedAnalytics: useAdvancedAnalytics));
  }
}

class FeatureFlagDemoState {
  const FeatureFlagDemoState({
    this.featureFlags = const {},
    this.useNewDashboard = false,
    this.useAdvancedAnalytics = false,
  });

  final Map<String, bool> featureFlags;
  final bool useNewDashboard;
  final bool useAdvancedAnalytics;

  FeatureFlagDemoState copyWith({
    Map<String, bool>? featureFlags,
    bool? useNewDashboard,
    bool? useAdvancedAnalytics,
  }) {
    return FeatureFlagDemoState(
      featureFlags: featureFlags ?? this.featureFlags,
      useNewDashboard: useNewDashboard ?? this.useNewDashboard,
      useAdvancedAnalytics: useAdvancedAnalytics ?? this.useAdvancedAnalytics,
    );
  }
}
