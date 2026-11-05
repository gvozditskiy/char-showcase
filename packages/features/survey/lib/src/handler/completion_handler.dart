// ignore_for_file: one_member_abstracts

abstract interface class CompletionHandler {
  Future<void> execute(String surveyId, Map<String, dynamic> answers);
}
