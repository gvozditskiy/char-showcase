import 'package:char/app/feature_adapter/profile_feature_adapter_impl.dart';
import 'package:char/app/usecase/show_rate_app_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockShowRateAppUseCase extends Mock implements ShowRateAppUseCase {}

void main() {
  group('ProfileFeatureAdapterImpl', () {
    test('showRateApp always shows rate app', () async {
      final showRateAppUseCase = _MockShowRateAppUseCase();
      when(showRateAppUseCase.call).thenAnswer((_) async => true);
      final adapter = ProfileFeatureAdapterImpl(showRateAppUseCase);

      await adapter.showRateApp();
      await adapter.showRateApp();

      verify(showRateAppUseCase.call).called(2);
    });
  });
}
