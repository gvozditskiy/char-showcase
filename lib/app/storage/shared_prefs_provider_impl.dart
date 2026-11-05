import 'package:core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProviderImpl implements SharedPreferencesProvider {
  late SharedPreferences _sharedPreferences;

  @override
  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  String? getString(String key) => _sharedPreferences.getString(key);

  @override
  Future<bool> setString(String key, String value) => _sharedPreferences.setString(key, value);

  @override
  bool? getBool(String key) => _sharedPreferences.getBool(key);

  @override
  Future<bool> setBool(String key, {required bool value}) => _sharedPreferences.setBool(key, value);
}
