import 'package:dartz/dartz.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/repositories/i_transaction_repository.dart';
import '../data_sources/i_dashboard_local_data_source.dart';
import '../mappers/table_data_mappers.dart';

@Singleton(as: ITransactionRepository)
class TransactionRepository implements ITransactionRepository {
  final IDashboardLocalDataSource localDataSource;

  TransactionRepository({required this.localDataSource});

  @override
  Future<Either<Failure, List<Transaction>>> getRecentTransactions() async {
    try {
      final tableData = await localDataSource.getRecentTransactions();
      final transactions = tableData.map((e) => e.toDomain()).toList();
      return Right(transactions);
    } catch (e) {
      return const Left(Failure.cache());
    }
  }
}
