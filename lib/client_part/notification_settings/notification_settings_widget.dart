/// Notification settings page.
///
/// Allows users to configure notification preferences.
///
/// **FL-NOTIF-PREFS:** Initial implementation.
library;

import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/notification_preferences/notification_prefs_models.dart';
import '/services/notification_preferences/notification_prefs_service.dart';
import '/services/notification_preferences/notification_prefs_api.dart';

/// Widget for managing notification preferences.
class NotificationSettingsWidget extends StatefulWidget {
  const NotificationSettingsWidget({super.key});

  static String routeName = 'NotificationSettings';
  static String routePath = '/notificationSettings';

  @override
  State<NotificationSettingsWidget> createState() => _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState extends State<NotificationSettingsWidget> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, List<NotificationPreference>> _groupedPrefs = {};

  // Quiet hours
  TimeOfDay? _quietStart;
  TimeOfDay? _quietEnd;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final grouped = await NotificationPrefsService.getGroupedPreferences(
        forceRefresh: true,
      );

      // Parse quiet hours if available
      final quietHours = NotificationPrefsService.quietHours;
      if (quietHours != null) {
        _quietStart = _parseTime(quietHours.start);
        _quietEnd = _parseTime(quietHours.end);
      }

      if (mounted) {
        setState(() {
          _groupedPrefs = grouped;
          _isLoading = false;
        });
      }
    } on NotificationPrefsApiException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[NotificationSettings] Error: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Impossible de charger les préférences';
          _isLoading = false;
        });
      }
    }
  }

  TimeOfDay? _parseTime(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _togglePush(NotificationPreference pref, bool value) async {
    try {
      await NotificationPrefsService.togglePush(pref.notificationType, value);
      await _loadPreferences();
    } catch (e) {
      _showError('Erreur lors de la mise à jour');
    }
  }

  Future<void> _toggleEmail(NotificationPreference pref, bool value) async {
    try {
      await NotificationPrefsService.toggleEmail(pref.notificationType, value);
      await _loadPreferences();
    } catch (e) {
      _showError('Erreur lors de la mise à jour');
    }
  }

  Future<void> _setQuietHours() async {
    final start = await showTimePicker(
      context: context,
      initialTime: _quietStart ?? const TimeOfDay(hour: 22, minute: 0),
      helpText: 'Début du mode silencieux',
    );

    if (start == null || !mounted) return;

    final end = await showTimePicker(
      context: context,
      initialTime: _quietEnd ?? const TimeOfDay(hour: 7, minute: 0),
      helpText: 'Fin du mode silencieux',
    );

    if (end == null || !mounted) return;

    try {
      await NotificationPrefsService.setQuietHours(
        start: _formatTime(start),
        end: _formatTime(end),
      );

      setState(() {
        _quietStart = start;
        _quietEnd = end;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mode silencieux configuré')),
        );
      }
    } catch (e) {
      _showError('Erreur lors de la configuration');
    }
  }

  Future<void> _clearQuietHours() async {
    try {
      await NotificationPrefsService.setQuietHours(
        start: null,
        end: null,
      );

      setState(() {
        _quietStart = null;
        _quietEnd = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mode silencieux désactivé')),
        );
      }
    } catch (e) {
      _showError('Erreur lors de la désactivation');
    }
  }

  Future<void> _unsubscribeMarketing() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Se désabonner?'),
        content: const Text(
          'Vous ne recevrez plus de communications marketing.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await NotificationPrefsService.unsubscribeFromMarketing();
      await _loadPreferences();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Désabonnement effectué')),
        );
      }
    } catch (e) {
      _showError('Erreur lors du désabonnement');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: FlutterFlowTheme.of(context).error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: theme.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Notifications',
          style: theme.titleMedium.override(
            fontFamily: 'General Sans',
            letterSpacing: 0,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _buildBody(theme),
      ),
    );
  }

  Widget _buildBody(FlutterFlowTheme theme) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: theme.primary),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 64, color: theme.error),
              const SizedBox(height: 16),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FFButtonWidget(
                onPressed: _loadPreferences,
                text: 'Réessayer',
                options: FFButtonOptions(
                  width: 200,
                  height: 50,
                  color: theme.primary,
                  textStyle: theme.titleSmall.override(
                    fontFamily: 'General Sans',
                    color: Colors.white,
                    letterSpacing: 0,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPreferences,
      color: theme.primary,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Quiet hours section
          _buildQuietHoursSection(theme),
          const SizedBox(height: 24),

          // Preference categories
          for (final entry in _groupedPrefs.entries) ...[
            _buildCategorySection(theme, entry.key, entry.value),
            const SizedBox(height: 16),
          ],

          // Marketing unsubscribe
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _unsubscribeMarketing,
            icon: Icon(Icons.unsubscribe_outlined, color: theme.error),
            label: Text(
              'Se désabonner du marketing',
              style: theme.bodyMedium.override(
                fontFamily: 'General Sans',
                color: theme.error,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuietHoursSection(FlutterFlowTheme theme) {
    final hasQuietHours = _quietStart != null && _quietEnd != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bedtime_rounded, color: theme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mode silencieux',
                      style: theme.bodyLarge.override(
                        fontFamily: 'General Sans',
                        letterSpacing: 0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      hasQuietHours
                          ? '${_formatTime(_quietStart!)} - ${_formatTime(_quietEnd!)}'
                          : 'Désactivé',
                      style: theme.bodySmall.override(
                        fontFamily: 'General Sans',
                        color: theme.secondaryText,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasQuietHours)
                IconButton(
                  icon: Icon(Icons.close_rounded, color: theme.secondaryText),
                  onPressed: _clearQuietHours,
                ),
              IconButton(
                icon: Icon(Icons.edit_rounded, color: theme.primary),
                onPressed: _setQuietHours,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    FlutterFlowTheme theme,
    String category,
    List<NotificationPreference> prefs,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            category,
            style: theme.titleSmall.override(
              fontFamily: 'General Sans',
              letterSpacing: 0,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              for (var i = 0; i < prefs.length; i++) ...[
                _buildPreferenceRow(theme, prefs[i]),
                if (i < prefs.length - 1)
                  Divider(height: 1, indent: 16, endIndent: 16, color: theme.alternate),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreferenceRow(FlutterFlowTheme theme, NotificationPreference pref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              pref.notificationType.displayName,
              style: theme.bodyMedium.override(
                fontFamily: 'General Sans',
                letterSpacing: 0,
              ),
            ),
          ),
          // Push toggle
          Tooltip(
            message: 'Push',
            child: IconButton(
              icon: Icon(
                pref.pushEnabled
                    ? Icons.notifications_active_rounded
                    : Icons.notifications_off_outlined,
                color: pref.pushEnabled ? theme.primary : theme.secondaryText,
              ),
              onPressed: () => _togglePush(pref, !pref.pushEnabled),
            ),
          ),
          // Email toggle
          Tooltip(
            message: 'Email',
            child: IconButton(
              icon: Icon(
                pref.emailEnabled ? Icons.email_rounded : Icons.email_outlined,
                color: pref.emailEnabled ? theme.primary : theme.secondaryText,
              ),
              onPressed: () => _toggleEmail(pref, !pref.emailEnabled),
            ),
          ),
        ],
      ),
    );
  }
}
