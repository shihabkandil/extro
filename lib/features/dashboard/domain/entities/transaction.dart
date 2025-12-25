import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

@freezed
sealed class Transaction with _$Transaction {
  const factory Transaction({
    required int id,
    required String title,
    required DateTime dateTime,
    required double amount,
    required bool isIncome,
    required String icon,
    required int walletId,
  }) = _Transaction;
}
