import 'dart:developer';

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

  ThemeMode _getThemeModeFromBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> init(Brightness platformBrightness) async {
    emit(const ThemeState.loading());

    final result = await _repository.getSavedThemeMode();

    if (isClosed) return;

    result.fold(
      (failure) {
        final mode = _getThemeModeFromBrightness(platformBrightness);
        emit(ThemeState.loaded(themeMode: mode));
      },
      (savedMode) {
        if (savedMode != null) {
          emit(ThemeState.loaded(themeMode: savedMode));
        } else {
          final mode = _getThemeModeFromBrightness(platformBrightness);
          emit(ThemeState.loaded(themeMode: mode));
        }
      },
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final previousMode = currentThemeMode;
    emit(ThemeState.loaded(themeMode: mode));

    final result = await _repository.saveThemeMode(mode);

    if (isClosed) return;

    result.fold(
      (failure) {
        log('Failed to persist theme mode: ${failure.message}');
        emit(ThemeState.loaded(themeMode: previousMode));
      },
      (_) {
        // Successfully persisted
      },
    );
  }

  ThemeMode get currentThemeMode {
    return state.maybeWhen(
      loaded: (mode) => mode,
      orElse: () => ThemeMode.system,
    );
  }
}
