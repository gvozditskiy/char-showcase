import 'dart:async';

class BufferedStreamController<T> {
  BufferedStreamController({this.clearOnConsume = false});

  final bool clearOnConsume;
  final StreamController<T> _streamController = StreamController<T>.broadcast();
  T? _lastValue;

  Stream<T> get stream async* {
    if (_lastValue != null) {
      yield _lastValue!;
    }
    yield* _streamController.stream;
  }

  void add(T event) {
    _lastValue = event;
    _streamController.add(event);
  }

  StreamSubscription<T> listen(
    void Function(T event) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    final subscription = _streamController.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );

    if (_lastValue != null) {
      onData(_lastValue as T);
      if (clearOnConsume) {
        _lastValue = null;
      }
    }

    return subscription;
  }

  void clear() {
    _lastValue = null;
  }

  Future<void> close() async {
    await _streamController.close();
  }
}
