import 'package:core/core.dart';

import 'profile_module.dart';

abstract final class ProfileComponent {
  static const scope = 'profile';
  static final _di = ServiceLocator();

  static void init() {
    _di.retainScope(scopeName: scope, register: ProfileModule.new);
  }

  static void dispose() {
    _di.releaseScope(scopeName: scope);
  }
}
