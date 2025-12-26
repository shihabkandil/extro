import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:extro/features/auth/domain/cubits/auth_cubit/auth_cubit.dart';
import 'package:extro/features/auth/domain/entities/oauth_provider.dart';
import 'package:extro/features/auth/domain/entities/user.dart';
import 'package:extro/features/auth/domain/repositories/i_oauth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIOAuthRepository extends Mock implements IOAuthRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(OAuthProvider.google);
  });
  group('AuthCubit', () {
    late MockIOAuthRepository mockRepository;

    const testUser = User(
      id: '123',
      email: 'test@example.com',
      name: 'Test User',
    );

    const testToken = 'test_token_12345';

    setUp(() {
      mockRepository = MockIOAuthRepository();
    });

    group('Initial State', () {
      test('initial state is AuthState.initial()', () {
        final cubit = AuthCubit(repository: mockRepository);
        expect(cubit.state, equals(const AuthState.initial()));
      });
    });

    group('signInWithProvider', () {
      blocTest<AuthCubit, AuthState>(
        'emits [loading, authenticated] when sign in succeeds with Google',
        build: () {
          when(
            () => mockRepository.getProviderToken(OAuthProvider.google),
          ).thenAnswer((_) async => const Right(testToken));

          when(
            () => mockRepository.authenticateWithBackend(
              testToken,
              OAuthProvider.google,
            ),
          ).thenAnswer((_) async => const Right(testUser));

          return AuthCubit(repository: mockRepository);
        },
        act: (cubit) => cubit.signInWithProvider(OAuthProvider.google),
        expect: () => [
          const AuthState.loading(),
          const AuthState.authenticated(testUser),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [loading, failure] when provider token fails',
        build: () {
          const failure = Failure.authentication();

          when(
            () => mockRepository.getProviderToken(OAuthProvider.google),
          ).thenAnswer((_) async => const Left(failure));

          return AuthCubit(repository: mockRepository);
        },
        act: (cubit) => cubit.signInWithProvider(OAuthProvider.google),
        expect: () => [
          const AuthState.loading(),
          const AuthState.failure(Failure.authentication()),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [loading, failure] when backend authentication fails',
        build: () {
          const failure = Failure.network();

          when(
            () => mockRepository.getProviderToken(OAuthProvider.apple),
          ).thenAnswer((_) async => const Right(testToken));

          when(
            () => mockRepository.authenticateWithBackend(
              testToken,
              OAuthProvider.apple,
            ),
          ).thenAnswer((_) async => const Left(failure));

          return AuthCubit(repository: mockRepository);
        },
        act: (cubit) => cubit.signInWithProvider(OAuthProvider.apple),
        expect: () => [
          const AuthState.loading(),
          const AuthState.failure(Failure.network()),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'calls getProviderToken with correct provider',
        build: () {
          when(
            () => mockRepository.getProviderToken(OAuthProvider.google),
          ).thenAnswer((_) async => const Right(testToken));

          when(
            () => mockRepository.authenticateWithBackend(
              testToken,
              OAuthProvider.google,
            ),
          ).thenAnswer((_) async => const Right(testUser));

          return AuthCubit(repository: mockRepository);
        },
        act: (cubit) => cubit.signInWithProvider(OAuthProvider.google),
        expect: () => [
          const AuthState.loading(),
          const AuthState.authenticated(testUser),
        ],
        verify: (cubit) {
          verify(
            () => mockRepository.getProviderToken(OAuthProvider.google),
          ).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'calls authenticateWithBackend with correct parameters',
        build: () {
          when(
            () => mockRepository.getProviderToken(OAuthProvider.apple),
          ).thenAnswer((_) async => const Right(testToken));

          when(
            () => mockRepository.authenticateWithBackend(
              testToken,
              OAuthProvider.apple,
            ),
          ).thenAnswer((_) async => const Right(testUser));

          return AuthCubit(repository: mockRepository);
        },
        act: (cubit) => cubit.signInWithProvider(OAuthProvider.apple),
        expect: () => [
          const AuthState.loading(),
          const AuthState.authenticated(testUser),
        ],
        verify: (cubit) {
          verify(
            () => mockRepository.authenticateWithBackend(
              testToken,
              OAuthProvider.apple,
            ),
          ).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'works with different providers',
        build: () {
          when(
            () => mockRepository.getProviderToken(any()),
          ).thenAnswer((_) async => const Right(testToken));

          when(
            () => mockRepository.authenticateWithBackend(any(), any()),
          ).thenAnswer((_) async => const Right(testUser));

          return AuthCubit(repository: mockRepository);
        },
        act: (cubit) async {
          await cubit.signInWithProvider(OAuthProvider.google);
          await cubit.signInWithProvider(OAuthProvider.apple);
        },
        expect: () => [
          const AuthState.loading(),
          const AuthState.authenticated(testUser),
          const AuthState.loading(),
          const AuthState.authenticated(testUser),
        ],
      );
    });

    group('signOut', () {
      blocTest<AuthCubit, AuthState>(
        'emits initial state when signing out from authenticated',
        build: () => AuthCubit(repository: mockRepository),
        seed: () => const AuthState.authenticated(testUser),
        act: (cubit) => cubit.signOut(),
        expect: () => [const AuthState.initial()],
      );

      blocTest<AuthCubit, AuthState>(
        'emits initial state when signing out from failure',
        build: () => AuthCubit(repository: mockRepository),
        seed: () => const AuthState.failure(Failure.network()),
        act: (cubit) => cubit.signOut(),
        expect: () => [const AuthState.initial()],
      );

      blocTest<AuthCubit, AuthState>(
        'can sign in again after signing out',
        build: () {
          when(
            () => mockRepository.getProviderToken(OAuthProvider.google),
          ).thenAnswer((_) async => const Right(testToken));

          when(
            () => mockRepository.authenticateWithBackend(
              testToken,
              OAuthProvider.google,
            ),
          ).thenAnswer((_) async => const Right(testUser));

          return AuthCubit(repository: mockRepository);
        },
        seed: () => const AuthState.authenticated(testUser),
        act: (cubit) async {
          cubit.signOut();
          await cubit.signInWithProvider(OAuthProvider.google);
        },
        expect: () => [
          const AuthState.initial(),
          const AuthState.loading(),
          const AuthState.authenticated(testUser),
        ],
      );
    });

    group('State Transitions', () {
      blocTest<AuthCubit, AuthState>(
        'transitions from initial to loading to authenticated',
        build: () {
          when(
            () => mockRepository.getProviderToken(OAuthProvider.google),
          ).thenAnswer((_) async {
            return const Right(testToken);
          });

          when(
            () => mockRepository.authenticateWithBackend(
              testToken,
              OAuthProvider.google,
            ),
          ).thenAnswer((_) async => const Right(testUser));

          return AuthCubit(repository: mockRepository);
        },
        act: (cubit) => cubit.signInWithProvider(OAuthProvider.google),
        expect: () => [
          const AuthState.loading(),
          const AuthState.authenticated(testUser),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'transitions from authenticated to initial on sign out',
        build: () => AuthCubit(repository: mockRepository),
        seed: () => const AuthState.authenticated(testUser),
        act: (cubit) => cubit.signOut(),
        expect: () => [const AuthState.initial()],
      );

      blocTest<AuthCubit, AuthState>(
        'transitions from loading to failure on provider error',
        build: () {
          const failure = Failure.authentication();

          when(
            () => mockRepository.getProviderToken(OAuthProvider.google),
          ).thenAnswer((_) async {
            await Future.value();
            return const Left(failure);
          });

          return AuthCubit(repository: mockRepository);
        },
        act: (cubit) => cubit.signInWithProvider(OAuthProvider.google),
        expect: () => [
          const AuthState.loading(),
          const AuthState.failure(Failure.authentication()),
        ],
      );
    });

    group('Different OAuth Providers', () {
      blocTest<AuthCubit, AuthState>(
        'works with Google provider',
        build: () {
          when(
            () => mockRepository.getProviderToken(OAuthProvider.google),
          ).thenAnswer((_) async => const Right(testToken));

          when(
            () => mockRepository.authenticateWithBackend(
              testToken,
              OAuthProvider.google,
            ),
          ).thenAnswer((_) async => const Right(testUser));

          return AuthCubit(repository: mockRepository);
        },
        act: (cubit) => cubit.signInWithProvider(OAuthProvider.google),
        expect: () => [
          const AuthState.loading(),
          const AuthState.authenticated(testUser),
        ],
        verify: (cubit) {
          verify(
            () => mockRepository.getProviderToken(OAuthProvider.google),
          ).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'works with Apple provider',
        build: () {
          when(
            () => mockRepository.getProviderToken(OAuthProvider.apple),
          ).thenAnswer((_) async => const Right(testToken));

          when(
            () => mockRepository.authenticateWithBackend(
              testToken,
              OAuthProvider.apple,
            ),
          ).thenAnswer((_) async => const Right(testUser));

          return AuthCubit(repository: mockRepository);
        },
        act: (cubit) => cubit.signInWithProvider(OAuthProvider.apple),
        expect: () => [
          const AuthState.loading(),
          const AuthState.authenticated(testUser),
        ],
        verify: (cubit) {
          verify(
            () => mockRepository.getProviderToken(OAuthProvider.apple),
          ).called(1);
        },
      );
    });
  });
}
