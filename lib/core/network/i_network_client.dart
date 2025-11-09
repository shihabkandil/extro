import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:extro/core/failures/failure.dart';

abstract interface class INetworkClient {
  Future<Either<Failure, Response<dynamic>>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  });

  Future<Either<Failure, Response<dynamic>>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  });

  Future<Either<Failure, Response<dynamic>>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  });

  Future<Either<Failure, Response<dynamic>>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  });

  Future<Either<Failure, Response<dynamic>>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  });
}
