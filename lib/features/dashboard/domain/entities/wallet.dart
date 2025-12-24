import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet.freezed.dart';

@freezed
sealed class Wallet with _$Wallet {
  const factory Wallet({
    required int id,
    required String label,
    required double balance,
    required String currency,
    required String icon,
    required String accentColor,
  }) = _Wallet;
}
