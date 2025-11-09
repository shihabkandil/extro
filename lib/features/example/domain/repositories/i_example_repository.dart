import 'package:dartz/dartz.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:extro/features/example/domain/entities/example_entity.dart';

abstract interface class IExampleRepository {
  Future<Either<Failure, List<ExampleEntity>>> getAll();
  Future<Either<Failure, ExampleEntity>> getById(int id);
}
