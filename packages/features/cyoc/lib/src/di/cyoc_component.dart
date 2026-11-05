import 'package:core/core.dart';

import 'cyoc_module.dart';

abstract final class CyocComponent {
  static const scope = 'cyoc';
  static final _di = ServiceLocator();

  static void init() {
    _di.retainScope(scopeName: scope, register: CyocModule.new);
  }

  static void dispose() {
    _di.releaseScope(scopeName: scope);
  }
}
