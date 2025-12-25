import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/di/locator.dart';
import '../../../../../core/failures/failure.dart';
import '../../entities/transaction.dart';
import '../../repositories/i_transaction_repository.dart';

part 'transaction_cubit.freezed.dart';
part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit({ITransactionRepository? repository})
    : _repository = repository ?? locator<ITransactionRepository>(),
      super(const TransactionState.initial());

  final ITransactionRepository _repository;

  Future<void> fetchRecentTransactions() async {
    emit(const TransactionState.loading());
    final result = await _repository.getRecentTransactions();
    if (isClosed) return;
    result.fold(
      (failure) => emit(TransactionState.failure(failure)),
      (transactions) => emit(TransactionState.success(transactions)),
    );
  }
}
