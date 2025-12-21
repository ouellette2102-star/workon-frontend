/// User service for WorkOn.
///
/// Manages user context and role resolution.
///
/// **PR#10:** Initial implementation with default role (worker).
library;

import 'package:flutter/foundation.dart';

import 'user_context.dart';

/// Service that manages user context and role.
///
/// This service:
/// - Holds the current user context (userId, email, role)
/// - Exposes reactive updates via [ValueNotifier]
/// - Resolves user role (currently defaults to worker)
///
/// ## Usage
///
/// ```dart
/// // Listen for user context changes
/// UserService.contextListenable.addListener(() {
///   final ctx = UserService.context;
///   print('User role: ${ctx.role}');
/// });
///
/// // Set user context after auth
/// await UserService.setFromAuth(userId: 'usr_123', email: 'user@example.com');
///
/// // Reset on logout
/// UserService.reset();
/// ```
///
/// ## Role Resolution
///
/// Currently defaults to [UserRole.worker] for all users.
/// Future PRs may implement actual role fetching from backend.
abstract final class UserService {
  // ─────────────────────────────────────────────────────────────────────────
  // User Context State
  // ─────────────────────────────────────────────────────────────────────────

  /// Internal notifier for user context changes.
  static final ValueNotifier<UserContext> _context =
      ValueNotifier(const UserContext.unknown());

  /// Exposes user context as a listenable for reactive updates.
  ///
  /// Use this to listen for context changes:
  /// ```dart
  /// UserService.contextListenable.addListener(() {
  ///   final ctx = UserService.context;
  ///   // Handle context change
  /// });
  /// ```
  static ValueListenable<UserContext> get contextListenable => _context;

  /// Returns the current user context.
  static UserContext get context => _context.value;

  // ─────────────────────────────────────────────────────────────────────────
  // Context Management
  // ─────────────────────────────────────────────────────────────────────────

  /// Sets the user context from authentication data.
  ///
  /// This method:
  /// 1. Sets status to loading
  /// 2. Resolves the user role (currently defaults to worker)
  /// 3. Sets status to ready with resolved role
  ///
  /// **Never throws** - falls back to default role on any error.
  ///
  /// Example:
  /// ```dart
  /// await UserService.setFromAuth(
  ///   userId: 'usr_123',
  ///   email: 'user@example.com',
  /// );
  /// ```
  static Future<void> setFromAuth({
    required String userId,
    String? email,
  }) async {
    // Set loading state
    _context.value = const UserContext.loading();

    try {
      // Resolve role (currently defaults to worker)
      // TODO(PR#XX): Implement actual role resolution from backend
      final role = await _resolveRole(userId);

      // Set ready state with resolved role
      _context.value = UserContext.fromAuth(
        userId: userId,
        email: email,
        role: role,
      );
    } catch (_) {
      // On any error, fall back to default role
      _context.value = UserContext.fromAuth(
        userId: userId,
        email: email,
        role: UserRole.worker,
      );
    }
  }

  /// Resolves the user role.
  ///
  /// **Current implementation:** Returns [UserRole.worker] as default.
  ///
  /// **Future implementation:** Will call backend to fetch actual role.
  /// This is a safe placeholder that does not require new API endpoints.
  static Future<UserRole> _resolveRole(String userId) async {
    // TODO(PR#XX): Implement actual role resolution:
    // ```dart
    // final profile = await UserRepository.getProfile(userId);
    // return profile.role;
    // ```

    // Safe default: all users are workers until role system is implemented
    return UserRole.worker;
  }

  /// Resets the user context to unknown state.
  ///
  /// Call this on logout to clear user context.
  ///
  /// Example:
  /// ```dart
  /// UserService.reset();
  /// assert(UserService.context.isUnknown);
  /// ```
  static void reset() {
    _context.value = const UserContext.unknown();
  }

  /// Sets the user context directly (for testing).
  ///
  /// Prefer [setFromAuth] for normal usage.
  @visibleForTesting
  static void setContext(UserContext ctx) {
    _context.value = ctx;
  }
}

