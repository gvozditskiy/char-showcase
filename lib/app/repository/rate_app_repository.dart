import 'package:core/core.dart';

import '../model/rate_app_keys.dart';
import '../model/rate_app_source.dart';

class RateAppRepository {
  RateAppRepository(this._preferences);

  final SharedPreferencesProvider _preferences;
  final Set<RateAppPopUpSource> _showing = {};

  bool tryStartShow(RateAppPopUpSource source) {
    final key = _keyForSource(source);
    if (key == null || _getFlag(RateAppKeys.ratingWasSet) || _getFlag(key)) {
      return false;
    }
    return _showing.add(source);
  }

  Future<void> finishShow(RateAppPopUpSource source, {required bool shown}) async {
    final key = _keyForSource(source);
    try {
      if (shown && key != null) {
        await _setFlag(key);
      }
    } finally {
      _showing.remove(source);
    }
  }

  Future<void> setRatingWasSet() => _setFlag(RateAppKeys.ratingWasSet);

  Future<void> setNativeRateOrStoreShown() => _setFlag(RateAppKeys.nativeRateOrStoreShown);

  Future<bool> isNativeRateOrStoreShown() async => _getFlag(RateAppKeys.nativeRateOrStoreShown);

  String? _keyForSource(RateAppPopUpSource source) => switch (source) {
    RateAppPopUpSource.firstCharacterLike => RateAppKeys.firstCharacterLike,
    RateAppPopUpSource.profile => null,
  };

  bool _getFlag(String key) => _preferences.getBool(key) ?? false;

  Future<void> _setFlag(String key) => _preferences.setBool(key, value: true);
}
