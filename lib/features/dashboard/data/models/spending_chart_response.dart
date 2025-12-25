import 'package:freezed_annotation/freezed_annotation.dart';

part 'spending_chart_response.freezed.dart';
part 'spending_chart_response.g.dart';

@freezed
sealed class SpendingChartResponse with _$SpendingChartResponse {
  const factory SpendingChartResponse({
    required List<double> spendingData,
    required String totalAmount,
    required String percentageChange,
  }) = _SpendingChartResponse;

  factory SpendingChartResponse.fromJson(Map<String, dynamic> json) =>
      _$SpendingChartResponseFromJson(json);
}
