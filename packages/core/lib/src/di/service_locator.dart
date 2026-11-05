class ServiceLocator {
  factory ServiceLocator() => _instance;

  ServiceLocator._internal();

  final List<_Scope> _scopes = [_Scope('default')];
  void Function(String scopeName, {required bool pushed})? onScopeChanged;

  static final ServiceLocator _instance = ServiceLocator._internal();

  void pushNewScope({required String scopeName}) {
    if (containsScope(scopeName: scopeName)) {
      throw Exception('Scope $scopeName already has been added');
    }
    _scopes.add(_Scope(scopeName));
    _onScopeChanged(scopeName, pushed: true);
  }

  bool containsScope({required String scopeName}) =>
      _scopes.any((element) => element.name == scopeName);

  bool destroyScope([String? scopeName]) {
    var removed = false;
    if (scopeName == null) {
      if (_scopes.length > 1) {
        _scopes.last.dispose();
        final name = _scopes.last.name;
        _scopes.removeLast();
        _onScopeChanged(name, pushed: false);
        removed = true;
      }
    } else {
      _scopes.removeWhere((scope) {
        if (scope.name == scopeName && scope.name != 'default') {
          scope.dispose();
          removed = true;
          return true;
        }
        return false;
      });
      if (removed) {
        _onScopeChanged(scopeName, pushed: false);
      }
    }
    return removed;
  }

  void retainScope({required String scopeName, required void Function() register}) {
    final scope = _findScope(scopeName);
    if (scope != null) {
      scope.retainCount += 1;
      return;
    }
    pushNewScope(scopeName: scopeName);
    _scopes.last.retainCount = 1;
    register();
  }

  bool releaseScope({required String scopeName}) {
    final scope = _findScope(scopeName);
    if (scope == null) {
      return false;
    }
    if (scope.retainCount > 1) {
      scope.retainCount -= 1;
      return false;
    }
    return destroyScope(scopeName);
  }

  void registerFactory<T>(
    ServiceFactory<T> factory, {
    ServiceDispose<T>? dispose,
    String? instanceName,
  }) {
    _scopes.last._registerFactory<T>(factory, dispose, instanceName);
  }

  void registerLazySingleton<T>(
    ServiceFactory<T> factory, {
    ServiceDispose<T>? dispose,
    String? instanceName,
  }) {
    _scopes.last._registerLazySingleton<T>(factory, dispose, instanceName);
  }

  T get<T>({String? instanceName, Map<String, dynamic>? params}) {
    if (instanceName != null) {
      for (var i = _scopes.length - 1; i >= 0; i--) {
        final scope = _scopes[i];
        final instance = scope._resolveByName<T>(instanceName, params);
        if (instance != null) {
          return instance;
        }
      }
      throw Exception('No dependency registered for type $T with name $instanceName');
    } else {
      for (var i = _scopes.length - 1; i >= 0; i--) {
        final scope = _scopes[i];
        final instance = scope._resolve<T>(params);
        if (instance != null) {
          return instance;
        }
      }
      throw Exception('No dependency registered for type $T');
    }
  }

  void reset() {
    for (final scope in _scopes) {
      scope.dispose();
    }
    _scopes.removeRange(1, _scopes.length);
    _scopes[0] = _Scope('default');
    _onScopeChanged('all scopes', pushed: false);
  }

  void _onScopeChanged(String scopeName, {required bool pushed}) {
    onScopeChanged?.call(scopeName, pushed: pushed);
  }

  _Scope? _findScope(String scopeName) =>
      _scopes.where((scope) => scope.name == scopeName).firstOrNull;

  String get currentScopeName => _scopes.last.name;
}

class _Scope {
  _Scope(this.name);

  final String name;
  int retainCount = 0;
  final Map<String, ServiceFactory<dynamic>> _factories = {};
  final Map<String, dynamic> _singletons = {};
  final Map<String, ServiceDispose<dynamic>> _disposeFunctions = {};

  void _registerFactory<T>(
    ServiceFactory<T> factory,
    ServiceDispose<T>? dispose,
    String? instanceName,
  ) {
    final key = _createKey(T, instanceName);
    if (_factories.containsKey(key) || _singletons.containsKey(key)) {
      throw Exception('A dependency with type $T and name $instanceName already exists');
    }
    _factories[key] = factory;
    if (dispose != null) {
      _disposeFunctions[key] = dispose;
    }
  }

  void _registerLazySingleton<T>(
    ServiceFactory<T> factory,
    ServiceDispose<T>? dispose,
    String? instanceName,
  ) {
    final key = _createKey(T, instanceName);
    if (_factories.containsKey(key) || _singletons.containsKey(key)) {
      throw Exception('A dependency with type $T and name $instanceName already exists');
    }
    _factories[key] = (params) {
      final instance = factory(params);
      _singletons[key] = instance;
      _factories.remove(key);
      return instance;
    };
    if (dispose != null) {
      _disposeFunctions[key] = dispose;
    }
  }

  T? _resolve<T>(Map<String, dynamic>? params) {
    final key = _createKey(T, null);
    if (_singletons.containsKey(key)) {
      return _singletons[key] as T?;
    } else if (_factories.containsKey(key)) {
      return _factories[key]!(params) as T?;
    } else {
      return null;
    }
  }

  T? _resolveByName<T>(String instanceName, Map<String, dynamic>? params) {
    final key = _createKey(T, instanceName);
    if (_singletons.containsKey(key)) {
      return _singletons[key] as T?;
    } else if (_factories.containsKey(key)) {
      return _factories[key]!(params) as T?;
    } else {
      return null;
    }
  }

  void dispose() {
    _disposeFunctions.forEach((key, dispose) {
      if (_singletons.containsKey(key)) {
        dispose(_singletons[key]);
      }
    });
    _factories.clear();
    _singletons.clear();
    _disposeFunctions.clear();
  }

  String _createKey(Type type, String? instanceName) =>
      instanceName != null ? '$type$instanceName' : type.toString();
}

typedef ServiceFactory<T> = T Function(Map<String, dynamic>? params);
typedef ServiceDispose<T> = void Function(dynamic instance);
