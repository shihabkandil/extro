part of 'theme_cubit.dart';

@freezed
sealed class ThemeState with _$ThemeState {
  const factory ThemeState.initial() = _Initial;
  const factory ThemeState.loading() = _Loading;
  const factory ThemeState.loaded({required ThemeMode themeMode}) = _Loaded;
}
