import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() => ServiceLocator().reset());

  test('ServiceLocator singleton creation test', () {
    expect(identical(ServiceLocator(), ServiceLocator()), true);
  });

  test('Factory registration test', () {
    final serviceLocator = ServiceLocator()..registerFactory<String>((_) => 'Test String');
    expect(serviceLocator.get<String>(), 'Test String');
  });

  test('Lazy Singleton registration test', () {
    final serviceLocator = ServiceLocator()..registerLazySingleton<int>((_) => 42);
    expect(serviceLocator.get<int>(), 42);
  });

  test('Retrieving Registered Factory Dependency test', () {
    final serviceLocator = ServiceLocator()
      ..registerFactory<String>((_) => 'Test String')
      ..registerLazySingleton<int>((_) => 42);
    expect(serviceLocator.get<String>(), 'Test String');
  });

  test('Retrieving Registered Lazy Singleton Dependency test', () {
    final serviceLocator = ServiceLocator()
      ..registerFactory<String>((_) => 'Test String')
      ..registerLazySingleton<int>((_) => 42);
    expect(serviceLocator.get<int>(), 42);
  });

  test('Throwing Exception for Unregistered Dependency test', () {
    final serviceLocator = ServiceLocator()
      ..registerFactory<String>((_) => 'Test String')
      ..registerLazySingleton<int>((_) => 42);
    expect(() => serviceLocator.get<double>(), throwsA(isA<Exception>()));
  });

  test('Retrieving Registered Factory Dependency with Instance Name test', () {
    final serviceLocator = ServiceLocator()
      ..registerFactory<String>((_) => 'Test String', instanceName: 'string')
      ..registerLazySingleton<int>((_) => 42, instanceName: 'integer');
    expect(serviceLocator.get<String>(instanceName: 'string'), 'Test String');
  });

  test('Retrieving Registered Lazy Singleton Dependency with Instance Name test', () {
    final serviceLocator = ServiceLocator()
      ..registerFactory<String>((_) => 'Test String', instanceName: 'string')
      ..registerLazySingleton<int>((_) => 42, instanceName: 'integer');
    expect(serviceLocator.get<int>(instanceName: 'integer'), 42);
  });

  test('Throwing Exception for Unregistered Dependency with Instance Name test', () {
    final serviceLocator = ServiceLocator()
      ..registerFactory<String>((_) => 'Test String', instanceName: 'string')
      ..registerLazySingleton<int>((_) => 42, instanceName: 'integer');
    expect(() => serviceLocator.get<double>(instanceName: 'double'), throwsA(isA<Exception>()));
  });

  test('Default Scope Retains Registration test', () {
    final serviceLocator = ServiceLocator()..registerFactory<String>((_) => 'Test String 1');
    expect(serviceLocator.get<String>(), 'Test String 1');
  });

  test('Adding New Scope, Success', () {
    final serviceLocator = ServiceLocator()
      ..registerFactory<String>((_) => 'Test String 1')
      ..pushNewScope(scopeName: 'test');
    expect(serviceLocator.currentScopeName, 'test');
  });

  test('Pop Current Scope Success', () {
    final serviceLocator = ServiceLocator()
      ..registerFactory<String>((_) => 'Test String 1')
      ..pushNewScope(scopeName: 'test')
      ..destroyScope();
    expect(serviceLocator.currentScopeName, 'default');
  });

  test('Adding New Scope with Same Name, Fail', () {
    final serviceLocator = ServiceLocator()
      ..registerFactory<String>((_) => 'Test String 1')
      ..pushNewScope(scopeName: 'test');
    expect(() => serviceLocator.pushNewScope(scopeName: 'test'), throwsA(isA<Exception>()));
  });

  test('Pop Specific Scope Success', () {
    final serviceLocator = ServiceLocator()
      ..registerFactory<String>((_) => 'Test String 1')
      ..pushNewScope(scopeName: 'test')
      ..destroyScope()
      ..destroyScope('test');
    expect(serviceLocator.currentScopeName, 'default');
  });

  test('Pop Specific Scope Failure (No Scope with that name found)', () {
    final serviceLocator = ServiceLocator()
      ..registerFactory<String>((_) => 'Test String 1')
      ..pushNewScope(scopeName: 'test')
      ..destroyScope()
      ..destroyScope('test');
    expect(serviceLocator.destroyScope('test'), false);
  });

  test('Factories return different objects', () {
    final serviceLocator = ServiceLocator()..registerFactory<_TestService>((_) => _TestService());
    expect(
      identical(serviceLocator.get<_TestService>(), serviceLocator.get<_TestService>()),
      false,
    );
  });

  test('Singletones return same objects', () {
    final serviceLocator = ServiceLocator()
      ..registerLazySingleton<_TestService>((_) => _TestService());
    expect(identical(serviceLocator.get<_TestService>(), serviceLocator.get<_TestService>()), true);
  });
}

class _TestService {}
