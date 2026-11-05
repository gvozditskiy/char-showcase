import 'package:flutter/widgets.dart';

abstract final class NavigatorKey {
  static final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  static final shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');
  static final navbarShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'navBarShell');
}
