import 'path_info.dart';

abstract interface class AppNavigator {
  Stream<String> get currentPathObserver;

  String get currentPath;
  String get currentPathName;

  void init();
  void go(PathInfo info, {Object? extra});
  void goNamed(
    PathInfo info, {
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
  });

  void push(PathInfo info, {Object? extra});

  Future<T?> pushForResult<T>(
    PathInfo info, {
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
    Object? extra,
  });

  void goBack<T extends Object?>([T? result]);
}
