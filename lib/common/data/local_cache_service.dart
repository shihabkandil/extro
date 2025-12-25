import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'i_local_cache_service.dart';

@Singleton(as: ILocalCacheService)
class LocalCacheService implements ILocalCacheService {
  const LocalCacheService(this._prefs);

  final SharedPreferencesWithCache _prefs;

  @override
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  String? getString(String key) {
    return _prefs.getString(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  @override
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }
}
