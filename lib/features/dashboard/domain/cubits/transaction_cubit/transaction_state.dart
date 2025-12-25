part of 'transaction_cubit.dart';

@freezed
sealed class TransactionState with _$TransactionState {
  const factory TransactionState.initial() = _Initial;
  const factory TransactionState.loading() = _Loading;
  const factory TransactionState.success(List<Transaction> transactions) =
      _Success;
  const factory TransactionState.failure(Failure failure) = _Failure;
}
