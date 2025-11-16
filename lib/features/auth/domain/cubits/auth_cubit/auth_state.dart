import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:extro/features/auth/domain/entities/user.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.failure(Failure failure) = _Failure;
}
