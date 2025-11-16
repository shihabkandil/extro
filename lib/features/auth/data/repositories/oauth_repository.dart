import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:extro/core/network/endpoints.dart';
import 'package:extro/core/network/i_network_client.dart';
import 'package:extro/features/auth/data/models/oauth_request.dart';
import 'package:extro/features/auth/data/models/user_response.dart';
import 'package:extro/features/auth/domain/entities/oauth_provider.dart';
import 'package:extro/features/auth/domain/entities/user.dart';
import 'package:extro/features/auth/domain/repositories/i_oauth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

@Singleton(as: IOAuthRepository)
class OAuthRepository implements IOAuthRepository {
  final INetworkClient _client;
  final GoogleSignIn _googleSignIn;

  OAuthRepository({
    required INetworkClient client,
    required GoogleSignIn googleSignIn,
  })  : _client = client,
        _googleSignIn = googleSignIn;

  @override
  Future<Either<Failure, String>> getProviderToken(
    OAuthProvider provider,
  ) async {
    try {
      switch (provider) {
        case OAuthProvider.google:
          return _getGoogleToken();
        case OAuthProvider.apple:
          return _getAppleToken();
      }
    } catch (e, stackTrace) {
      log(
        'Failed to get provider token: $e',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        Failure.authentication(message: 'Failed to sign in with provider'),
      );
    }
  }

  Future<Either<Failure, String>> _getGoogleToken() async {
    try {
      final account = await _googleSignIn.signIn();

      if (account == null) {
        return const Left(
          Failure.authentication(message: 'Sign in cancelled'),
        );
      }

      final auth = await account.authentication;
      final token = auth.idToken;

      if (token == null) {
        return const Left(
          Failure.authentication(message: 'Failed to get Google token'),
        );
      }

      return Right(token);
    } catch (e, stackTrace) {
      log(
        'Failed to sign in with Google: $e',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        Failure.authentication(message: 'Failed to sign in with Google'),
      );
    }
  }

  Future<Either<Failure, String>> _getAppleToken() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final token = credential.identityToken;

      if (token == null) {
        return const Left(
          Failure.authentication(message: 'Failed to get Apple token'),
        );
      }

      return Right(token);
    } catch (e, stackTrace) {
      log(
        'Failed to sign in with Apple: $e',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        Failure.authentication(message: 'Failed to sign in with Apple'),
      );
    }
  }

  @override
  Future<Either<Failure, User>> authenticateWithBackend(
    String token,
    OAuthProvider provider,
  ) async {
    final request = OAuthRequest(
      token: token,
      provider: provider.name,
    );

    final response = await _client.post(
      Endpoints.userOAuth,
      data: request.toJson(),
      requiresAuth: false,
    );

    return response.fold(
      (failure) => Left(failure),
      (res) {
        try {
          final data = UserResponse.fromJson(
            res.data as Map<String, dynamic>,
          );
          return Right(data.toDomain());
        } catch (e, stackTrace) {
          log(
            'Failed to parse UserResponse: $e',
            error: e,
            stackTrace: stackTrace,
          );
          return Left(Failure.dataProcessing());
        }
      },
    );
  }
}
