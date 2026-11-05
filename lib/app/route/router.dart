import 'package:cards/cards.dart';
import 'package:common_ui/common_ui.dart';
import 'package:cyoc/cyoc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:profile/profile.dart';
import 'package:survey/survey.dart';

import '../../di/component/nav_bar_component.dart';
import '../model/nav_bar_data.dart';
import '../widget/floating_navigation_bar.dart';
import '../widget/root_with_nav_bar.dart';

class AppRouter {
  static const _branchItems = [NavBarItem.cards, NavBarItem.settings];

  late final GoRouter _router = _buildRouter();

  GoRouter getRouter() {
    return _router;
  }

  GoRouter _buildRouter() {
    final shellNavigatorCardsKey = GlobalKey<NavigatorState>(debugLabel: 'shellCards');
    final shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

    return GoRouter(
      debugLogDiagnostics: kDebugMode,
      navigatorKey: NavigatorKey.rootNavigatorKey,
      initialLocation: CardsPath.cardsMain.path,
      routes: [
        CharShellRoute(
          key: NavigatorKey.shellNavigatorKey,
          screenBuilder: _buildShell,
          routes: [
            CharShellRoute(
              key: NavigatorKey.navbarShellNavigatorKey,
              restorationScopeId: 'navBarShell',
              transitionType: const TransitionTypeFade(
                transitionDuration: Duration(milliseconds: 375),
              ),
              screenBuilder: (shellContext, state, child) => Scoped(
                onInit: NavBarRootComponent.init,
                onDispose: NavBarRootComponent.dispose,
                child: child,
              ),
              routes: [
                StatefulShellRoute.indexedStack(
                  pageBuilder: (context, state, navigationShell) => NoTransitionPage(
                    child: RootWithNavBar(
                      body: navigationShell,
                      navBarBuilder:
                          ({
                            required List<NavBarItem> navBarItems,
                            required void Function(NavBarItem) onSelected,
                          }) {
                            if (!_isBranchRoot(state, navigationShell)) {
                              return null;
                            }
                            final data = NavBarData(
                              items: navBarItems,
                              selectedItem: _branchItems[navigationShell.currentIndex],
                            );
                            void onItemTapped(NavBarItem value) {
                              onSelected(value);
                              final branchIndex = _branchItems.indexOf(value);
                              if (branchIndex != -1) {
                                navigationShell.goBranch(branchIndex, initialLocation: true);
                              }
                            }

                            return FloatingNavigationBar(data: data, onItemTapped: onItemTapped);
                          },
                    ),
                  ),
                  branches: [
                    StatefulShellBranch(
                      navigatorKey: shellNavigatorCardsKey,
                      routes: [CardsFeature.getFeatureGraph()],
                    ),
                    StatefulShellBranch(
                      navigatorKey: shellNavigatorProfileKey,
                      routes: [ProfileFeature.getFeatureGraph()],
                    ),
                  ],
                ),
              ],
            ),
            ...CyocFeature.getFeatureGraph(),
            SurveyFeature.getSurveyRoute(),
          ],
        ),
      ],
    );
  }

  bool _isBranchRoot(GoRouterState state, StatefulNavigationShell navigationShell) {
    final branch = navigationShell.route.branches[navigationShell.currentIndex];
    return state.fullPath == branch.defaultRoute?.path;
  }

  Widget _buildShell(BuildContext shellContext, GoRouterState state, Widget child) {
    return AppScaffold(body: child);
  }
}
