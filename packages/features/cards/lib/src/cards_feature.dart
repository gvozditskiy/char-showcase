import 'package:common_ui/common_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';

import 'di/cards_component.dart';
import 'route/cards_paths.dart';
import 'route/cards_routes.dart';

abstract final class CardsFeature {
  static const _routes = CardsRoutes();
  static const tag = 'cards';

  static RouteBase getFeatureGraph({List<RouteBase>? nestedGraphs}) {
    return CharShellRoute(
      screenBuilder: (context, state, child) => Scoped(
        key: const ValueKey(tag),
        onInit: CardsComponent.init,
        onDispose: CardsComponent.dispose,
        child: child,
      ),
      routes: [_routes.mainCardsRoute(nestedGraphs), _routes.cardDetailsRoute()],
    );
  }

  static Future<void> openFeature(AppNavigator navigator) async =>
      navigator.goNamed(CardsPath.cardsMain);

  static Future<void> openDetails(AppNavigator navigator, String characterId) =>
      navigator.pushForResult<void>(
        CardsPath.cardDetails,
        queryParams: {CardsPath.characterIdParam: characterId},
      );
}
