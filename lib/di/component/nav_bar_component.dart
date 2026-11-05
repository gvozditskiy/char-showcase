import 'package:core/core.dart';

import '../nav_bar_root_module.dart';

abstract final class NavBarRootComponent {
  static const tag = 'nav_bar_root';
  static final _di = ServiceLocator();

  static void init() {
    _di.retainScope(scopeName: tag, register: NavBarRootModule.new);
  }

  static void dispose() {
    _di.releaseScope(scopeName: tag);
  }
}
