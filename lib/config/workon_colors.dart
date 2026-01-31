/// WorkOn Brand Colors - Premium Dark Theme
///
/// Centralized color palette for the WorkOn app.
/// Based on brand guidelines: Red telephone + Pin location marker.
///
/// **Design System v1.0** - January 2026
library;

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// BRAND COLORS
// ─────────────────────────────────────────────────────────────────────────────

/// WorkOn brand colors - Red accent on dark theme.
abstract final class WkColors {
  // ═══════════════════════════════════════════════════════════════════════════
  // BRAND RED (Primary Accent)
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Primary brand red - CTAs, highlights, active states
  static const Color brandRed = Color(0xFFE53935);
  
  /// Darker red for pressed/hover states
  static const Color brandRedDark = Color(0xFFB71C1C);
  
  /// Lighter red for subtle highlights
  static const Color brandRedLight = Color(0xFFFF6659);
  
  /// Red with 10% opacity for backgrounds
  static const Color brandRedSoft = Color(0x1AE53935);
  
  /// Red with 20% opacity for cards/containers
  static const Color brandRedMuted = Color(0x33E53935);

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME BACKGROUNDS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Primary background - deepest black
  static const Color bgPrimary = Color(0xFF0D0D0F);
  
  /// Secondary background - cards, surfaces
  static const Color bgSecondary = Color(0xFF1A1A1E);
  
  /// Tertiary background - elevated elements, modals
  static const Color bgTertiary = Color(0xFF252529);
  
  /// Quaternary - subtle separators, borders
  static const Color bgQuaternary = Color(0xFF2F2F35);

  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT COLORS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Primary text - headings, important content
  static const Color textPrimary = Color(0xFFFFFFFF);
  
  /// Secondary text - body, descriptions
  static const Color textSecondary = Color(0xFFB0B0B0);
  
  /// Tertiary text - labels, hints, captions
  static const Color textTertiary = Color(0xFF707070);
  
  /// Disabled text
  static const Color textDisabled = Color(0xFF4A4A4A);
  
  /// Text on red background
  static const Color textOnRed = Color(0xFFFFFFFF);

  // ═══════════════════════════════════════════════════════════════════════════
  // GLASSMORPHISM
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Glass effect - 10% white overlay
  static const Color glassWhite = Color(0x1AFFFFFF);
  
  /// Glass border - 20% white
  static const Color glassBorder = Color(0x33FFFFFF);
  
  /// Glass shadow
  static const Color glassShadow = Color(0x40000000);
  
  /// Glass highlight - for glow effects
  static const Color glassHighlight = Color(0x0DFFFFFF);

  // ═══════════════════════════════════════════════════════════════════════════
  // SEMANTIC COLORS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Success - green
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successSoft = Color(0x1A10B981);
  
  /// Warning - amber
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningSoft = Color(0x1AF59E0B);
  
  /// Error - red (same as brand)
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorSoft = Color(0x1AEF4444);
  
  /// Info - blue
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoSoft = Color(0x1A3B82F6);

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS COLORS (Missions)
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Open mission - available
  static const Color statusOpen = Color(0xFF10B981);
  
  /// Assigned - matched with worker
  static const Color statusAssigned = Color(0xFF3B82F6);
  
  /// In Progress - work ongoing
  static const Color statusInProgress = Color(0xFFF59E0B);
  
  /// Completed - finished
  static const Color statusCompleted = Color(0xFF6B7280);
  
  /// Paid - payment confirmed
  static const Color statusPaid = Color(0xFF059669);
  
  /// Cancelled - aborted
  static const Color statusCancelled = Color(0xFFEF4444);

  // ═══════════════════════════════════════════════════════════════════════════
  // BADGES & CHIPS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Reliable badge - green
  static const Color badgeReliable = Color(0xFF10B981);
  
  /// Punctual badge - blue
  static const Color badgePunctual = Color(0xFF3B82F6);
  
  /// Top Performer badge - gold
  static const Color badgeTopPerformer = Color(0xFFF59E0B);
  
  /// Certified badge - red (brand)
  static const Color badgeCertified = Color(0xFFE53935);
  
  /// Premium badge - purple
  static const Color badgePremium = Color(0xFF8B5CF6);

  // ═══════════════════════════════════════════════════════════════════════════
  // GRADIENTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Primary gradient - red to dark red
  static const LinearGradient gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandRed, brandRedDark],
  );
  
  /// Card gradient - subtle dark
  static const LinearGradient gradientCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bgSecondary, bgTertiary],
  );
  
  /// Glass gradient - for premium cards
  static const LinearGradient gradientGlass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [glassWhite, Color(0x0DFFFFFF)],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // SHADOWS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Standard card shadow
  static List<BoxShadow> get shadowCard => [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
  
  /// Elevated shadow for modals
  static List<BoxShadow> get shadowElevated => [
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];
  
  /// Glow shadow for CTAs
  static List<BoxShadow> get shadowGlow => [
    BoxShadow(
      color: brandRed.withOpacity(0.4),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
  
  /// Subtle shadow for inputs
  static List<BoxShadow> get shadowSubtle => [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD DECORATIONS
// ─────────────────────────────────────────────────────────────────────────────

/// Pre-built card decorations for consistent styling.
abstract final class WkCardDecoration {
  /// Standard dark card
  static BoxDecoration get standard => BoxDecoration(
    color: WkColors.bgSecondary,
    borderRadius: BorderRadius.circular(16),
    boxShadow: WkColors.shadowCard,
  );
  
  /// Glassmorphism card
  static BoxDecoration get glass => BoxDecoration(
    color: WkColors.glassWhite,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: WkColors.glassBorder, width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );
  
  /// Elevated card for modals/overlays
  static BoxDecoration get elevated => BoxDecoration(
    color: WkColors.bgTertiary,
    borderRadius: BorderRadius.circular(20),
    boxShadow: WkColors.shadowElevated,
  );
  
  /// Worker card (swipe style)
  static BoxDecoration get workerCard => BoxDecoration(
    color: WkColors.bgSecondary,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.4),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ],
  );
  
  /// Red accent card
  static BoxDecoration get accent => BoxDecoration(
    gradient: WkColors.gradientPrimary,
    borderRadius: BorderRadius.circular(16),
    boxShadow: WkColors.shadowGlow,
  );
  
  /// Input field decoration
  static BoxDecoration get input => BoxDecoration(
    color: WkColors.bgTertiary,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: WkColors.glassBorder, width: 1),
  );
  
  /// Input field focused
  static BoxDecoration get inputFocused => BoxDecoration(
    color: WkColors.bgTertiary,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: WkColors.brandRed, width: 2),
    boxShadow: [
      BoxShadow(
        color: WkColors.brandRed.withOpacity(0.2),
        blurRadius: 8,
        offset: const Offset(0, 0),
      ),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// BUTTON STYLES
// ─────────────────────────────────────────────────────────────────────────────

/// Pre-built button styles.
abstract final class WkButtonStyle {
  /// Primary red button
  static ButtonStyle get primary => ElevatedButton.styleFrom(
    backgroundColor: WkColors.brandRed,
    foregroundColor: WkColors.textOnRed,
    elevation: 4,
    shadowColor: WkColors.brandRed.withOpacity(0.5),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    textStyle: const TextStyle(
      fontFamily: 'General Sans',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    ),
  );
  
  /// Secondary outline button
  static ButtonStyle get secondary => OutlinedButton.styleFrom(
    foregroundColor: WkColors.textPrimary,
    side: const BorderSide(color: WkColors.glassBorder, width: 1.5),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    textStyle: const TextStyle(
      fontFamily: 'General Sans',
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );
  
  /// Ghost text button
  static ButtonStyle get ghost => TextButton.styleFrom(
    foregroundColor: WkColors.brandRed,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    textStyle: const TextStyle(
      fontFamily: 'General Sans',
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );
  
  /// Disabled button
  static ButtonStyle get disabled => ElevatedButton.styleFrom(
    backgroundColor: WkColors.bgTertiary,
    foregroundColor: WkColors.textDisabled,
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );
  
  /// Icon button (FAB style)
  static ButtonStyle get icon => ElevatedButton.styleFrom(
    backgroundColor: WkColors.brandRed,
    foregroundColor: WkColors.textOnRed,
    elevation: 8,
    shadowColor: WkColors.brandRed.withOpacity(0.5),
    shape: const CircleBorder(),
    padding: const EdgeInsets.all(16),
  );
  
  /// Small button
  static ButtonStyle get small => ElevatedButton.styleFrom(
    backgroundColor: WkColors.brandRed,
    foregroundColor: WkColors.textOnRed,
    elevation: 2,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: const TextStyle(
      fontFamily: 'General Sans',
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  );
}
