// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/widgets.dart';

typedef CharPopInvokedCallback<T extends Object?> = void Function(bool systemPopBlocked, T? result);

class CharPopScope<T extends Object?> extends StatelessWidget {
  const CharPopScope({
    required this.child,
    super.key,
    this.interceptBack = false,
    this.onPopInvoked,
  });

  final Widget child;

  final bool interceptBack;

  final CharPopInvokedCallback<T>? onPopInvoked;

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () async {
        if (!_isGloballyCurrent(context)) {
          return false;
        }
        onPopInvoked?.call(interceptBack, null);
        return interceptBack;
      },
      child: child,
    );
  }

  static bool _isGloballyCurrent(BuildContext context) {
    Route<dynamic>? route = ModalRoute.of(context);
    while (route != null) {
      if (!route.isCurrent) {
        return false;
      }
      final navigator = route.navigator;
      if (navigator == null) {
        return true;
      }
      route = ModalRoute.of(navigator.context);
    }
    return true;
  }
}
