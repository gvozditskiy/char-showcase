import 'package:profile/profile.dart';

import '../usecase/show_rate_app_use_case.dart';

class ProfileFeatureAdapterImpl implements ProfileFeatureAdapter {
  const ProfileFeatureAdapterImpl(this._showRateAppUseCase);

  final ShowRateAppUseCase _showRateAppUseCase;

  @override
  Future<void> showRateApp() async {
    await _showRateAppUseCase();
  }
}
