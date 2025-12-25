import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../failures/failure.dart';

abstract class IThemeRepository {
  Future<Either<Failure, ThemeMode?>> getSavedThemeMode();

  Future<Either<Failure, Unit>> saveThemeMode(ThemeMode mode);
}
