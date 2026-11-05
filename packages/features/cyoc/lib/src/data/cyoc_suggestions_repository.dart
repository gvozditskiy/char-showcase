import 'dart:convert';
import 'dart:math';

import 'package:core/core.dart';
import 'package:flutter/services.dart';

import '../models/suggestion_type.dart';

class CyocSuggestionsRepository {
  CyocSuggestionsRepository(this._bundle, this._random, this._localizedConfigSelector);

  static const _commonPath = 'packages/cyoc/assets/data/';

  final AssetBundle _bundle;
  final Random _random;
  final LocalizedConfigSelector _localizedConfigSelector;
  final Map<SuggestionType, List<String>> _cache = {};

  Future<String> getRandomSuggestion(SuggestionType type) async {
    final suggestions = _cache[type] ?? [];
    if (suggestions.isEmpty) {
      suggestions.addAll(await _getSuggestions(type));
      _cache[type] = suggestions;
    }
    if (suggestions.isEmpty) {
      return '';
    }
    return suggestions.removeAt(_random.nextInt(suggestions.length));
  }

  Future<List<String>> _getSuggestions(SuggestionType type) async {
    final path =
        '$_commonPath${switch (type) {
          SuggestionType.femaleName => 'cyoc_suggest_name_female_localized.json',
          SuggestionType.maleName => 'cyoc_suggest_name_male_localized.json',
        }}';
    final decoded = jsonDecode(await _bundle.loadString(path));
    return _localizedConfigSelector.selectList<String>(decoded)?.toList() ?? [];
  }
}
