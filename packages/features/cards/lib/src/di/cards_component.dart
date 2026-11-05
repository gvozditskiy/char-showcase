import 'package:core/core.dart';

import 'cards_module.dart';

abstract final class CardsComponent {
  static const scope = 'cards';
  static final _di = ServiceLocator();

  static void init() {
    _di.retainScope(scopeName: scope, register: CardsModule.new);
  }

  static void dispose() {
    _di.releaseScope(scopeName: scope);
  }
}
