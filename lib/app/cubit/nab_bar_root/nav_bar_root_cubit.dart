import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:common_ui/common_ui.dart';
import 'package:core/core.dart';
import 'package:cyoc/cyoc.dart';
import 'package:equatable/equatable.dart';
import 'package:navigation/navigation.dart';

import '../../analytics/events/nav_bar_tab_open_event.dart';
import '../../model/event/cyoc_button_tapped_event.dart';

part 'nav_bar_root_state.dart';

class NavBarRootCubit extends Cubit<NavBarRootState> {
  NavBarRootCubit(this._navigator, this._analyticsService, this._logger)
    : super(const NavBarRootData(NavBarItem.values)) {
    onNavBarItemSelected(state.navBarItems.first);
  }

  final AppNavigator _navigator;
  final AnalyticsService _analyticsService;
  final Logger _logger;

  void onNavBarItemSelected(NavBarItem item) {
    _logger.d('[NavBarRootCubit] : item selected: $item');
    switch (item) {
      case NavBarItem.cards:
        _analyticsService.trackEvent(const FeedOpenedEvent());
      case NavBarItem.cyoc:
        _analyticsService.trackEvent(const CyocButtonTappedEvent());
        unawaited(CyocFeature.openCreateCharacter(_navigator, CyocNavigationSource.navBar));
      case NavBarItem.settings:
        break;
    }
  }
}
