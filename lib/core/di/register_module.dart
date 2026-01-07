import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';
import '../database/database_connection.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get client => Dio();

  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn(scopes: ['email', 'profile']);

  @preResolve
  Future<SharedPreferencesWithCache> get sharedPreferencesWithCache =>
      SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(
          allowList: <String>{'theme_mode'},
        ),
      );

  @preResolve
  Future<AppDatabase> get appDatabase => createDatabase();
}
