/// Offers service for WorkOn.
///
/// High-level service for managing mission applications.
/// Orchestrates API calls and local persistence.
///
/// **PR-F15:** Initial implementation.
library;

import 'package:flutter/foundation.dart';

import 'applied_missions_store.dart';
import 'offers_api.dart';

/// Result of an apply operation.
enum ApplyResult {
  /// Successfully applied to mission.
  success,

  /// User had already applied (treated as success).
  alreadyApplied,

  /// Network error - no connection.
  networkError,

  /// User not authenticated.
  unauthorized,

  /// Other error.
  error,
}

/// Service for managing mission applications.
///
/// ## Usage
///
/// ```dart
/// // Initialize at app startup
/// await OffersService.initialize();
///
/// // Check if applied
/// final hasApplied = OffersService.hasApplied('mission-id');
///
/// // Apply to mission
/// final result = await OffersService.applyToMission('mission-id');
/// if (result == ApplyResult.success || result == ApplyResult.alreadyApplied) {
///   // Success
/// }
/// ```
abstract final class OffersService {
  // ─────────────────────────────────────────────────────────────────────────
  // State
  // ─────────────────────────────────────────────────────────────────────────

  static final OffersApi _api = OffersApi();
  static bool _initialized = false;

  // Lock to prevent double-taps
  static final Set<String> _inProgress = {};

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the offers service.
  ///
  /// Must be called once at app startup.
  static Future<void> initialize() async {
    if (_initialized) return;

    await AppliedMissionsStore.initialize();
    _initialized = true;

    debugPrint('[OffersService] Initialized');
  }

  /// Syncs applied missions from backend (optional).
  ///
  /// Call this after login to merge backend data with local store.
  static Future<void> syncFromBackend() async {
    await initialize();

    try {
      final backendIds = await _api.fetchMyOffers();
      await AppliedMissionsStore.syncFromBackend(backendIds);
    } catch (e) {
      debugPrint('[OffersService] Sync failed (non-blocking): $e');
      // Non-blocking - local store still works
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Public API
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns `true` if the user has applied to this mission.
  static bool hasApplied(String missionId) {
    return AppliedMissionsStore.hasApplied(missionId);
  }

  /// Exposes applied IDs as a listenable for reactive updates.
  static ValueListenable<Set<String>> get appliedIdsListenable =>
      AppliedMissionsStore.appliedIdsListenable;

  /// Returns `true` if an apply operation is in progress for this mission.
  static bool isApplying(String missionId) {
    return _inProgress.contains(missionId);
  }

  /// Applies to a mission.
  ///
  /// Parameters:
  /// - [missionId]: ID of the mission to apply to
  /// - [message]: Optional application message
  ///
  /// Returns [ApplyResult] indicating the outcome.
  ///
  /// Idempotency:
  /// - If already applied (locally or from backend), returns [ApplyResult.alreadyApplied]
  /// - Prevents double-tap by tracking in-progress requests
  static Future<ApplyResult> applyToMission(
    String missionId, {
    String? message,
  }) async {
    await initialize();

    // Check if already applied (local)
    if (AppliedMissionsStore.hasApplied(missionId)) {
      debugPrint('[OffersService] Already applied locally: $missionId');
      return ApplyResult.alreadyApplied;
    }

    // Prevent double-tap
    if (_inProgress.contains(missionId)) {
      debugPrint('[OffersService] Request already in progress: $missionId');
      return ApplyResult.alreadyApplied;
    }

    _inProgress.add(missionId);

    try {
      await _api.createOffer(missionId: missionId, message: message);

      // Mark as applied locally
      await AppliedMissionsStore.markApplied(missionId);

      debugPrint('[OffersService] Applied successfully: $missionId');
      return ApplyResult.success;
    } on AlreadyAppliedException {
      // Already applied on backend - mark locally and treat as success
      await AppliedMissionsStore.markApplied(missionId);
      debugPrint('[OffersService] Already applied on backend: $missionId');
      return ApplyResult.alreadyApplied;
    } on OffersApiException catch (e) {
      debugPrint('[OffersService] API error: ${e.message}');
      if (e.message.contains('réseau') || e.message.contains('connexion')) {
        return ApplyResult.networkError;
      }
      return ApplyResult.error;
    } on Exception catch (e) {
      debugPrint('[OffersService] Unexpected error: $e');
      return ApplyResult.error;
    } finally {
      _inProgress.remove(missionId);
    }
  }

  /// Clears all applied missions (call on logout).
  static Future<void> clearOnLogout() async {
    await AppliedMissionsStore.clear();
  }
}

