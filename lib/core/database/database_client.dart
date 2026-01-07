import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:extro/core/database/i_database_client.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:injectable/injectable.dart';

import 'app_database.dart';

@Singleton(as: IDatabaseClient)
class DatabaseClient implements IDatabaseClient {
  final AppDatabase _database;

  DatabaseClient({required AppDatabase database}) : _database = database;

  AppDatabase get database => _database;

  @override
  Future<Either<Failure, List<T>>> getAll<T>(
    Future<List<T>> Function() query,
  ) async {
    try {
      final result = await query();
      return Right(result);
    } catch (e, stackTrace) {
      log('Database getAll error', error: e, stackTrace: stackTrace);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, T?>> getOne<T>(Future<T?> Function() query) async {
    try {
      final result = await query();
      return Right(result);
    } catch (e, stackTrace) {
      log('Database getOne error', error: e, stackTrace: stackTrace);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> insert<T>(Future<int> Function() query) async {
    try {
      final result = await query();
      return Right(result);
    } catch (e, stackTrace) {
      log('Database insert error', error: e, stackTrace: stackTrace);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> update(Future<bool> Function() query) async {
    try {
      final result = await query();
      return Right(result);
    } catch (e, stackTrace) {
      log('Database update error', error: e, stackTrace: stackTrace);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> delete(Future<int> Function() query) async {
    try {
      final result = await query();
      return Right(result);
    } catch (e, stackTrace) {
      log('Database delete error', error: e, stackTrace: stackTrace);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> batch(
    Future<void> Function() operations,
  ) async {
    try {
      await operations();
      return const Right(null);
    } catch (e, stackTrace) {
      log('Database batch error', error: e, stackTrace: stackTrace);
      return Left(Failure.cache(message: e.toString()));
    }
  }
}
