import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:extro/core/network/i_network_client.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: INetworkClient)
class NetworkClient implements INetworkClient {
  final Dio _dio;

  NetworkClient({required Dio dio}) : _dio = dio;

  @override
  Future<Either<Failure, Response>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e, stackTrace) {
      log('Unknown error in GET request', error: e, stackTrace: stackTrace);
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Response>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e, stackTrace) {
      log('Unknown error in POST request', error: e, stackTrace: stackTrace);
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Response>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e, stackTrace) {
      log('Unknown error in PUT request', error: e, stackTrace: stackTrace);
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Response>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e, stackTrace) {
      log('Unknown error in DELETE request', error: e, stackTrace: stackTrace);
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Response>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e, stackTrace) {
      log('Unknown error in PATCH request', error: e, stackTrace: stackTrace);
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const Failure.network(
          message: 'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          return const Failure.authentication(
            message: 'Authentication failed.',
          );
        } else if (statusCode == 404) {
          return const Failure.notFound(message: 'Resource not found.');
        } else if (statusCode != null && statusCode >= 500) {
          return const Failure.server(message: 'Server error occurred.');
        }
        return Failure.server(message: error.response?.statusMessage);
      case DioExceptionType.cancel:
        return const Failure.unknown(message: 'Request was cancelled.');
      case DioExceptionType.connectionError:
        return const Failure.network(message: 'No internet connection.');
      case DioExceptionType.badCertificate:
        return const Failure.network(message: 'Invalid SSL certificate.');
      case DioExceptionType.unknown:
        return Failure.unknown(message: error.message);
    }
  }
}
