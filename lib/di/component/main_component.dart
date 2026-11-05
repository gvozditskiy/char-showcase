import '../app_module.dart';
import '../feature_adapters_module.dart';
import '../main_module.dart';

abstract final class MainComponent {
  static void init() {
    AppModule();
    MainModule();
    FeatureAdaptersModule();
  }
}
