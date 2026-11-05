import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';

import 'router.dart';

class MainAppNavigator implements AppNavigator {
  MainAppNavigator(this._router, this._logger);

  final AppRouter _router;
  final Logger _logger;
  final _currentPathController = BufferedStreamController<String>();
  GoRouter? _boundRouter;
  VoidCallback? _routerDelegateListener;

  @override
  void init() {
    final router = _router.getRouter();
    if (!identical(_boundRouter, router)) {
      if (_boundRouter != null && _routerDelegateListener != null) {
        _boundRouter!.routerDelegate.removeListener(_routerDelegateListener!);
      }
      _boundRouter = router;
      _routerDelegateListener = () {
        final location = router.location;
        _currentPathController.add(location);
        if (kDebugMode) {
          _logger.i('[AppRouter] : Current path $location');
        }
      };
      router.routerDelegate.addListener(_routerDelegateListener!);
    }
  }

  @override
  Stream<String> get currentPathObserver => _currentPathController.stream;

  @override
  String get currentPath => _router.getRouter().location;

  @override
  String get currentPathName => _router.getRouter().state.name ?? '';

  @override
  void go(PathInfo info, {Object? extra}) {
    _router.getRouter().go(info.path, extra: extra);
  }

  @override
  void goNamed(
    PathInfo info, {
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
  }) {
    _logger.i('[AppRouter] : goNamed ${info.name}');
    _router.getRouter().goNamed(info.name, pathParameters: params, queryParameters: queryParams);
  }

  @override
  void push(PathInfo info, {Object? extra}) {
    _logger.i('[AppRouter] : push ${info.name}');
    _router.getRouter().push(info.path, extra: extra);
  }

  @override
  Future<T?> pushForResult<T>(
    PathInfo info, {
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
    Object? extra,
  }) async {
    _logger.i('[AppRouter] : pushForResult ${info.name}');
    final router = _router.getRouter();
    final value = await router.pushNamed<T>(
      info.name,
      pathParameters: params,
      queryParameters: queryParams,
      extra: extra,
    );
    return value;
  }

  @override
  void goBack<T extends Object?>([T? result]) {
    _logger.i('[AppRouter] : goBack from ${_router.getRouter().location}');
    _router.getRouter().pop(result);
  }
}

extension LocationExtension on GoRouter {
  String get location {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
