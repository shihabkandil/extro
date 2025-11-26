import 'package:dartz/dartz.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:extro/features/auth/domain/entities/oauth_provider.dart';
import 'package:extro/features/auth/domain/entities/user.dart';

abstract interface class IOAuthRepository {
  Future<Either<Failure, String>> getProviderToken(OAuthProvider provider);
  Future<Either<Failure, User>> authenticateWithBackend(
    String token,
    OAuthProvider provider,
  );
}
