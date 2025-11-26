import 'package:freezed_annotation/freezed_annotation.dart';

part 'feature_flag_state.freezed.dart';

@freezed
sealed class FeatureFlagState with _$FeatureFlagState {
  const factory FeatureFlagState({
    required Map<String, bool> flags,
  }) = _FeatureFlagState;
}
