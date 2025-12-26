import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:extro/core/network/endpoints.dart';
import 'package:extro/core/network/i_network_client.dart';
import 'package:extro/features/auth/data/repositories/oauth_repository.dart';
import 'package:extro/features/auth/domain/entities/oauth_provider.dart';
import 'package:extro/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

class MockINetworkClient extends Mock implements INetworkClient {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

void main() {
  group('OAuthRepository', () {
    late MockINetworkClient mockNetworkClient;
    late MockGoogleSignIn mockGoogleSignIn;
    late OAuthRepository repository;

    const testToken = 'test_token_12345';
    const testUserId = 'user_123';
    const testUserEmail = 'test@example.com';
    const testUserName = 'Test User';

    final testUserJson = {
      'id': testUserId,
      'email': testUserEmail,
      'name': testUserName,
      'photoUrl': '',
    };

    setUp(() {
      mockNetworkClient = MockINetworkClient();
      mockGoogleSignIn = MockGoogleSignIn();
      repository = OAuthRepository(
        client: mockNetworkClient,
        googleSignIn: mockGoogleSignIn,
      );
    });

    group('getProviderToken', () {
      group('Google', () {
        test('returns token when Google sign in succeeds', () async {
          final account = MockGoogleSignInAccount();
          final auth = MockGoogleSignInAuthentication();

          when(
            () => mockGoogleSignIn.signIn(),
          ).thenAnswer((_) async => account);
          when(() => account.authentication).thenAnswer((_) async => auth);
          when(() => auth.idToken).thenReturn(testToken);

          final result = await repository.getProviderToken(
            OAuthProvider.google,
          );

          expect(result, equals(const Right(testToken)));
        });

        test(
          'returns authentication failure when sign in is cancelled',
          () async {
            when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

            final result = await repository.getProviderToken(
              OAuthProvider.google,
            );

            expect(result, equals(const Left(Failure.authentication())));
          },
        );

        test('returns authentication failure when token is null', () async {
          final account = MockGoogleSignInAccount();
          final auth = MockGoogleSignInAuthentication();

          when(
            () => mockGoogleSignIn.signIn(),
          ).thenAnswer((_) async => account);
          when(() => account.authentication).thenAnswer((_) async => auth);
          when(() => auth.idToken).thenReturn(null);

          final result = await repository.getProviderToken(
            OAuthProvider.google,
          );

          expect(result, equals(const Left(Failure.authentication())));
        });

        test(
          'returns authentication failure when sign in throws exception',
          () async {
            when(
              () => mockGoogleSignIn.signIn(),
            ).thenThrow(Exception('Sign in failed'));

            final result = await repository.getProviderToken(
              OAuthProvider.google,
            );

            expect(result, equals(const Left(Failure.authentication())));
          },
        );

        test(
          'returns authentication failure when authentication throws',
          () async {
            final account = MockGoogleSignInAccount();

            when(
              () => mockGoogleSignIn.signIn(),
            ).thenAnswer((_) async => account);
            when(
              () => account.authentication,
            ).thenThrow(Exception('Auth failed'));

            final result = await repository.getProviderToken(
              OAuthProvider.google,
            );

            expect(result, equals(const Left(Failure.authentication())));
          },
        );
      });

      group('Apple', () {
        test(
          'returns authentication failure for Apple (not implemented)',
          () async {
            final result = await repository.getProviderToken(
              OAuthProvider.apple,
            );

            expect(result, equals(const Left(Failure.authentication())));
          },
        );
      });
    });

    group('authenticateWithBackend', () {
      test('returns user when backend authentication succeeds', () async {
        when(
          () => mockNetworkClient.post(
            Endpoints.userOAuth,
            data: any(named: 'data'),
            requiresAuth: false,
          ),
        ).thenAnswer(
          (_) async => Right(
            Response(
              data: testUserJson,
              statusCode: 200,
              requestOptions: RequestOptions(),
            ),
          ),
        );

        final result = await repository.authenticateWithBackend(
          testToken,
          OAuthProvider.google,
        );

        expect(
          result,
          equals(
            const Right(
              User(id: testUserId, email: testUserEmail, name: testUserName),
            ),
          ),
        );
      });

      test('calls post with correct endpoint and data', () async {
        when(
          () => mockNetworkClient.post(
            any(),
            data: any(named: 'data'),
            requiresAuth: any(named: 'requiresAuth'),
          ),
        ).thenAnswer(
          (_) async => Right(
            Response(
              data: testUserJson,
              statusCode: 200,
              requestOptions: RequestOptions(),
            ),
          ),
        );

        await repository.authenticateWithBackend(
          testToken,
          OAuthProvider.google,
        );

        verify(
          () => mockNetworkClient.post(
            Endpoints.userOAuth,
            data: any(named: 'data'),
            requiresAuth: false,
          ),
        ).called(1);
      });

      test('returns failure when network client returns failure', () async {
        const failure = Failure.network();

        when(
          () => mockNetworkClient.post(
            any(),
            data: any(named: 'data'),
            requiresAuth: any(named: 'requiresAuth'),
          ),
        ).thenAnswer((_) async => const Left(failure));

        final result = await repository.authenticateWithBackend(
          testToken,
          OAuthProvider.google,
        );

        expect(result, equals(const Left(failure)));
      });

      test('returns data processing failure when JSON parsing fails', () async {
        when(
          () => mockNetworkClient.post(
            any(),
            data: any(named: 'data'),
            requiresAuth: any(named: 'requiresAuth'),
          ),
        ).thenAnswer(
          (_) async => Right(
            Response(
              data: {'invalid': 'data'},
              statusCode: 200,
              requestOptions: RequestOptions(),
            ),
          ),
        );

        final result = await repository.authenticateWithBackend(
          testToken,
          OAuthProvider.google,
        );

        expect(result, equals(const Left(Failure.dataProcessing())));
      });

      test(
        'returns data processing failure when response data is null',
        () async {
          when(
            () => mockNetworkClient.post(
              any(),
              data: any(named: 'data'),
              requiresAuth: any(named: 'requiresAuth'),
            ),
          ).thenAnswer(
            (_) async => Right(
              Response(statusCode: 200, requestOptions: RequestOptions()),
            ),
          );

          final result = await repository.authenticateWithBackend(
            testToken,
            OAuthProvider.google,
          );

          expect(result, equals(const Left(Failure.dataProcessing())));
        },
      );

      test('sends OAuthRequest with correct token and provider', () async {
        when(
          () => mockNetworkClient.post(
            any(),
            data: any(named: 'data'),
            requiresAuth: any(named: 'requiresAuth'),
          ),
        ).thenAnswer((_) async {
          return Right(
            Response(
              data: testUserJson,
              statusCode: 200,
              requestOptions: RequestOptions(),
            ),
          );
        });

        await repository.authenticateWithBackend(
          testToken,
          OAuthProvider.google,
        );

        final captured = verify(
          () => mockNetworkClient.post(
            any(),
            data: captureAny(named: 'data'),
            requiresAuth: any(named: 'requiresAuth'),
          ),
        ).captured;

        final Map<String, dynamic> sentData =
            captured[0] as Map<String, dynamic>;
        expect(sentData['token'], equals(testToken));
        expect(sentData['provider'], equals('google'));
      });

      test('works with Apple provider', () async {
        when(
          () => mockNetworkClient.post(
            any(),
            data: any(named: 'data'),
            requiresAuth: any(named: 'requiresAuth'),
          ),
        ).thenAnswer(
          (_) async => Right(
            Response(
              data: testUserJson,
              statusCode: 200,
              requestOptions: RequestOptions(),
            ),
          ),
        );

        final result = await repository.authenticateWithBackend(
          testToken,
          OAuthProvider.apple,
        );

        expect(result.isRight(), true);

        final captured = verify(
          () => mockNetworkClient.post(
            any(),
            data: captureAny(named: 'data'),
            requiresAuth: any(named: 'requiresAuth'),
          ),
        ).captured;

        final Map<String, dynamic> sentData =
            captured[0] as Map<String, dynamic>;
        expect(sentData['provider'], equals('apple'));
      });

      test('returns user with optional fields when provided', () async {
        final userJsonWithPhoto = {
          'id': testUserId,
          'email': testUserEmail,
          'name': testUserName,
          'photoUrl': 'https://example.com/photo.jpg',
        };

        when(
          () => mockNetworkClient.post(
            any(),
            data: any(named: 'data'),
            requiresAuth: any(named: 'requiresAuth'),
          ),
        ).thenAnswer(
          (_) async => Right(
            Response(
              data: userJsonWithPhoto,
              statusCode: 200,
              requestOptions: RequestOptions(),
            ),
          ),
        );

        final result = await repository.authenticateWithBackend(
          testToken,
          OAuthProvider.google,
        );

        expect(
          result,
          equals(
            const Right(
              User(
                id: testUserId,
                email: testUserEmail,
                name: testUserName,
                photoUrl: 'https://example.com/photo.jpg',
              ),
            ),
          ),
        );
      });
    });

    group('Integration Tests', () {
      test('full Google sign in flow succeeds', () async {
        // Mock Google sign in
        final account = MockGoogleSignInAccount();
        final auth = MockGoogleSignInAuthentication();

        when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => account);
        when(() => account.authentication).thenAnswer((_) async => auth);
        when(() => auth.idToken).thenReturn(testToken);

        // Mock backend authentication
        when(
          () => mockNetworkClient.post(
            any(),
            data: any(named: 'data'),
            requiresAuth: any(named: 'requiresAuth'),
          ),
        ).thenAnswer(
          (_) async => Right(
            Response(
              data: testUserJson,
              statusCode: 200,
              requestOptions: RequestOptions(),
            ),
          ),
        );

        // Get token
        final tokenResult = await repository.getProviderToken(
          OAuthProvider.google,
        );
        expect(tokenResult.isRight(), true);

        // Authenticate with backend
        final token = tokenResult.getOrElse(() => '');
        final userResult = await repository.authenticateWithBackend(
          token,
          OAuthProvider.google,
        );

        expect(userResult.isRight(), true);
        final user = userResult.getOrElse(() => const User(id: '', email: ''));
        expect(user.id, equals(testUserId));
        expect(user.email, equals(testUserEmail));
        expect(user.name, equals(testUserName));
      });

      test('Google sign in failure prevents backend authentication', () async {
        when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

        final tokenResult = await repository.getProviderToken(
          OAuthProvider.google,
        );

        expect(tokenResult.isLeft(), true);
        expect(tokenResult, equals(const Left(Failure.authentication())));

        // Backend should never be called
        verifyNever(
          () => mockNetworkClient.post(
            any(),
            data: any(named: 'data'),
            requiresAuth: any(named: 'requiresAuth'),
          ),
        );
      });
    });
  });
}
