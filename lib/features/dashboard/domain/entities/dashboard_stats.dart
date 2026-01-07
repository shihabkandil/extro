import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats.freezed.dart';

@freezed
sealed class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    required double totalIncome,
    required double totalExpenses,
  }) = _DashboardStats;
}
