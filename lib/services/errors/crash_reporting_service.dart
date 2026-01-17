/// Crash reporting service for WorkOn.
///
/// **PR-24:** Minimal crash reporting and global error boundaries.
///
/// Provides:
/// - Centralized crash/error logging
/// - Sensitive data sanitization
/// - Ready for Crashlytics/Sentry integration
///
/// ## Usage
///
/// ```dart
/// // Record an error
/// CrashReportingService.recordError(error, stackTrace);
///
/// // Record with context
/// CrashReportingService.recordError(
///   error,
///   stackTrace,
///   context: 'PaymentService.processPayment',
///   params: {'missionId': 'abc123'},
/// );
/// ```
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

/// Crash reporting service.
///
/// In production, this should be wired to Firebase Crashlytics, Sentry,
/// or another crash reporting service. Currently logs to console.
abstract final class CrashReportingService {
  /// Whether crash reporting is enabled.
  static bool _enabled = true;

  /// User ID for crash reports.
  static String? _userId;

  /// Custom keys attached to all crash reports.
  static final Map<String, String> _customKeys = {};

  // ─────────────────────────────────────────────────────────────────────────
  // Sensitive Data Patterns (for sanitization)
  // ─────────────────────────────────────────────────────────────────────────

  /// Patterns to sanitize from error messages and stack traces.
  static final List<RegExp> _sensitivePatterns = [
    // JWT tokens (Bearer xxx)
    RegExp(r'Bearer\s+[A-Za-z0-9\-_=]+\.[A-Za-z0-9\-_=]+\.[A-Za-z0-9\-_.+/=]*'),
    // Generic tokens (token=xxx, accessToken=xxx)
    RegExp(r'''(access_?token|refresh_?token|token|api_?key|secret)["\s:=]+["\']?[A-Za-z0-9\-_./+=]{20,}["\']?''', caseSensitive: false),
    // Credit card numbers (16 digits, with or without spaces/dashes)
    RegExp(r'\b(?:\d{4}[-\s]?){3}\d{4}\b'),
    // CVV (3-4 digits after card number context)
    RegExp(r'''\b(cvv|cvc|cvv2|cvc2)["\s:=]+["\']?\d{3,4}["\']?''', caseSensitive: false),
    // Password fields
    RegExp(r'''(password|passwd|pwd)["\s:=]+["\'][^"\']{1,100}["\']''', caseSensitive: false),
    // Email addresses (partial redaction)
    RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'),
    // Phone numbers
    RegExp(r'\b\+?[\d\s\-()]{10,15}\b'),
    // MongoDB ObjectIds (if they contain user data)
    RegExp(r'\b[0-9a-fA-F]{24}\b'),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // Configuration
  // ─────────────────────────────────────────────────────────────────────────

  /// Enables or disables crash reporting.
  static void setEnabled(bool enabled) {
    _enabled = enabled;
    _log('Crash reporting ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Sets the user ID for crash reports.
  ///
  /// Call this after login. Pass null on logout.
  static void setUserId(String? userId) {
    _userId = userId;
    _log('User ID set: ${userId != null ? '${userId.substring(0, 8)}...' : 'null'}');
    
    // TODO: When Crashlytics is configured:
    // FirebaseCrashlytics.instance.setUserIdentifier(userId ?? '');
  }

  /// Clears the user ID.
  static void clearUserId() {
    _userId = null;
    _log('User ID cleared');
  }

  /// Sets a custom key-value pair for crash reports.
  static void setCustomKey(String key, String value) {
    _customKeys[key] = _sanitize(value);
    
    // TODO: When Crashlytics is configured:
    // FirebaseCrashlytics.instance.setCustomKey(key, value);
  }

  /// Removes a custom key.
  static void removeCustomKey(String key) {
    _customKeys.remove(key);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Error Recording
  // ─────────────────────────────────────────────────────────────────────────

  /// Records a non-fatal error.
  ///
  /// [error] The error object.
  /// [stackTrace] The stack trace (optional but recommended).
  /// [context] Where the error occurred (e.g., 'PaymentService.pay').
  /// [params] Additional parameters (will be sanitized).
  /// [fatal] Whether this is a fatal error (default: false).
  static void recordError(
    Object error, {
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? params,
    bool fatal = false,
  }) {
    if (!_enabled) return;

    try {
      // Sanitize error message
      final sanitizedMessage = _sanitize(error.toString());
      final sanitizedStack = stackTrace != null ? _sanitize(stackTrace.toString()) : null;
      final sanitizedParams = params?.map((k, v) => MapEntry(k, _sanitize(v.toString())));

      // Build log entry
      final logEntry = <String, dynamic>{
        'error': sanitizedMessage,
        'fatal': fatal,
        if (context != null) 'context': context,
        if (_userId != null) 'userId': '${_userId!.substring(0, 8)}...',
        if (sanitizedParams != null) 'params': sanitizedParams,
        if (_customKeys.isNotEmpty) 'customKeys': _customKeys,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Log to console
      if (fatal) {
        debugPrint('[CrashReporting] 🔴 FATAL: $logEntry');
      } else {
        debugPrint('[CrashReporting] ⚠️ Error: $logEntry');
      }
      if (sanitizedStack != null && kDebugMode) {
        debugPrint('[CrashReporting] Stack:\n$sanitizedStack');
      }

      // TODO: When Crashlytics is configured:
      // FirebaseCrashlytics.instance.recordError(
      //   error,
      //   stackTrace,
      //   reason: context,
      //   fatal: fatal,
      // );

    } catch (e) {
      // Never let crash reporting crash the app
      debugPrint('[CrashReporting] Failed to record error: $e');
    }
  }

  /// Records a Flutter framework error.
  ///
  /// Call this from FlutterError.onError.
  static void recordFlutterError(FlutterErrorDetails details) {
    recordError(
      details.exception,
      stackTrace: details.stack,
      context: details.context?.toString(),
      fatal: false,
    );
  }

  /// Records a fatal error.
  ///
  /// Use for errors that cause the app to become unusable.
  static void recordFatalError(
    Object error, {
    StackTrace? stackTrace,
    String? context,
  }) {
    recordError(
      error,
      stackTrace: stackTrace,
      context: context,
      fatal: true,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Breadcrumbs / Logs
  // ─────────────────────────────────────────────────────────────────────────

  /// Records a breadcrumb for debugging.
  ///
  /// Breadcrumbs help trace what happened before a crash.
  static void log(String message, {String? category}) {
    if (!_enabled) return;

    try {
      final sanitizedMessage = _sanitize(message);
      debugPrint('[CrashReporting] 📍 ${category != null ? '[$category] ' : ''}$sanitizedMessage');

      // TODO: When Crashlytics is configured:
      // FirebaseCrashlytics.instance.log(sanitizedMessage);

    } catch (e) {
      // Silently ignore
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Sanitization
  // ─────────────────────────────────────────────────────────────────────────

  /// Sanitizes a string by removing/redacting sensitive data.
  static String _sanitize(String input) {
    var result = input;
    for (final pattern in _sensitivePatterns) {
      result = result.replaceAll(pattern, '[REDACTED]');
    }
    return result;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Logging
  // ─────────────────────────────────────────────────────────────────────────

  static void _log(String message) {
    debugPrint('[CrashReporting] $message');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Zone Error Handler
  // ─────────────────────────────────────────────────────────────────────────

  /// Creates a zone error handler for runZonedGuarded.
  ///
  /// Usage:
  /// ```dart
  /// runZonedGuarded(
  ///   () => runApp(MyApp()),
  ///   CrashReportingService.handleZoneError,
  /// );
  /// ```
  static void handleZoneError(Object error, StackTrace stackTrace) {
    recordError(
      error,
      stackTrace: stackTrace,
      context: 'Uncaught async error',
      fatal: !kDebugMode, // Treat as fatal in release mode
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Test Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Forces a test crash (debug mode only).
  ///
  /// Use to verify crash reporting is working.
  static void forceCrash() {
    if (!kDebugMode) {
      debugPrint('[CrashReporting] forceCrash() only works in debug mode');
      return;
    }

    throw StateError('Test crash from CrashReportingService.forceCrash()');
  }

  /// Records a test error (does not crash).
  static void recordTestError() {
    recordError(
      StateError('Test error from CrashReportingService.recordTestError()'),
      stackTrace: StackTrace.current,
      context: 'Test',
      params: {'test': 'true'},
    );
  }

  /// Resets the service (for testing).
  @visibleForTesting
  static void reset() {
    _enabled = true;
    _userId = null;
    _customKeys.clear();
  }
}

