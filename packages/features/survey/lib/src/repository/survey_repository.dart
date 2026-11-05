class SurveyRepository {
  final Map<String, Object> _answers = {};

  void setAnswer({required String screenKey, required Object answer}) {
    _answers[screenKey] = answer;
  }

  Map<String, Object> get answers => Map.unmodifiable(_answers);

  Object? getAnswer({required String screenKey}) => _answers[screenKey];

  T? getAnswerAs<T>({required String screenKey}) {
    final answer = getAnswer(screenKey: screenKey);
    if (answer == null) {
      return null;
    }
    if (answer is T) {
      return answer as T;
    }
    if (T == int) {
      final parsed = switch (answer) {
        num() => answer.toInt(),
        String() => int.tryParse(answer),
        _ => null,
      };
      return parsed as T?;
    }
    return null;
  }
}
