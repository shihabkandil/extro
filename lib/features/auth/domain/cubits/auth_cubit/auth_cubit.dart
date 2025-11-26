import 'package:extro/core/di/locator.dart';
import 'package:extro/features/auth/domain/entities/oauth_provider.dart';
import 'package:extro/features/auth/domain/repositories/i_oauth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/failures/failure.dart';
import '../../entities/user.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({IOAuthRepository? repository})
    : _repository = repository ?? locator<IOAuthRepository>(),
      super(const AuthState.initial());

  final IOAuthRepository _repository;

  Future<void> signInWithProvider(OAuthProvider provider) async {
    emit(const AuthState.loading());

    final tokenResult = await _repository.getProviderToken(provider);

    if (isClosed) return;

    await tokenResult.fold(
      (failure) async {
        emit(AuthState.failure(failure));
      },
      (token) async {
        final authResult = await _repository.authenticateWithBackend(
          token,
          provider,
        );

        if (isClosed) return;

        authResult.fold(
          (failure) => emit(AuthState.failure(failure)),
          (user) => emit(AuthState.authenticated(user)),
        );
      },
    );
  }

  void signOut() {
    emit(const AuthState.initial());
  }
}
