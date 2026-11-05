import 'package:common_ui/common_ui.dart';
import 'package:go_router/go_router.dart';

import '../flows/creation/cyoc_creation_page.dart';
import 'cyoc_navigation_source.dart';
import 'cyoc_paths.dart';

class CyocRoutes {
  const CyocRoutes();

  GoRoute creationRoute() {
    return CharRoute(
      pathInfo: CyocPath.creationPath,
      screenBuilder: (_, state) => CyocCreationPage(
        source: CyocNavigationSource.safeValueOf(
          state.uri.queryParameters[CyocPath.cyocSourceParam],
        ),
      ),
    );
  }
}
