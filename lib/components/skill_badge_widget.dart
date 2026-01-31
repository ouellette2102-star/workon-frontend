/// Skill badge widget with permit indicator.
///
/// Displays a skill name with visual indicator if permit is required.
///
/// **FL-CATALOG:** Initial implementation.
library;

import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/services/catalog/catalog_models.dart';

/// Widget for displaying a skill with permit indicator.
class SkillBadgeWidget extends StatelessWidget {
  const SkillBadgeWidget({
    super.key,
    required this.skill,
    this.selected = false,
    this.onTap,
    this.compact = false,
  });

  /// The skill to display.
  final Skill skill;

  /// Whether this skill is selected.
  final bool selected;

  /// Callback when tapped.
  final VoidCallback? onTap;

  /// Whether to use compact mode.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Tooltip(
      message: skill.requiresPermit
          ? 'Permis ou certification requis${skill.proofType != null ? ' (${skill.proofType})' : ''}'
          : skill.name,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(compact ? 16 : 20),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 10 : 14,
            vertical: compact ? 6 : 8,
          ),
          decoration: BoxDecoration(
            color: selected
                ? theme.primary.withOpacity(0.15)
                : theme.secondaryBackground,
            borderRadius: BorderRadius.circular(compact ? 16 : 20),
            border: Border.all(
              color: selected ? theme.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                skill.name,
                style: theme.bodySmall.override(
                  fontFamily: 'General Sans',
                  color: selected ? theme.primary : theme.primaryText,
                  fontSize: compact ? 12 : 13,
                  letterSpacing: 0,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              if (skill.requiresPermit) ...[
                SizedBox(width: compact ? 4 : 6),
                Icon(
                  Icons.verified_outlined,
                  size: compact ? 14 : 16,
                  color: theme.warning,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget for displaying a category with legal notes indicator.
class CategoryBadgeWidget extends StatelessWidget {
  const CategoryBadgeWidget({
    super.key,
    required this.category,
    this.selected = false,
    this.onTap,
    this.showLegalNotes = true,
  });

  /// The category to display.
  final ServiceCategory category;

  /// Whether this category is selected.
  final bool selected;

  /// Callback when tapped.
  final VoidCallback? onTap;

  /// Whether to show legal notes indicator.
  final bool showLegalNotes;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasLegalNotes = category.legalNotes != null && category.legalNotes!.isNotEmpty;

    return Tooltip(
      message: hasLegalNotes ? category.legalNotes! : category.name,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? theme.primary.withOpacity(0.15)
                : theme.secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? theme.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (category.icon != null) ...[
                Text(
                  category.icon!,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  category.name,
                  style: theme.bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: selected ? theme.primary : theme.primaryText,
                    letterSpacing: 0,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              if (showLegalNotes && hasLegalNotes) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _showLegalNotesDialog(context, theme),
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: theme.warning,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showLegalNotesDialog(BuildContext context, FlutterFlowTheme theme) {
    if (category.legalNotes == null || category.legalNotes!.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            if (category.icon != null) ...[
              Text(category.icon!, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
            ],
            Expanded(child: Text(category.name)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.gavel_rounded, size: 20, color: theme.warning),
                const SizedBox(width: 8),
                Text(
                  'Notes légales',
                  style: theme.titleSmall.override(
                    fontFamily: 'General Sans',
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              category.legalNotes!,
              style: theme.bodyMedium.override(
                fontFamily: 'General Sans',
                letterSpacing: 0,
              ),
            ),
            if (!category.residentialAllowed) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_rounded, size: 20, color: theme.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Non disponible pour les clients résidentiels',
                        style: theme.bodySmall.override(
                          fontFamily: 'General Sans',
                          color: theme.error,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Compris'),
          ),
        ],
      ),
    );
  }
}

/// Legend widget explaining permit indicators.
class PermitLegendWidget extends StatelessWidget {
  const PermitLegendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_outlined, size: 16, color: theme.warning),
          const SizedBox(width: 6),
          Text(
            'Permis ou certification requis',
            style: theme.bodySmall.override(
              fontFamily: 'General Sans',
              color: theme.warning,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
