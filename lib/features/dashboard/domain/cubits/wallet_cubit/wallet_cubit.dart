import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/di/locator.dart';
import '../../../../../core/failures/failure.dart';
import '../../entities/wallet.dart';
import '../../repositories/i_wallet_repository.dart';

part 'wallet_cubit.freezed.dart';
part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit({IWalletRepository? repository})
    : _repository = repository ?? locator<IWalletRepository>(),
      super(const WalletState.initial());

  final IWalletRepository _repository;

  Future<void> fetchWallets() async {
    emit(const WalletState.loading());
    final result = await _repository.getAllWallets();
    if (isClosed) return;
    result.fold(
      (failure) => emit(WalletState.failure(failure)),
      (wallets) => emit(WalletState.success(wallets)),
    );
  }
}
