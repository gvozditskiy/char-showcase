import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';

import '../models/transition_type.dart';

class CharRoute extends GoRoute {
  CharRoute({
    required PathInfo pathInfo,
    required GoRouterWidgetBuilder screenBuilder,
    TransitionType transitionType = const TransitionTypeFade(),
    TransitionType Function(BuildContext context, GoRouterState state)? transitionTypeBuilder,
    bool iosPage = false,
    super.routes,
    super.redirect,
    super.parentNavigatorKey,
  }) : super(
         path: pathInfo.path,
         name: pathInfo.name,
         pageBuilder: (context, state) {
           if (iosPage) {
             return CupertinoPage(key: state.pageKey, child: screenBuilder(context, state));
           }
           final currentTransitionType =
               transitionTypeBuilder?.call(context, state) ?? transitionType;
           return currentTransitionType is! TransitionTypeNone?
               ? CustomTransitionPage(
                   key: state.pageKey,
                   child: screenBuilder(context, state),
                   opaque: false,
                   transitionDuration: currentTransitionType.transitionDuration,
                   reverseTransitionDuration: currentTransitionType.reverseTransitionDuration,
                   transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                       _transitionsBuilder(currentTransitionType, animation, child),
                 )
               : NoTransitionPage(child: screenBuilder(context, state));
         },
       );
}

class CharShellRoute extends ShellRoute {
  CharShellRoute({
    required ShellRouteBuilder screenBuilder,
    required super.routes,
    GlobalKey<NavigatorState>? key,
    TransitionType transitionType = const TransitionTypeFade(),
    TransitionType Function(BuildContext context, GoRouterState state)? transitionTypeBuilder,
    bool opaque = true,
    super.parentNavigatorKey,
    super.restorationScopeId,
  }) : super(
         navigatorKey: key,
         pageBuilder: (context, state, child) {
           final currentTransitionType =
               transitionTypeBuilder?.call(context, state) ?? transitionType;
           return currentTransitionType is! TransitionTypeNone
               ? CustomTransitionPage(
                   key: state.pageKey,
                   child: screenBuilder(context, state, child),
                   opaque: opaque,
                   transitionDuration: currentTransitionType.transitionDuration,
                   reverseTransitionDuration: currentTransitionType.reverseTransitionDuration,
                   transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                       _transitionsBuilder(currentTransitionType, animation, child),
                 )
               : NoTransitionPage(child: screenBuilder(context, state, child));
         },
       );
}

Widget _transitionsBuilder(
  TransitionType transitionType,
  Animation<double> animation,
  Widget child,
) {
  final curve = transitionType.curve;
  if (transitionType is TransitionTypeFade) {
    return FadeTransition(
      opacity: curve != null
          ? Tween<double>(
              begin: 0,
              end: 1,
            ).animate(CurvedAnimation(parent: animation, curve: curve))
          : animation,
      child: child,
    );
  } else if (transitionType is TransitionTypeFadeScale) {
    final curvedAnimation = curve != null
        ? CurvedAnimation(parent: animation, curve: curve)
        : animation;
    return FadeTransition(
      opacity: Tween<double>(begin: transitionType.beginOpacity, end: 1).animate(curvedAnimation),
      child: ScaleTransition(
        alignment: transitionType.alignment,
        scale: Tween<double>(begin: transitionType.beginScale, end: 1).animate(curvedAnimation),
        child: child,
      ),
    );
  } else if (transitionType is TransitionTypeScale) {
    return ScaleTransition(
      scale: curve != null
          ? Tween<double>(
              begin: 0.5,
              end: 1,
            ).animate(CurvedAnimation(parent: animation, curve: curve))
          : animation,
      child: child,
    );
  } else if (transitionType is TransitionTypeSlide) {
    final Offset beginOffset;
    final Offset endOffset;
    switch (transitionType.direction) {
      case TransitionTypeSlideDirection.verticalUp:
        beginOffset = const Offset(0, 1);
        endOffset = Offset.zero;
      case TransitionTypeSlideDirection.horizontalFromRight:
        beginOffset = const Offset(1, 0);
        endOffset = Offset.zero;
    }
    return SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset,
        end: endOffset,
      ).animate(curve != null ? CurvedAnimation(parent: animation, curve: curve) : animation),
      child: child,
    );
  } else if (transitionType is TransitionTypeBlur) {
    return FadeTransition(
      opacity: animation,
      child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60), child: child),
    );
  } else {
    return child;
  }
}
