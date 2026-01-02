/// Unified error model for WorkOn.
///
/// Provides a consistent error representation across all API calls
/// and allows for standardized error handling and display.
///
/// **PR-ERROR:** Global error handling implementation.
/// **PR-OBS:** Added request context fields for observability.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../auth/auth_errors.dart';

/// Error type classification.
enum AppErrorType {
  /// No network connection.
  network,

  /// Request timed out.
  timeout,

  /// HTTP error (4xx, 5xx).
  http,

  /// Authentication/authorization error.
  auth,

  /// Data parsing error.
  parse,

  /// Unknown/unexpected error.
  unknown,
}

// ─────────────────────────────────────────────────────────────────────────────
// PR-F3: Stable Error Codes
// ─────────────────────────────────────────────────────────────────────────────

/// Stable error codes for observability.
///
/// These codes are deterministic and safe for logging/metrics.
/// Format: `{category}_{subcategory}` (no PII, no dynamic data).
abstract final class ErrorCode {
  // Network errors
  static const String networkOffline = 'NETWORK_OFFLINE';
  static const String networkTimeout = 'NETWORK_TIMEOUT';
  static const String networkError = 'NETWORK_ERROR';

  // HTTP client errors (4xx)
  static const String httpBadRequest = 'HTTP_400_BAD_REQUEST';
  static const String httpUnauthorized = 'HTTP_401_UNAUTHORIZED';
  static const String httpForbidden = 'HTTP_403_FORBIDDEN';
  static const String httpNotFound = 'HTTP_404_NOT_FOUND';
  static const String httpConflict = 'HTTP_409_CONFLICT';
  static const String httpUnprocessable = 'HTTP_422_UNPROCESSABLE';
  static const String httpTooMany = 'HTTP_429_TOO_MANY';
  static const String httpClientError = 'HTTP_4XX_CLIENT';

  // HTTP server errors (5xx)
  static const String httpServerError = 'HTTP_5XX_SERVER';

  // Auth errors
  static const String authSessionExpired = 'AUTH_SESSION_EXPIRED';
  static const String authForbidden = 'AUTH_FORBIDDEN';
  static const String authError = 'AUTH_ERROR';

  // Parse errors
  static const String parseError = 'PARSE_ERROR';

  // Unknown
  static const String unknown = 'UNKNOWN';

  /// Derives error code from type and status code.
  static String fromTypeAndStatus(AppErrorType type, int? statusCode) {
    switch (type) {
      case AppErrorType.network:
        return networkOffline;
      case AppErrorType.timeout:
        return networkTimeout;
      case AppErrorType.parse:
        return parseError;
      case AppErrorType.auth:
        if (statusCode == 401) return authSessionExpired;
        if (statusCode == 403) return authForbidden;
        return authError;
      case AppErrorType.http:
        return _httpStatusToCode(statusCode);
      case AppErrorType.unknown:
        return unknown;
    }
  }

  static String _httpStatusToCode(int? statusCode) {
    if (statusCode == null) return httpClientError;
    switch (statusCode) {
      case 400:
        return httpBadRequest;
      case 401:
        return httpUnauthorized;
      case 403:
        return httpForbidden;
      case 404:
        return httpNotFound;
      case 409:
        return httpConflict;
      case 422:
        return httpUnprocessable;
      case 429:
        return httpTooMany;
      default:
        if (statusCode >= 500) return httpServerError;
        if (statusCode >= 400) return httpClientError;
        return unknown;
    }
  }
}

/// Unified error model for all API and app errors.
///
/// Centralizes error representation to simplify error handling in UI.
///
/// ## Usage
///
/// ```dart
/// try {
///   await someApiCall();
/// } catch (e) {
///   final appError = AppError.from(e);
///   ErrorHandler.show(appError);
/// }
/// ```
class AppError implements Exception {
  /// Creates an [AppError].
  const AppError({
    required this.type,
    required this.message,
    this.statusCode,
    this.details,
    this.retryable = false,
    this.originalException,
    // PR-OBS: Request context fields
    this.requestId,
    this.method,
    this.path,
    this.timestamp,
    // PR-F3: Stable error code
    this.errorCode,
  });

  /// Error type classification.
  final AppErrorType type;

  /// User-friendly error message (FR).
  final String message;

  /// HTTP status code (if applicable).
  final int? statusCode;

  /// Additional details (for debugging, not shown to user).
  final String? details;

  /// Whether the operation can be retried.
  final bool retryable;

  /// The original exception (for debugging).
  final Object? originalException;

  // ─────────────────────────────────────────────────────────────────────────
  // PR-OBS: Request Context (for observability/debugging)
  // ─────────────────────────────────────────────────────────────────────────

  /// Correlation ID from X-Request-Id header.
  final String? requestId;

  /// HTTP method (GET, POST, etc.).
  final String? method;

  /// Request path (e.g., /api/v1/missions).
  final String? path;

  /// When the error occurred.
  final DateTime? timestamp;

  // ─────────────────────────────────────────────────────────────────────────
  // PR-F3: Stable Error Code
  // ─────────────────────────────────────────────────────────────────────────

  /// Stable error code for observability (e.g., HTTP_401_UNAUTHORIZED).
  ///
  /// Derived from [type] and [statusCode] if not explicitly set.
  final String? errorCode;

  /// Returns the stable error code, deriving it if not set.
  String get code => errorCode ?? ErrorCode.fromTypeAndStatus(type, statusCode);

  /// Creates a copy with request context added.
  ///
  /// Use this to enrich an AppError with request details.
  AppError withContext({
    String? requestId,
    String? method,
    String? path,
  }) {
    return AppError(
      type: type,
      message: message,
      statusCode: statusCode,
      details: details,
      retryable: retryable,
      originalException: originalException,
      requestId: requestId ?? this.requestId,
      method: method ?? this.method,
      path: path ?? this.path,
      timestamp: DateTime.now(),
      errorCode: errorCode,
    );
  }

  /// Creates an [AppError] from any exception.
  ///
  /// Automatically detects the error type and provides appropriate
  /// user-friendly message in French.
  factory AppError.from(Object error, {http.Response? response}) {
    // Already an AppError
    if (error is AppError) {
      return error;
    }

    // Auth exceptions
    if (error is AuthNetworkException) {
      return AppError(
        type: AppErrorType.network,
        message: error.message,
        retryable: true,
        originalException: error,
      );
    }

    if (error is UnauthorizedException) {
      return AppError(
        type: AppErrorType.auth,
        message: 'Session expirée. Veuillez vous reconnecter.',
        statusCode: 401,
        retryable: false,
        originalException: error,
      );
    }

    if (error is AuthException) {
      return AppError(
        type: AppErrorType.auth,
        message: error.message,
        retryable: false,
        originalException: error,
      );
    }

    // Timeout
    if (error is TimeoutException) {
      return const AppError(
        type: AppErrorType.timeout,
        message: 'Délai de connexion dépassé. Réessaie.',
        retryable: true,
      );
    }

    // Socket/Network errors
    if (error is SocketException) {
      return const AppError(
        type: AppErrorType.network,
        message: 'Connexion impossible. Vérifie ta connexion.',
        retryable: true,
      );
    }

    // HTTP client errors
    if (error is http.ClientException) {
      return AppError(
        type: AppErrorType.network,
        message: 'Erreur réseau. Réessaie.',
        details: error.message,
        retryable: true,
        originalException: error,
      );
    }

    // Format/Parse errors
    if (error is FormatException) {
      return AppError(
        type: AppErrorType.parse,
        message: 'Erreur de données. Réessaie.',
        details: error.message,
        retryable: true,
        originalException: error,
      );
    }

    // Generic exception with message
    if (error is Exception) {
      final message = error.toString();
      // Check for common patterns
      if (message.contains('timeout') || message.contains('Timeout')) {
        return const AppError(
          type: AppErrorType.timeout,
          message: 'Délai de connexion dépassé. Réessaie.',
          retryable: true,
        );
      }
      if (message.contains('network') || message.contains('connection')) {
        return const AppError(
          type: AppErrorType.network,
          message: 'Erreur réseau. Réessaie.',
          retryable: true,
        );
      }
    }

    // Unknown error
    return AppError(
      type: AppErrorType.unknown,
      message: 'Une erreur est survenue.',
      details: error.toString(),
      retryable: true,
      originalException: error,
    );
  }

  /// Creates an [AppError] from an HTTP response.
  ///
  /// Parses the response body for error details and maps
  /// status codes to appropriate error types.
  factory AppError.fromResponse(http.Response response) {
    final statusCode = response.statusCode;
    String? serverMessage;

    // Try to parse error message from response body
    try {
      if (response.body.isNotEmpty) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        serverMessage = json['message'] as String? ??
            json['error'] as String? ??
            json['errors']?.toString();
      }
    } catch (_) {
      // Ignore parse errors
    }

    // Map status codes to errors
    switch (statusCode) {
      case 400:
        return AppError(
          type: AppErrorType.http,
          message: serverMessage ?? 'Requête invalide.',
          statusCode: statusCode,
          retryable: false,
        );

      case 401:
        return AppError(
          type: AppErrorType.auth,
          message: serverMessage ?? 'Session expirée. Veuillez vous reconnecter.',
          statusCode: statusCode,
          retryable: false,
        );

      case 403:
        return AppError(
          type: AppErrorType.auth,
          message: serverMessage ?? 'Accès non autorisé.',
          statusCode: statusCode,
          retryable: false,
        );

      case 404:
        return AppError(
          type: AppErrorType.http,
          message: serverMessage ?? 'Élément introuvable.',
          statusCode: statusCode,
          retryable: false,
        );

      case 409:
        return AppError(
          type: AppErrorType.http,
          message: serverMessage ?? 'Conflit de données.',
          statusCode: statusCode,
          retryable: false,
        );

      case 422:
        return AppError(
          type: AppErrorType.http,
          message: serverMessage ?? 'Données invalides.',
          statusCode: statusCode,
          retryable: false,
        );

      case 429:
        return AppError(
          type: AppErrorType.http,
          message: 'Trop de requêtes. Patiente quelques instants.',
          statusCode: statusCode,
          retryable: true,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return AppError(
          type: AppErrorType.http,
          message: 'Erreur serveur. Réessaie plus tard.',
          statusCode: statusCode,
          retryable: true,
        );

      default:
        if (statusCode >= 400 && statusCode < 500) {
          return AppError(
            type: AppErrorType.http,
            message: serverMessage ?? 'Erreur de requête.',
            statusCode: statusCode,
            retryable: false,
          );
        }
        if (statusCode >= 500) {
          return AppError(
            type: AppErrorType.http,
            message: 'Erreur serveur.',
            statusCode: statusCode,
            retryable: true,
          );
        }
        return AppError(
          type: AppErrorType.unknown,
          message: serverMessage ?? 'Une erreur est survenue.',
          statusCode: statusCode,
          retryable: true,
        );
    }
  }

  /// Creates a network error.
  factory AppError.network([String? details]) {
    return AppError(
      type: AppErrorType.network,
      message: 'Connexion impossible. Vérifie ta connexion.',
      details: details,
      retryable: true,
    );
  }

  /// Creates a timeout error.
  factory AppError.timeout([String? details]) {
    return AppError(
      type: AppErrorType.timeout,
      message: 'Délai de connexion dépassé. Réessaie.',
      details: details,
      retryable: true,
    );
  }

  /// Creates a generic error.
  factory AppError.generic([String? message]) {
    return AppError(
      type: AppErrorType.unknown,
      message: message ?? 'Une erreur est survenue.',
      retryable: true,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer('AppError(');
    buffer.write('type: $type, ');
    buffer.write('message: "$message"');
    if (statusCode != null) {
      buffer.write(', status: $statusCode');
    }
    if (details != null) {
      buffer.write(', details: "$details"');
    }
    if (requestId != null) {
      buffer.write(', requestId: $requestId');
    }
    buffer.write(')');
    return buffer.toString();
  }

  /// Converts to a structured map for logging.
  ///
  /// PR-OBS/F3: Used by ErrorHandler.logError for debug output.
  /// Includes errorCode and sessionId for observability.
  /// NEVER includes PII (no emails, tokens, or sensitive data).
  Map<String, dynamic> toLogMap() {
    return {
      'errorCode': code,
      'type': type.name,
      if (statusCode != null) 'statusCode': statusCode,
      if (requestId != null) 'requestId': requestId,
      if (method != null) 'method': method,
      if (path != null) 'path': path,
      'timestamp': (timestamp ?? DateTime.now()).toIso8601String(),
      'retryable': retryable,
      // Note: 'message' and 'details' intentionally excluded from logs
      // to avoid any potential PII leakage from server error messages
    };
  }
}

