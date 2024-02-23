import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = LoggerApp();

final class LoggerApp {
  void info(dynamic msg, {dynamic e, StackTrace? s, bool withSentry = true}) {
    _LoggerSerivece.logger.i(
      msg,
      error: e,
      stackTrace: s,
      time: DateTime.now(),
    );
    // if (kReleaseMode && withSentry)  use logeer for release app
  }

  void warnming(dynamic msg, {dynamic e, StackTrace? s, bool withSentry = true}) {
    _LoggerSerivece.logger.w(
      msg,
      error: e,
      stackTrace: s,
      time: DateTime.now(),
    );
    // if (kReleaseMode && withSentry)  use logeer for release app
  }

  void error(dynamic msg, {dynamic e, StackTrace? s, bool withSentry = true}) {
    _LoggerSerivece.logger.e(
      msg,
      error: e,
      stackTrace: s,
      time: DateTime.now(),
    );
    // if (kReleaseMode && withSentry)  use logeer for release app
  }

  void fatal(dynamic msg, {dynamic e, StackTrace? s, bool withSentry = true}) {
    _LoggerSerivece.logger.f(
      msg,
      error: e,
      stackTrace: s,
      time: DateTime.now(),
    );
    // if (kReleaseMode && withSentry)  use logeer for release app
  }
}

abstract final class _LoggerSerivece {
  static final logger = Logger(
    filter: kReleaseMode ? _ReleaseFilter() : _DebugFilter(),
    printer: PrettyPrinter(
        methodCount: 2, // Number of method calls to be displayed
        errorMethodCount: 8, // Number of method calls if stacktrace is provided
        lineLength: 120, // Width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: true // Should each log print contain a timestamp
        ),
  );
}

class _ReleaseFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if ([Level.error, Level.fatal].contains(event.level)) return true;
    return false;
  }
}

class _DebugFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if ([Level.info, Level.warning, Level.error, Level.fatal].contains(event.level)) return true;
    return false;
  }
}
