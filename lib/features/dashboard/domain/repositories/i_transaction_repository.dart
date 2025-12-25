import 'package:dartz/dartz.dart';
import '../entities/transaction.dart';
import 'package:extro/core/failures/failure.dart';

abstract class ITransactionRepository {
  Future<Either<Failure, List<Transaction>>> getRecentTransactions();
}
