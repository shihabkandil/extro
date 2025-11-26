import 'package:freezed_annotation/freezed_annotation.dart';

part 'oauth_request.freezed.dart';

@freezed
sealed class OAuthRequest with _$OAuthRequest {
  const factory OAuthRequest({
    required String token,
    required String provider,
  }) = _OAuthRequest;

  const OAuthRequest._();

  Map<String, dynamic> toJson() => {
        'token': token,
        'provider': provider,
      };
}
