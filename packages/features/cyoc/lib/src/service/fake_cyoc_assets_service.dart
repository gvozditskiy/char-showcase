import 'cyoc_assets_service.dart';

class FakeCyocAssetsService implements CyocAssetsService {
  const FakeCyocAssetsService();

  static const _assetsPath = 'packages/cyoc/assets/options/';

  @override
  String getAsset(String key) => '$_assetsPath$key';
}
