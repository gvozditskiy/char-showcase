import 'package:flutter_test/flutter_test.dart';
import 'package:survey/survey.dart';

void main() {
  late SurveyRepository repository;

  setUp(() {
    repository = SurveyRepository();
  });

  group('getAnswerAs<int>', () {
    test('returns null when answer is missing', () {
      expect(repository.getAnswerAs<int>(screenKey: 'rating'), isNull);
    });

    test('returns int as is', () {
      repository.setAnswer(screenKey: 'rating', answer: 5);

      expect(repository.getAnswerAs<int>(screenKey: 'rating'), 5);
    });

    test('converts num to int', () {
      repository.setAnswer(screenKey: 'rating', answer: 4.8);

      expect(repository.getAnswerAs<int>(screenKey: 'rating'), 4);
    });

    test('parses numeric string', () {
      repository.setAnswer(screenKey: 'rating', answer: '3');

      expect(repository.getAnswerAs<int>(screenKey: 'rating'), 3);
    });

    test('returns null for invalid string', () {
      repository.setAnswer(screenKey: 'rating', answer: 'abc');

      expect(repository.getAnswerAs<int>(screenKey: 'rating'), isNull);
    });

    test('returns null for unsupported target type', () {
      repository.setAnswer(screenKey: 'rating', answer: 9);

      expect(repository.getAnswerAs<bool>(screenKey: 'rating'), isNull);
      expect(repository.getAnswerAs<double>(screenKey: 'rating'), isNull);
    });
  });
}
