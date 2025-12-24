import 'package:dartz/dartz.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/repositories/i_transaction_repository.dart';
import '../data_sources/i_dashboard_local_data_source.dart';

@Singleton(as: ITransactionRepository)
class TransactionRepository implements ITransactionRepository {
  final IDashboardLocalDataSource localDataSource;

  TransactionRepository({required this.localDataSource});

  @override
  Future<Either<Failure, List<Transaction>>> getRecentTransactions() async {
    try {
      final responses = await localDataSource.getRecentTransactions();
      final transactions = responses
          .map(
            (e) => Transaction(
              id: e.id,
              title: e.title,
              dateTime: DateTime.parse(e.dateTime),
              amount: e.amount,
              isIncome: e.isIncome,
              icon: e.icon,
              walletId: e.walletId,
            ),
          )
          .toList();
      return Right(transactions);
    } catch (e) {
      return Left(Failure.dataProcessing());
    }
  }
}
