import 'package:common_ui/common_ui.dart';
import 'package:go_router/go_router.dart';

import 'di/profile_component.dart';
import 'route/profile_routes.dart';

abstract final class ProfileFeature {
  static const _routes = ProfileRoutes();

  static RouteBase getFeatureGraph() {
    return CharShellRoute(
      screenBuilder: (context, state, child) =>
          Scoped(onInit: ProfileComponent.init, onDispose: ProfileComponent.dispose, child: child),
      routes: [_routes.generalAppearance()],
    );
  }
}
