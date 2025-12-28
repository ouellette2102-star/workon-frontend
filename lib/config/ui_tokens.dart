/// Centralized UI tokens for WorkOn branding consistency.
///
/// This file contains all design tokens (spacing, radius, colors, microcopy)
/// to ensure consistent UX across the app.
///
/// **PR-F08:** Initial implementation.
library;

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SPACING TOKENS
// ─────────────────────────────────────────────────────────────────────────────

/// Standard spacing values used across the app.
abstract final class WkSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  /// Horizontal page padding.
  static const double pagePadding = 20.0;

  /// Section gap.
  static const double sectionGap = 20.0;

  /// Card internal padding.
  static const double cardPadding = 16.0;
}

// ─────────────────────────────────────────────────────────────────────────────
// RADIUS TOKENS
// ─────────────────────────────────────────────────────────────────────────────

/// Standard border radius values.
abstract final class WkRadius {
  static const double xs = 6.0;
  static const double sm = 8.0;
  static const double md = 10.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xxl = 20.0;

  /// Default card radius.
  static const double card = 16.0;

  /// Button radius.
  static const double button = 10.0;

  /// Badge radius.
  static const double badge = 12.0;

  /// Full circle.
  static const double circle = 100.0;
}

// ─────────────────────────────────────────────────────────────────────────────
// MICROCOPY (FRENCH)
// ─────────────────────────────────────────────────────────────────────────────

/// Centralized French microcopy strings.
abstract final class WkCopy {
  // ─── Loading states ───
  static const String loading = 'Chargement…';
  static const String loadingMissions = 'Chargement…';

  // ─── Empty states ───
  static const String emptyMissions = 'Aucune mission disponible près de toi.';
  static const String emptyGeneric = 'Aucun élément à afficher.';

  // ─── Error states ───
  static const String errorMissions = 'Impossible de charger les missions.';
  static const String errorGeneric = 'Une erreur est survenue.';
  static const String errorNotFound = 'Élément introuvable.';
  static const String errorMissionNotFound = 'Mission introuvable.';
  static const String errorNetwork = 'Connexion impossible. Vérifie ta connexion.';

  // ─── Actions ───
  static const String retry = 'Réessayer';
  static const String back = 'Retour';
  static const String seeAll = 'Voir tout';
  static const String refresh = 'Actualiser';

  // ─── Section titles ───
  static const String missionsNearby = 'Missions à proximité 📍';
  static const String popularServices = 'Services populaires 🔥';
  static const String justForYou = 'Juste pour toi';
  static const String missionDetail = 'Détails mission';

  // ─── Mission detail labels ───
  static const String description = 'Description';
  static const String location = 'Localisation';
  static const String information = 'Informations';
  static const String noDescription = 'Aucune description fournie.';
  static const String city = 'Ville';
  static const String address = 'Adresse';
  static const String coordinates = 'Coordonnées';
  static const String distance = 'Distance';
  static const String category = 'Catégorie';
  static const String publishedOn = 'Publiée le';
  static const String budget = 'Budget';

  // ─── PR-F09: Mission actions ───
  static const String actions = 'Actions';
  static const String apply = 'Postuler';
  static const String applyDisabled = 'Mission non disponible';
  static const String share = 'Partager';
  static const String save = 'Sauvegarder';
  static const String comingSoon = 'Bientôt disponible';
  static const String saved = 'Sauvegardé !';
  static const String shared = 'Lien copié !';
  static const String legalDisclaimer = 'WorkOn est une plateforme de mise en relation. Aucun lien d\'emploi. Prestataires autonomes.';

  // ─── PR-F10: Missions filters ───
  static const String filters = 'Filtres';
  static const String sortBy = 'Trier par';
  static const String sortProximity = 'Proximité';
  static const String sortPriceAsc = 'Prix ↑';
  static const String sortPriceDesc = 'Prix ↓';
  static const String sortNewest = 'Nouveau';
  static const String allCategories = 'Toutes';
}

// ─────────────────────────────────────────────────────────────────────────────
// STATUS COLORS
// ─────────────────────────────────────────────────────────────────────────────

/// Status colors for missions.
abstract final class WkStatusColors {
  static const Color open = Color(0xFF10B981); // Emerald green
  static const Color assigned = Color(0xFF3B82F6); // Blue
  static const Color inProgress = Color(0xFFF59E0B); // Amber
  static const Color completed = Color(0xFF6B7280); // Gray
  static const Color cancelled = Color(0xFFEF4444); // Red
  static const Color unknown = Color(0xFF9CA3AF); // Light gray
}

// ─────────────────────────────────────────────────────────────────────────────
// GRADIENT PRESETS
// ─────────────────────────────────────────────────────────────────────────────

/// Predefined gradient color pairs for cards.
abstract final class WkGradients {
  static const List<List<Color>> cardGradients = [
    [Color(0xFF6366F1), Color(0xFF8B5CF6)], // Indigo-violet
    [Color(0xFF10B981), Color(0xFF059669)], // Emerald
    [Color(0xFFF59E0B), Color(0xFFD97706)], // Amber
    [Color(0xFFEC4899), Color(0xFFDB2777)], // Pink
    [Color(0xFF3B82F6), Color(0xFF1D4ED8)], // Blue
  ];

  /// Get gradient at index (cycles through available gradients).
  static List<Color> getCardGradient(int index) {
    return cardGradients[index % cardGradients.length];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ICON SIZES
// ─────────────────────────────────────────────────────────────────────────────

/// Standard icon sizes.
abstract final class WkIconSize {
  static const double xs = 14.0;
  static const double sm = 16.0;
  static const double md = 20.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;
  static const double xxxl = 48.0;
}

// ─────────────────────────────────────────────────────────────────────────────
// ANIMATION DURATIONS
// ─────────────────────────────────────────────────────────────────────────────

/// Standard animation durations.
abstract final class WkDuration {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
}

