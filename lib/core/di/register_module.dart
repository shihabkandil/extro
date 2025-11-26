import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get client => Dio();

  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn(scopes: ['email', 'profile']);
}
