import 'package:logger/logger.dart';

/// Application-wide logger service
/// Provides consistent logging across the app with different severity levels
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// Log debug information (for development)
  static void debug(dynamic message) {
    _logger.d(message);
  }

  /// Log general information
  static void info(dynamic message) {
    _logger.i(message);
  }

  /// Log warnings
  static void warning(dynamic message) {
    _logger.w(message);
  }

  /// Log errors
  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal errors (critical failures)
  static void fatal(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}
