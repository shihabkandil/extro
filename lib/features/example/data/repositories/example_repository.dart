import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:extro/core/network/endpoints.dart';
import 'package:extro/core/network/i_network_client.dart';
import 'package:extro/features/example/data/models/example_response.dart';
import 'package:extro/features/example/domain/entities/example_entity.dart';
import 'package:extro/features/example/domain/repositories/i_example_repository.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: IExampleRepository)
class ExampleRepository implements IExampleRepository {
  final INetworkClient _client;

  ExampleRepository({required INetworkClient client}) : _client = client;

  @override
  Future<Either<Failure, List<ExampleEntity>>> getAll() async {
    final response = await _client.get(
      Endpoints.example,
      requiresAuth: false,
    );

    return response.fold(
      (failure) => Left(failure),
      (res) {
        try {
          final data = (res.data as List)
              .map((e) => ExampleResponse.fromJson(e as Map<String, dynamic>))
              .toList();
          return Right(data.map((e) => e.toDomain()).toList());
        } catch (e, stackTrace) {
          log(
            'Failed to parse ExampleResponse list: $e',
            error: e,
            stackTrace: stackTrace,
          );
          return Left(Failure.dataProcessing());
        }
      },
    );
  }

  @override
  Future<Either<Failure, ExampleEntity>> getById(int id) async {
    final response = await _client.get(
      '${Endpoints.example}/$id',
      requiresAuth: false,
    );

    return response.fold(
      (failure) => Left(failure),
      (res) {
        try {
          final data = ExampleResponse.fromJson(
            res.data as Map<String, dynamic>,
          );
          return Right(data.toDomain());
        } catch (e, stackTrace) {
          log(
            'Failed to parse ExampleResponse: $e',
            error: e,
            stackTrace: stackTrace,
          );
          return Left(Failure.dataProcessing());
        }
      },
    );
  }
}
