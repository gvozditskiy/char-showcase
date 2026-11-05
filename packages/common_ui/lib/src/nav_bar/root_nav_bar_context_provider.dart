import 'package:flutter/widgets.dart';

import '../toast.dart';

class RootNavBarContextProvider extends InheritedWidget {
  const RootNavBarContextProvider(this.context, {required super.child, super.key});

  final BuildContext context;

  static RootNavBarContextProvider? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<RootNavBarContextProvider>();

  @override
  bool updateShouldNotify(RootNavBarContextProvider oldWidget) {
    return false;
  }
}

extension RootToastX on BuildContext {
  void showRootToast(String text) {
    (RootNavBarContextProvider.maybeOf(this)?.context ?? this).showToast(text);
  }
}
