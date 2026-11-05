import 'package:core/core.dart';
import 'package:logger/logger.dart' as lib_logger;

class LoggerImpl implements Logger {
  final _logger = lib_logger.Logger(
    printer: lib_logger.PrettyPrinter(
      methodCount: 0,
      colors: false,
      dateTimeFormat: lib_logger.DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  @override
  void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  @override
  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  @override
  void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  @override
  void e(dynamic message, {dynamic error, StackTrace? stackTrace, bool fatal = false}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
