import 'package:common_ui/common_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';

import 'di/cyoc_component.dart';
import 'route/cyoc_navigation_source.dart';
import 'route/cyoc_paths.dart';
import 'route/cyoc_routes.dart';

abstract final class CyocFeature {
  static const _routes = CyocRoutes();

  static List<RouteBase> getFeatureGraph() {
    return [
      CharShellRoute(
        screenBuilder: (context, state, child) {
          return Scoped(onInit: CyocComponent.init, onDispose: CyocComponent.dispose, child: child);
        },
        routes: [_routes.creationRoute()],
      ),
    ];
  }

  static Future<void> openCreateCharacter(
    AppNavigator navigator,
    CyocNavigationSource source,
  ) async {
    await navigator.pushForResult<dynamic>(
      CyocPath.creationPath,
      queryParams: {CyocPath.cyocSourceParam: source.analyticsName},
    );
  }
}
