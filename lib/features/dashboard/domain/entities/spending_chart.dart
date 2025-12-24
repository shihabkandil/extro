import 'package:freezed_annotation/freezed_annotation.dart';

part 'spending_chart.freezed.dart';

@freezed
sealed class SpendingChart with _$SpendingChart {
  const factory SpendingChart({
    required List<double> spendingData,
    required String totalAmount,
    required String percentageChange,
  }) = _SpendingChart;
}
