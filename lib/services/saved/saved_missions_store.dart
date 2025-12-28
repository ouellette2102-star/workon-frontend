/// Saved missions local storage service for WorkOn.
///
/// Provides persistent local storage for saved mission IDs using SharedPreferences.
/// Works offline - no backend required.
///
/// **PR-F11:** Initial implementation.
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for persisting saved mission IDs locally.
///
/// Uses SharedPreferences for storage.
///
/// ## Usage
///
/// ```dart
/// // Initialize at app startup
/// await SavedMissionsStore.initialize();
///
/// // Check if mission is saved
/// final isSaved = SavedMissionsStore.isSaved('mission-id');
///
/// // Toggle saved state
/// await SavedMissionsStore.toggleSaved('mission-id');
///
/// // Listen to changes
/// SavedMissionsStore.savedIdsListenable.addListener(() {
///   final savedIds = SavedMissionsStore.savedIds;
/// });
/// ```
abstract final class SavedMissionsStore {
  // ─────────────────────────────────────────────────────────────────────────
  // Storage Key
  // ─────────────────────────────────────────────────────────────────────────

  static const String _storageKey = 'workon_saved_mission_ids';

  // ─────────────────────────────────────────────────────────────────────────
  // State
  // ─────────────────────────────────────────────────────────────────────────

  /// In-memory set of saved mission IDs.
  static final Set<String> _savedIds = {};

  /// ValueNotifier for reactive updates.
  static final ValueNotifier<Set<String>> _notifier = ValueNotifier({});

  /// SharedPreferences instance.
  static SharedPreferences? _prefs;

  /// Whether storage has been initialized.
  static bool _initialized = false;

  // ─────────────────────────────────────────────────────────────────────────
  // Public Getters
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns a copy of the current saved mission IDs.
  static Set<String> get savedIds => Set.unmodifiable(_savedIds);

  /// Returns the number of saved missions.
  static int get count => _savedIds.length;

  /// Exposes saved IDs as a listenable for reactive updates.
  static ValueListenable<Set<String>> get savedIdsListenable => _notifier;

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the saved missions store.
  ///
  /// Must be called once at app startup.
  static Future<void> initialize() async {
    if (_initialized) {
      debugPrint('[SavedMissionsStore] Already initialized');
      return;
    }

    try {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;

      // Load saved IDs from storage
      final storedIds = _prefs?.getStringList(_storageKey);
      if (storedIds != null && storedIds.isNotEmpty) {
        _savedIds.addAll(storedIds);
        _notifier.value = Set.from(_savedIds);
      }

      debugPrint('[SavedMissionsStore] Initialized with ${_savedIds.length} saved missions');
    } catch (e) {
      debugPrint('[SavedMissionsStore] Init error: $e');
      _initialized = true; // Prevent retry loop
    }
  }

  /// Ensures storage is initialized before use.
  static Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await initialize();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Public API
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns `true` if the mission is saved.
  static bool isSaved(String missionId) {
    return _savedIds.contains(missionId);
  }

  /// Toggles the saved state for a mission.
  ///
  /// Returns `true` if the mission is now saved, `false` if removed.
  static Future<bool> toggleSaved(String missionId) async {
    await _ensureInitialized();

    final wasSaved = _savedIds.contains(missionId);

    if (wasSaved) {
      _savedIds.remove(missionId);
      debugPrint('[SavedMissionsStore] Removed: $missionId');
    } else {
      _savedIds.add(missionId);
      debugPrint('[SavedMissionsStore] Added: $missionId');
    }

    // Persist to storage
    await _persist();

    // Notify listeners
    _notifier.value = Set.from(_savedIds);

    return !wasSaved; // Return new state
  }

  /// Saves a mission (adds to saved list).
  static Future<void> save(String missionId) async {
    await _ensureInitialized();

    if (_savedIds.contains(missionId)) return;

    _savedIds.add(missionId);
    await _persist();
    _notifier.value = Set.from(_savedIds);

    debugPrint('[SavedMissionsStore] Saved: $missionId');
  }

  /// Removes a mission from saved list.
  static Future<void> remove(String missionId) async {
    await _ensureInitialized();

    if (!_savedIds.contains(missionId)) return;

    _savedIds.remove(missionId);
    await _persist();
    _notifier.value = Set.from(_savedIds);

    debugPrint('[SavedMissionsStore] Removed: $missionId');
  }

  /// Clears all saved missions.
  static Future<void> clear() async {
    await _ensureInitialized();

    _savedIds.clear();
    await _persist();
    _notifier.value = {};

    debugPrint('[SavedMissionsStore] Cleared all saved missions');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Private Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Persists the current saved IDs to SharedPreferences.
  static Future<void> _persist() async {
    await _prefs?.setStringList(_storageKey, _savedIds.toList());
  }
}

