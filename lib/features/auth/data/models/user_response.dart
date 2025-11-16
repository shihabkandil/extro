import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:extro/features/auth/domain/entities/user.dart';

part 'user_response.freezed.dart';
part 'user_response.g.dart';

@freezed
sealed class UserResponse with _$UserResponse {
  const factory UserResponse({
    required String id,
    required String email,
    @Default('') String name,
    @Default('') String photoUrl,
  }) = _UserResponse;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
}

extension UserResponseMapper on UserResponse {
  User toDomain() {
    return User(
      id: id,
      email: email,
      name: name.isEmpty ? null : name,
      photoUrl: photoUrl.isEmpty ? null : photoUrl,
    );
  }
}
