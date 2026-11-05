import 'package:common_ui/common_ui.dart';
import 'package:go_router/go_router.dart';

import '../pages/general_appearance_page.dart';
import 'profile_paths.dart';

class ProfileRoutes {
  const ProfileRoutes();

  RouteBase generalAppearance() => CharRoute(
    pathInfo: ProfilePath.generalAppearance,
    screenBuilder: (context, state) => const GeneralAppearancePage(),
  );
}
