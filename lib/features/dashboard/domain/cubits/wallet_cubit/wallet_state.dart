part of 'wallet_cubit.dart';

@freezed
sealed class WalletState with _$WalletState {
  const factory WalletState.initial() = _Initial;
  const factory WalletState.loading() = _Loading;
  const factory WalletState.success(List<Wallet> wallets) = _Success;
  const factory WalletState.failure(Failure failure) = _Failure;
}
