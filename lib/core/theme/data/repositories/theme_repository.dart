import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../common/data/i_local_cache_service.dart';
import '../../../../core/failures/failure.dart';
import '../../domain/repositories/i_theme_repository.dart';

const _kThemeKey = 'theme_mode';

@Singleton(as: IThemeRepository)
class ThemeRepository implements IThemeRepository {
  ThemeRepository({required ILocalCacheService cache}) : _cache = cache;

  final ILocalCacheService _cache;

  @override
  Future<Either<Failure, ThemeMode?>> getSavedThemeMode() async {
    try {
      final s = _cache.getString(_kThemeKey);
      if (s == null) return const Right(null);
      switch (s) {
        case 'light':
          return const Right(ThemeMode.light);
        case 'dark':
          return const Right(ThemeMode.dark);
        case 'system':
          return const Right(ThemeMode.system);
        default:
          log('Unexpected theme value in cache: $s, defaulting to system');
          return const Right(ThemeMode.system);
      }
    } catch (e, stackTrace) {
      log(
        'Failed to get saved theme mode: $e',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveThemeMode(ThemeMode mode) async {
    try {
      await _cache.setString(_kThemeKey, mode.name);
      return const Right(unit);
    } catch (e, stackTrace) {
      log('Failed to save theme mode: $e', error: e, stackTrace: stackTrace);
      return Left(Failure.cache(message: e.toString()));
    }
  }
}
