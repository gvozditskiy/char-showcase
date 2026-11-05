import 'dart:io';

abstract final class SurveyTextTemplate {
  static String processStoreName(String text) {
    final storeName = Platform.isIOS ? 'App Store' : 'Play Store';
    return text.replaceAll('{{storeName}}', storeName);
  }
}
