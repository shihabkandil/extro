part of 'spending_chart_cubit.dart';

@freezed
sealed class SpendingChartState with _$SpendingChartState {
  const factory SpendingChartState.initial() = _Initial;
  const factory SpendingChartState.loading() = _Loading;
  const factory SpendingChartState.success(SpendingChart chart) = _Success;
  const factory SpendingChartState.failure(Failure failure) = _Failure;
}
