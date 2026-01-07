part of 'dashboard_stats_cubit.dart';

@freezed
sealed class DashboardStatsState with _$DashboardStatsState {
  const factory DashboardStatsState.initial() = _Initial;
  const factory DashboardStatsState.loading() = _Loading;
  const factory DashboardStatsState.success(DashboardStats stats) = _Success;
  const factory DashboardStatsState.failure(Failure failure) = _Failure;
}
