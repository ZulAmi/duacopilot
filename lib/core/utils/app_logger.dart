import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Application logging utility with different log levels
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  /// Log debug message (only in debug mode)
  static void debug(String message) {
    if (kDebugMode) {
      _logger.d(message);
    }
  }

  /// Log info message
  static void info(String message) {
    _logger.i(message);
  }

  /// Log warning message
  static void warning(String message) {
    _logger.w(message);
  }

  /// Log error message
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal error message
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}
