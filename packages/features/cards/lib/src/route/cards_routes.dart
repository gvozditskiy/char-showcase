import 'package:common_ui/common_ui.dart';
import 'package:go_router/go_router.dart';

import '../pages/card_details/card_details_page.dart';
import '../pages/feed/cards_feed_page.dart';
import 'cards_paths.dart';

class CardsRoutes {
  const CardsRoutes();

  static const _cardDetailsTransition = TransitionTypeFadeScale(
    beginScale: .94,
    curve: AppCurves.fastInSlowOut,
  );

  RouteBase mainCardsRoute([List<RouteBase>? nestedGraphs]) => CharRoute(
    pathInfo: CardsPath.cardsMain,
    screenBuilder: (context, state) => const CardsFeedPage(),
    routes: [...nestedGraphs ?? []],
  );

  RouteBase cardDetailsRoute() => CharRoute(
    pathInfo: CardsPath.cardDetails,
    transitionType: _cardDetailsTransition,
    screenBuilder: (context, state) =>
        CardDetailsPage(characterId: state.uri.queryParameters[CardsPath.characterIdParam] ?? ''),
  );
}
