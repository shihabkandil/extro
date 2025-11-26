part of 'feature_flag_cubit.dart';

@freezed
sealed class FeatureFlagState with _$FeatureFlagState {
  const factory FeatureFlagState({required Map<String, bool> flags}) =
      _FeatureFlagState;
}
