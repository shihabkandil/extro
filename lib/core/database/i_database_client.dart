import 'package:dartz/dartz.dart';
import 'package:extro/core/failures/failure.dart';

abstract interface class IDatabaseClient {
  Future<Either<Failure, List<T>>> getAll<T>(Future<List<T>> Function() query);

  Future<Either<Failure, T?>> getOne<T>(Future<T?> Function() query);

  Future<Either<Failure, int>> insert<T>(Future<int> Function() query);

  Future<Either<Failure, bool>> update(Future<bool> Function() query);

  Future<Either<Failure, int>> delete(Future<int> Function() query);

  Future<Either<Failure, void>> batch(Future<void> Function() operations);
}
