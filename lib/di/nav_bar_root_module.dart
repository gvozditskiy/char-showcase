import 'package:core/core.dart';
import 'package:navigation/navigation.dart';

import '../app/cubit/nab_bar_root/nav_bar_root_cubit.dart';

class NavBarRootModule {
  NavBarRootModule() {
    _setup();
  }

  final _di = ServiceLocator();

  void _setup() {
    _di.registerFactory<NavBarRootCubit>(
      (_) =>
          NavBarRootCubit(_di.get<AppNavigator>(), _di.get<AnalyticsService>(), _di.get<Logger>()),
    );
  }
}
