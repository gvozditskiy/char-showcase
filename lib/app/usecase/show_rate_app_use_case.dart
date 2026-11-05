import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/services.dart';
import 'package:navigation/navigation.dart';
import 'package:survey/survey.dart';

class ShowRateAppUseCase {
  ShowRateAppUseCase(this._navigator, this._parser, this._localizedConfigSelector, this._logger);

  final AppNavigator _navigator;
  final SurveyConfigParser<SurveyScreenModel> _parser;
  final LocalizedConfigSelector _localizedConfigSelector;
  final Logger _logger;

  Future<bool> call() async {
    try {
      final json = await _loadRateAppConfig();
      if (json == null) {
        _logger.w('[ShowRateAppUseCase] No localized config for rate app');
        return false;
      }
      final config = await _parseConfig(json);
      if (config == null) {
        return false;
      }
      return SurveyFeature.openSurvey(_navigator, config);
    } catch (e, stackTrace) {
      _logger.e('[ShowRateAppUseCase] Failed to show rate app', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  Future<Map<String, dynamic>?> _loadRateAppConfig() async {
    final jsonString = await rootBundle.loadString('assets/data/feedback_rate_app_localized.json');
    return _localizedConfigSelector.selectMap(jsonDecode(jsonString));
  }

  Future<SurveyFlowConfig<SurveyScreenModel>?> _parseConfig(Map<String, dynamic> json) async {
    final config = await _parser.parse(json);
    if (config == null) {
      _logger.w('[ShowRateAppUseCase] Config is null for rate app');
    }
    return config;
  }
}
