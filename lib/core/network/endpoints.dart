class Endpoints {
  Endpoints._();

  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = '/api/v1';

  static String get example => '$apiVersion/example';
  static String get userOAuth => '$apiVersion/user/oauth';
}
