import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_response.freezed.dart';
part 'transaction_response.g.dart';

@freezed
sealed class TransactionResponse with _$TransactionResponse {
  const factory TransactionResponse({
    required int id,
    required String title,
    required String dateTime,
    required double amount,
    required bool isIncome,
    required String icon,
    required int walletId,
  }) = _TransactionResponse;

  factory TransactionResponse.fromJson(Map<String, dynamic> json) => _$TransactionResponseFromJson(json);
}
