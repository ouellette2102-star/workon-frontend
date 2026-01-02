/// Global error handler for WorkOn.
///
/// Provides centralized error handling for:
/// - Displaying user-friendly error messages
/// - Catching uncaught Flutter errors
/// - Preventing app crashes in production
/// - Structured debug logging for observability (PR-OBS)
///
/// **PR-ERROR:** Global error handling implementation.
/// **PR-OBS:** Added logError for structured debug logging.
library;

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../config/ui_tokens.dart';
import '../../main.dart' show rootScaffoldMessengerKey;
import '../api/request_id.dart';
import 'app_error.dart';

/// Centralized error handler for WorkOn.
///
/// ## Usage
///
/// ### Initialize at app startup:
/// ```dart
/// void main() {
///   ErrorHandler.initialize();
///   runApp(MyApp());
/// }
/// ```
///
/// ### Show errors from anywhere:
/// ```dart
/// try {
///   await someApiCall();
/// } catch (e) {
///   ErrorHandler.showError(e);
/// }
/// ```
///
/// ### Show with retry action:
/// ```dart
/// ErrorHandler.showError(
///   error,
///   onRetry: () => refetchData(),
/// );
/// ```
abstract final class ErrorHandler {
  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes global error handlers.
  ///
  /// Call this in main() before runApp().
  /// Sets up Flutter error handling and platform error handling.
  static void initialize() {
    // Handle Flutter framework errors (widget build errors, etc.)
    FlutterError.onError = _handleFlutterError;

    // Handle async errors not caught by Flutter (zone errors)
    PlatformDispatcher.instance.onError = _handlePlatformError;

    debugPrint('[ErrorHandler] Initialized');
  }

  /// Handles Flutter framework errors.
  static void _handleFlutterError(FlutterErrorDetails details) {
    // Log the error
    debugPrint('[ErrorHandler] Flutter error: ${details.exception}');
    debugPrint('[ErrorHandler] Stack: ${details.stack}');

    // In debug mode, use default Flutter error handling (red screen)
    if (kDebugMode) {
      FlutterError.presentError(details);
      return;
    }

    // In release mode, log silently and show a snackbar
    // Don't crash the app
    _showErrorSnackbar(
      message: 'Une erreur inattendue est survenue.',
      isRecoverable: true,
    );
  }

  /// Handles platform/async errors.
  static bool _handlePlatformError(Object error, StackTrace stack) {
    // Log the error
    debugPrint('[ErrorHandler] Platform error: $error');
    debugPrint('[ErrorHandler] Stack: $stack');

    // In debug mode, don't swallow the error (let it crash for visibility)
    if (kDebugMode) {
      return false; // Don't handle, let it propagate
    }

    // In release mode, handle gracefully
    _showErrorSnackbar(
      message: 'Une erreur inattendue est survenue.',
      isRecoverable: true,
    );

    return true; // Error handled, don't crash
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Error Display
  // ─────────────────────────────────────────────────────────────────────────

  /// Shows an error to the user via snackbar.
  ///
  /// Automatically converts any exception to [AppError] for consistent
  /// message display.
  ///
  /// Parameters:
  /// - [error]: The error to display (any type, will be converted to AppError)
  /// - [onRetry]: Optional callback for retry action
  /// - [duration]: How long to show the snackbar (default: 4 seconds)
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await api.fetchData();
  /// } catch (e) {
  ///   ErrorHandler.showError(e, onRetry: () => refetchData());
  /// }
  /// ```
  static void showError(
    Object error, {
    VoidCallback? onRetry,
    Duration duration = const Duration(seconds: 4),
  }) {
    final appError = AppError.from(error);

    // PR-OBS: Log structured error in debug mode
    logError(appError);

    _showErrorSnackbar(
      message: appError.message,
      isRecoverable: appError.retryable,
      onRetry: onRetry,
      duration: duration,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PR-OBS/F3: Structured Debug Logging with Dedupe
  // ─────────────────────────────────────────────────────────────────────────

  /// PR-F3: Dedupe guard - tracks recently logged error signatures.
  /// Uses a small fixed-size set to prevent memory leaks.
  /// Signature format: "{errorCode}:{requestId}" or "{errorCode}:{timestamp_second}"
  static final Set<String> _recentlyLogged = {};
  static const int _maxDedupeEntries = 50;

  /// Logs an [AppError] with structured output (debug mode only).
  ///
  /// PR-F3: Includes sessionId, errorCode, and dedupe protection.
  /// Output format (single line JSON-ish):
  /// ```
  /// [AppError] {errorCode, sessionId, requestId, method, path, statusCode, timestamp}
  /// ```
  ///
  /// In release mode, this is a no-op (no logging).
  /// Duplicate errors (same code + requestId within session) are not logged twice.
  ///
  /// Example:
  /// ```dart
  /// final error = AppError.fromResponse(response).withContext(
  ///   requestId: RequestId.sessionId,
  ///   method: 'GET',
  ///   path: '/api/v1/missions',
  /// );
  /// ErrorHandler.logError(error);
  /// ```
  static void logError(AppError error) {
    // Only log in debug mode - no-op in release
    if (!kDebugMode) return;

    // PR-F3: Dedupe check
    final signature = _errorSignature(error);
    if (_recentlyLogged.contains(signature)) {
      return; // Already logged, skip
    }

    // Add to dedupe set (with size limit)
    if (_recentlyLogged.length >= _maxDedupeEntries) {
      // Remove oldest entries (first half)
      final toRemove = _recentlyLogged.take(_maxDedupeEntries ~/ 2).toList();
      _recentlyLogged.removeAll(toRemove);
    }
    _recentlyLogged.add(signature);

    // Build structured log with sessionId
    final logData = <String, dynamic>{
      'sessionId': RequestId.sessionId,
      ...error.toLogMap(),
    };

    debugPrint('[AppError] $logData');
  }

  /// PR-F3: Generates a unique signature for dedupe.
  static String _errorSignature(AppError error) {
    final code = error.code;
    final requestId = error.requestId;
    if (requestId != null && requestId.isNotEmpty) {
      return '$code:$requestId';
    }
    // Fallback: use timestamp rounded to second
    final ts = (error.timestamp ?? DateTime.now()).millisecondsSinceEpoch ~/ 1000;
    return '$code:$ts';
  }

  /// Logs a raw exception with context (debug mode only).
  ///
  /// Convenience method that converts exception to AppError and logs it.
  static void logException(
    Object exception, {
    String? requestId,
    String? method,
    String? path,
  }) {
    if (!kDebugMode) return;

    var appError = AppError.from(exception);
    if (requestId != null || method != null || path != null) {
      appError = appError.withContext(
        requestId: requestId,
        method: method,
        path: path,
      );
    }
    logError(appError);
  }

  /// Shows an [AppError] to the user via snackbar.
  ///
  /// Use this when you already have an AppError instance.
  static void showAppError(
    AppError error, {
    VoidCallback? onRetry,
    Duration duration = const Duration(seconds: 4),
  }) {
    // PR-OBS: Log structured error in debug mode
    logError(error);

    _showErrorSnackbar(
      message: error.message,
      isRecoverable: error.retryable,
      onRetry: onRetry,
      duration: duration,
    );
  }

  /// Shows a custom error message.
  ///
  /// Use sparingly - prefer [showError] with typed exceptions.
  static void showMessage(
    String message, {
    VoidCallback? onRetry,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showErrorSnackbar(
      message: message,
      isRecoverable: onRetry != null,
      onRetry: onRetry,
      duration: duration,
    );
  }

  /// Shows a network error snackbar.
  ///
  /// Convenience method for common network errors.
  static void showNetworkError({VoidCallback? onRetry}) {
    _showErrorSnackbar(
      message: WkCopy.errorNetwork,
      isRecoverable: true,
      onRetry: onRetry,
    );
  }

  /// Shows a generic error snackbar.
  ///
  /// Convenience method for generic errors.
  static void showGenericError({VoidCallback? onRetry}) {
    _showErrorSnackbar(
      message: WkCopy.errorGeneric,
      isRecoverable: true,
      onRetry: onRetry,
    );
  }

  /// Internal method to show the snackbar.
  static void _showErrorSnackbar({
    required String message,
    bool isRecoverable = true,
    VoidCallback? onRetry,
    Duration duration = const Duration(seconds: 4),
  }) {
    final messenger = rootScaffoldMessengerKey.currentState;
    if (messenger == null) {
      debugPrint('[ErrorHandler] No ScaffoldMessenger available');
      return;
    }

    // Hide any existing snackbar
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: WkStatusColors.cancelled,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        action: (isRecoverable && onRetry != null)
            ? SnackBarAction(
                label: WkCopy.retry,
                textColor: Colors.white,
                onPressed: () {
                  messenger.hideCurrentSnackBar();
                  onRetry();
                },
              )
            : null,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Success Display
  // ─────────────────────────────────────────────────────────────────────────

  /// Shows a success message.
  ///
  /// Convenience method for success feedback.
  static void showSuccess(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = rootScaffoldMessengerKey.currentState;
    if (messenger == null) {
      debugPrint('[ErrorHandler] No ScaffoldMessenger available');
      return;
    }

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: WkStatusColors.open, // Green for success
        behavior: SnackBarBehavior.floating,
        duration: duration,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Error Recovery Widget
  // ─────────────────────────────────────────────────────────────────────────

  /// Builds a simple error recovery widget.
  ///
  /// Use this as a fallback UI when a widget fails to build.
  /// Provides a retry button when [onRetry] is provided.
  ///
  /// Example:
  /// ```dart
  /// ErrorHandler.buildErrorWidget(
  ///   message: 'Impossible de charger',
  ///   onRetry: () => setState(() {}),
  /// )
  /// ```
  static Widget buildErrorWidget({
    String? message,
    VoidCallback? onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(WkSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: WkIconSize.xxxl,
              color: WkStatusColors.cancelled,
            ),
            const SizedBox(height: WkSpacing.md),
            Text(
              message ?? WkCopy.errorGeneric,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: WkSpacing.lg),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(WkCopy.retry),
                style: ElevatedButton.styleFrom(
                  backgroundColor: WkStatusColors.open,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PR-H4: CUSTOM ERROR WIDGET (for ErrorWidget.builder)
// ─────────────────────────────────────────────────────────────────────────────

/// Custom error widget shown when a widget build fails in release mode.
///
/// Replaces the default Flutter red error screen with a more
/// user-friendly UI. Includes a retry button that triggers a rebuild.
///
/// **PR-H4:** Full-screen fallback with FR text + retry rebuild (no navigation).
class AppErrorWidget extends StatefulWidget {
  const AppErrorWidget({
    super.key,
    this.details,
  });

  /// Error details (optional, only for debugging).
  final FlutterErrorDetails? details;

  @override
  State<AppErrorWidget> createState() => _AppErrorWidgetState();
}

class _AppErrorWidgetState extends State<AppErrorWidget> {
  int _retryCount = 0;

  void _handleRetry() {
    setState(() {
      _retryCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Error icon
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEE2E2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      size: 64,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Title (FR)
                  const Text(
                    'Une erreur est survenue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Subtitle (FR)
                  const Text(
                    'Veuillez réessayer plus tard.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF64748B),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Retry button (rebuild only, no navigation)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _handleRetry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réessayer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Debug info (debug mode only)
                  if (kDebugMode && widget.details != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Retry #$_retryCount\n${widget.details!.exception}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: Color(0xFFDC2626),
                        ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

