abstract interface class SharedPreferencesProvider {
  Future<void> init();

  String? getString(String key);
  Future<bool> setString(String key, String value);

  bool? getBool(String key);
  Future<bool> setBool(String key, {required bool value});
}
