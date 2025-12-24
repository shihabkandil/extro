import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_response.freezed.dart';
part 'wallet_response.g.dart';

@freezed
sealed class WalletResponse with _$WalletResponse {
  const factory WalletResponse({
    required int id,
    required String label,
    required double balance,
    required String currency,
    required String icon,
    required String accentColor,
  }) = _WalletResponse;

  factory WalletResponse.fromJson(Map<String, dynamic> json) => _$WalletResponseFromJson(json);
}
