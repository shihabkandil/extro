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
      test(
        'emits [loading, authenticated] when sign in succeeds with Google',
        () async {
          when(
            () => mockRepository.getProviderToken(OAuthProvider.google),
          ).thenAnswer((_) async => const Right(testToken));

          when(
            () => mockRepository.authenticateWithBackend(
              testToken,
              OAuthProvider.google,
            ),
          ).thenAnswer((_) async => const Right(testUser));

          final cubit = AuthCubit(repository: mockRepository);
          final states = <AuthState>[];
          cubit.stream.listen(states.add);

          await cubit.signInWithProvider(OAuthProvider.google);
          await Future.delayed(const Duration(milliseconds: 100));

          expect(states.length, equals(2));
          expect(states[0], equals(const AuthState.loading()));
          expect(states[1], equals(const AuthState.authenticated(testUser)));
        },
      );

      test('emits [loading, failure] when provider token fails', () async {
        const failure = Failure.authentication();

        when(
          () => mockRepository.getProviderToken(OAuthProvider.google),
        ).thenAnswer((_) async => const Left(failure));

        final cubit = AuthCubit(repository: mockRepository);
        final states = <AuthState>[];
        cubit.stream.listen(states.add);

        await cubit.signInWithProvider(OAuthProvider.google);
        await Future.delayed(const Duration(milliseconds: 100));

        expect(states.length, equals(2));
        expect(states[0], equals(const AuthState.loading()));
        expect(states[1], equals(const AuthState.failure(failure)));
      });

      test(
        'emits [loading, failure] when backend authentication fails',
        () async {
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

          final cubit = AuthCubit(repository: mockRepository);
          final states = <AuthState>[];
          cubit.stream.listen(states.add);

          await cubit.signInWithProvider(OAuthProvider.apple);
          await Future.delayed(const Duration(milliseconds: 100));

          expect(states.length, equals(2));
          expect(states[0], equals(const AuthState.loading()));
          expect(states[1], equals(const AuthState.failure(failure)));
        },
      );

      test('calls getProviderToken with correct provider', () async {
        when(
          () => mockRepository.getProviderToken(OAuthProvider.google),
        ).thenAnswer((_) async => const Right(testToken));

        when(
          () => mockRepository.authenticateWithBackend(
            testToken,
            OAuthProvider.google,
          ),
        ).thenAnswer((_) async => const Right(testUser));

        final cubit = AuthCubit(repository: mockRepository);
        await cubit.signInWithProvider(OAuthProvider.google);

        verify(
          () => mockRepository.getProviderToken(OAuthProvider.google),
        ).called(1);
      });

      test('calls authenticateWithBackend with correct parameters', () async {
        when(
          () => mockRepository.getProviderToken(OAuthProvider.apple),
        ).thenAnswer((_) async => const Right(testToken));

        when(
          () => mockRepository.authenticateWithBackend(
            testToken,
            OAuthProvider.apple,
          ),
        ).thenAnswer((_) async => const Right(testUser));

        final cubit = AuthCubit(repository: mockRepository);
        await cubit.signInWithProvider(OAuthProvider.apple);

        verify(
          () => mockRepository.authenticateWithBackend(
            testToken,
            OAuthProvider.apple,
          ),
        ).called(1);
      });

      test('works with different providers', () async {
        when(
          () => mockRepository.getProviderToken(any()),
        ).thenAnswer((_) async => const Right(testToken));

        when(
          () => mockRepository.authenticateWithBackend(any(), any()),
        ).thenAnswer((_) async => const Right(testUser));

        final cubit = AuthCubit(repository: mockRepository);
        final states = <AuthState>[];
        cubit.stream.listen(states.add);

        await cubit.signInWithProvider(OAuthProvider.google);
        await cubit.signInWithProvider(OAuthProvider.apple);
        await Future.delayed(const Duration(milliseconds: 100));

        expect(states.length, equals(4));
        expect(states[0], equals(const AuthState.loading()));
        expect(states[1], equals(const AuthState.authenticated(testUser)));
        expect(states[2], equals(const AuthState.loading()));
        expect(states[3], equals(const AuthState.authenticated(testUser)));
      });
    });

    group('signOut', () {
      test('emits initial state when signing out from authenticated', () async {
        final cubit = AuthCubit(repository: mockRepository);
        final states = <AuthState>[];
        cubit.stream.listen(states.add);

        cubit.emit(const AuthState.authenticated(testUser));
        cubit.signOut();
        await Future.delayed(const Duration(milliseconds: 50));

        expect(states.last, equals(const AuthState.initial()));
      });

      test('emits initial state when signing out from failure', () async {
        final cubit = AuthCubit(repository: mockRepository);
        final states = <AuthState>[];
        cubit.stream.listen(states.add);

        cubit.emit(const AuthState.failure(Failure.network()));
        cubit.signOut();
        await Future.delayed(const Duration(milliseconds: 50));

        expect(states.last, equals(const AuthState.initial()));
      });

      test('can sign in again after signing out', () async {
        when(
          () => mockRepository.getProviderToken(OAuthProvider.google),
        ).thenAnswer((_) async => const Right(testToken));

        when(
          () => mockRepository.authenticateWithBackend(
            testToken,
            OAuthProvider.google,
          ),
        ).thenAnswer((_) async => const Right(testUser));

        final cubit = AuthCubit(repository: mockRepository);
        final states = <AuthState>[];
        cubit.stream.listen(states.add);

        cubit.emit(const AuthState.authenticated(testUser));
        cubit.signOut();
        await Future.delayed(const Duration(milliseconds: 50));

        expect(states.contains(const AuthState.initial()), true);

        await cubit.signInWithProvider(OAuthProvider.google);
        await Future.delayed(const Duration(milliseconds: 100));

        expect(cubit.state, equals(const AuthState.authenticated(testUser)));
      });
    });

    group('State Transitions', () {
      test('transitions from initial to loading to authenticated', () async {
        when(
          () => mockRepository.getProviderToken(OAuthProvider.google),
        ).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return const Right(testToken);
        });

        when(
          () => mockRepository.authenticateWithBackend(
            testToken,
            OAuthProvider.google,
          ),
        ).thenAnswer((_) async => const Right(testUser));

        final cubit = AuthCubit(repository: mockRepository);
        expect(cubit.state, equals(const AuthState.initial()));

        final future = cubit.signInWithProvider(OAuthProvider.google);

        // Give it a bit of time to emit loading state
        await Future.delayed(const Duration(milliseconds: 50));
        expect(cubit.state, equals(const AuthState.loading()));

        await future;
        expect(cubit.state, equals(const AuthState.authenticated(testUser)));
      });

      test('transitions from authenticated to initial on sign out', () {
        final cubit = AuthCubit(repository: mockRepository);
        cubit.emit(const AuthState.authenticated(testUser));
        expect(cubit.state, equals(const AuthState.authenticated(testUser)));

        cubit.signOut();
        expect(cubit.state, equals(const AuthState.initial()));
      });

      test('transitions from loading to failure on provider error', () async {
        const failure = Failure.authentication();

        when(
          () => mockRepository.getProviderToken(OAuthProvider.google),
        ).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return const Left(failure);
        });

        final cubit = AuthCubit(repository: mockRepository);
        final future = cubit.signInWithProvider(OAuthProvider.google);

        // Give it a bit of time to emit loading state
        await Future.delayed(const Duration(milliseconds: 50));
        expect(cubit.state, equals(const AuthState.loading()));

        await future;
        expect(cubit.state, equals(const AuthState.failure(failure)));
      });
    });

    group('Different OAuth Providers', () {
      test('works with Google provider', () async {
        when(
          () => mockRepository.getProviderToken(OAuthProvider.google),
        ).thenAnswer((_) async => const Right(testToken));

        when(
          () => mockRepository.authenticateWithBackend(
            testToken,
            OAuthProvider.google,
          ),
        ).thenAnswer((_) async => const Right(testUser));

        final cubit = AuthCubit(repository: mockRepository);
        await cubit.signInWithProvider(OAuthProvider.google);

        expect(cubit.state, equals(const AuthState.authenticated(testUser)));
        verify(
          () => mockRepository.getProviderToken(OAuthProvider.google),
        ).called(1);
      });

      test('works with Apple provider', () async {
        when(
          () => mockRepository.getProviderToken(OAuthProvider.apple),
        ).thenAnswer((_) async => const Right(testToken));

        when(
          () => mockRepository.authenticateWithBackend(
            testToken,
            OAuthProvider.apple,
          ),
        ).thenAnswer((_) async => const Right(testUser));

        final cubit = AuthCubit(repository: mockRepository);
        await cubit.signInWithProvider(OAuthProvider.apple);

        expect(cubit.state, equals(const AuthState.authenticated(testUser)));
        verify(
          () => mockRepository.getProviderToken(OAuthProvider.apple),
        ).called(1);
      });
    });
  });
}
