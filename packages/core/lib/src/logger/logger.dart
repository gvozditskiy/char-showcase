abstract interface class Logger {
  void d(dynamic message, [dynamic error, StackTrace? stackTrace]);
  void w(dynamic message, [dynamic error, StackTrace? stackTrace]);
  void i(dynamic message, [dynamic error, StackTrace? stackTrace]);
  void e(dynamic message, {dynamic error, StackTrace? stackTrace, bool fatal = false});
}
