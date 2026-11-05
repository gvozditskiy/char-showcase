import 'package:bloc_test/bloc_test.dart';
import 'package:common_ui/src/extensions/cubit_ext.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class TestState extends Equatable {
  const TestState(this.value);
  final int value;

  @override
  List<Object?> get props => [value];

  @override
  String toString() => 'TestState($value)';
}

class TestCubit extends Cubit<TestState> with SafeCubit<TestState> {
  TestCubit(this.logger) : super(const TestState(0));
  final Logger logger;

  void incrementSafely() {
    safeEmit(TestState(state.value + 1), logger: logger);
  }
}

class MockLogger extends Mock implements Logger {}

void main() {
  group('SafeCubit mixin', () {
    group('safeEmit for Cubit', () {
      late TestCubit cubit;
      late MockLogger mockLogger;

      setUp(() {
        mockLogger = MockLogger();
        cubit = TestCubit(mockLogger);
      });

      tearDown(() {
        cubit.close();
      });

      test('should emit state when cubit is open', () {
        cubit.incrementSafely();

        expect(cubit.state.value, 1);
        verifyNever(() => mockLogger.w(any<String>()));
      });

      test('should not emit state when cubit is closed', () async {
        await cubit.close();

        cubit.incrementSafely();

        verify(
          () => mockLogger.w(
            '[TestCubit] Attempted to emit state after close. '
            'State: TestState(1)',
          ),
        ).called(1);
      });

      blocTest<TestCubit, TestState>(
        'should emit state successfully',
        build: () => TestCubit(mockLogger),
        act: (cubit) => cubit.incrementSafely(),
        expect: () => [const TestState(1)],
      );
    });
  });
}
