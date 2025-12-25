import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../di/locator.dart';
import '../../repositories/i_theme_repository.dart';

part 'theme_cubit.freezed.dart';
part 'theme_state.dart';

@Singleton()
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({IThemeRepository? repository})
    : _repository = repository ?? locator<IThemeRepository>(),
      super(const ThemeState.initial());

  final IThemeRepository _repository;

  Future<void> init(Brightness platformBrightness) async {
    emit(const ThemeState.loading());

    final result = await _repository.getSavedThemeMode();

    if (isClosed) return;

    result.fold(
      (failure) {
        final mode = platformBrightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light;
        emit(ThemeState.loaded(themeMode: mode));
      },
      (savedMode) {
        if (savedMode != null) {
          emit(ThemeState.loaded(themeMode: savedMode));
        } else {
          final mode = platformBrightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light;
          emit(ThemeState.loaded(themeMode: mode));
        }
      },
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(ThemeState.loaded(themeMode: mode));

    final result = await _repository.saveThemeMode(mode);

    if (isClosed) return;

    result.fold(
      (failure) {},
      (_) {},
    );
  }

  ThemeMode get currentThemeMode {
    return state.maybeWhen(
      loaded: (mode) => mode,
      orElse: () => ThemeMode.system,
    );
  }
}
