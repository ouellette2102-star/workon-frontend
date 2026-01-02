import 'dart:io';

import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/errors/error_handler.dart';
import '/services/push/notification_prefs.dart';
import '/services/push/push_api.dart';
import '/services/push/push_config.dart';
import 'package:flutter/material.dart';

/// PR-08: Real notification settings with persistence and device registration.
class NotificationSettingsRealWidget extends StatefulWidget {
  const NotificationSettingsRealWidget({super.key});

  static String routeName = 'NotificationSettingsReal';
  static String routePath = '/notificationSettingsReal';

  @override
  State<NotificationSettingsRealWidget> createState() =>
      _NotificationSettingsRealWidgetState();
}

class _NotificationSettingsRealWidgetState
    extends State<NotificationSettingsRealWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _api = const PushApi();

  bool _isLoading = true;
  bool _isRegistering = false;
  String? _errorMessage;

  // Preference values
  bool _generalEnabled = true;
  bool _securityAlerts = true;
  bool _appUpdates = true;
  bool _billReminder = true;
  bool _promotions = false;
  bool _discounts = true;
  bool _newServices = true;
  bool _appNews = true;
  bool _eventInvitations = false;
  bool _rewardUpdates = true;
  bool _announcements = true;
  bool _tipsTutorials = false;
  bool _messages = true;
  bool _missionUpdates = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await NotificationPrefs.initialize();
      final snapshot = await NotificationPrefs.loadAll();

      if (!mounted) return;

      setState(() {
        _generalEnabled = snapshot.generalEnabled;
        _securityAlerts = snapshot.securityAlerts;
        _appUpdates = snapshot.appUpdates;
        _billReminder = snapshot.billReminder;
        _promotions = snapshot.promotions;
        _discounts = snapshot.discounts;
        _newServices = snapshot.newServices;
        _appNews = snapshot.appNews;
        _eventInvitations = snapshot.eventInvitations;
        _rewardUpdates = snapshot.rewardUpdates;
        _announcements = snapshot.announcements;
        _tipsTutorials = snapshot.tipsTutorials;
        _messages = snapshot.messages;
        _missionUpdates = snapshot.missionUpdates;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('[NotificationSettings] Error loading preferences: $e');
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = WkCopy.errorGeneric;
      });
    }
  }

  Future<void> _onGeneralToggle(bool enabled) async {
    final previousValue = _generalEnabled;

    setState(() {
      _generalEnabled = enabled;
      _isRegistering = true;
    });

    try {
      // Save preference
      await NotificationPrefs.setGeneralEnabled(enabled);

      if (enabled) {
        // Register device
        await _registerDevice();
      } else {
        // Unregister device
        await _unregisterDevice();
      }

      if (!mounted) return;

      setState(() {
        _isRegistering = false;
      });

      ErrorHandler.showSuccess(
        enabled
            ? 'Notifications activées'
            : 'Notifications désactivées',
      );
    } catch (e) {
      debugPrint('[NotificationSettings] Error toggling general: $e');

      if (!mounted) return;

      // Revert on error
      setState(() {
        _generalEnabled = previousValue;
        _isRegistering = false;
      });

      ErrorHandler.showGenericError();
    }
  }

  Future<void> _registerDevice() async {
    if (!PushConfig.enabled) {
      debugPrint('[NotificationSettings] Push disabled by config');
      return;
    }

    // Get stored token or try to get a new one
    String? token = await NotificationPrefs.getDeviceToken();

    // If no token, show guidance
    if (token == null || token.isEmpty) {
      debugPrint('[NotificationSettings] No device token available');

      // For now, we'll use a placeholder. When Firebase is configured,
      // this will use FirebaseMessaging.instance.getToken()
      // TODO: When Firebase is configured, get real token here
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Token de notification indisponible. '
            'Les notifications seront activées dès que possible.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      // Still mark as "wanting notifications" even without token
      await NotificationPrefs.setDeviceRegistered(false);
      return;
    }

    final platform = Platform.isAndroid ? 'android' : 'ios';
    final success = await _api.registerDevice(token: token, platform: platform);

    if (success) {
      await NotificationPrefs.setDeviceRegistered(true);
      debugPrint('[NotificationSettings] Device registered successfully');
    } else {
      debugPrint('[NotificationSettings] Device registration failed');
      throw Exception('Registration failed');
    }
  }

  Future<void> _unregisterDevice() async {
    if (!PushConfig.enabled) {
      debugPrint('[NotificationSettings] Push disabled by config');
      return;
    }

    final token = await NotificationPrefs.getDeviceToken();

    if (token == null || token.isEmpty) {
      debugPrint('[NotificationSettings] No token to unregister');
      await NotificationPrefs.setDeviceRegistered(false);
      return;
    }

    final success = await _api.unregisterDevice(token: token);

    if (success) {
      await NotificationPrefs.setDeviceRegistered(false);
      debugPrint('[NotificationSettings] Device unregistered successfully');
    } else {
      debugPrint('[NotificationSettings] Device unregistration failed');
      // Don't throw - unregister failure is not critical
    }
  }

  Future<void> _savePreference(String key, bool value) async {
    await NotificationPrefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              BackIconBtnWidget(),
              SizedBox(width: 15),
              Text(
                'Paramètres de notifications',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      fontSize: 20.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: _isLoading
              ? _buildLoadingState(context)
              : _errorMessage != null
                  ? _buildErrorState(context)
                  : _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: FlutterFlowTheme.of(context).primary,
          ),
          SizedBox(height: WkSpacing.lg),
          Text(
            WkCopy.loading,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'General Sans',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(WkSpacing.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: WkStatusColors.cancelled,
            ),
            SizedBox(height: WkSpacing.lg),
            Text(
              _errorMessage ?? WkCopy.errorGeneric,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: WkSpacing.xl),
            ElevatedButton.icon(
              onPressed: _loadPreferences,
              icon: const Icon(Icons.refresh),
              label: Text(WkCopy.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(WkSpacing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Master toggle with loading indicator
          _buildMasterToggle(context),
          SizedBox(height: WkSpacing.xl),

          // Push status info
          if (!PushConfig.enabled) ...[
            _buildInfoCard(
              context,
              icon: Icons.info_outline,
              message: 'Les notifications push seront disponibles prochainement.',
              color: FlutterFlowTheme.of(context).primary,
            ),
            SizedBox(height: WkSpacing.xl),
          ],

          // Categories
          _buildSectionTitle(context, 'Sécurité et compte'),
          _buildToggleRow(
            context,
            label: 'Alertes de sécurité',
            value: _securityAlerts,
            onChanged: (v) {
              setState(() => _securityAlerts = v);
              _savePreference(NotificationPrefs.keySecurityAlerts, v);
            },
          ),
          SizedBox(height: WkSpacing.xl),

          _buildSectionTitle(context, 'Missions'),
          _buildToggleRow(
            context,
            label: 'Messages',
            value: _messages,
            onChanged: (v) {
              setState(() => _messages = v);
              _savePreference(NotificationPrefs.keyMessages, v);
            },
          ),
          _buildToggleRow(
            context,
            label: 'Mises à jour des missions',
            value: _missionUpdates,
            onChanged: (v) {
              setState(() => _missionUpdates = v);
              _savePreference(NotificationPrefs.keyMissionUpdates, v);
            },
          ),
          _buildToggleRow(
            context,
            label: 'Rappels de facturation',
            value: _billReminder,
            onChanged: (v) {
              setState(() => _billReminder = v);
              _savePreference(NotificationPrefs.keyBillReminder, v);
            },
          ),
          SizedBox(height: WkSpacing.xl),

          _buildSectionTitle(context, 'Mises à jour'),
          _buildToggleRow(
            context,
            label: 'Mises à jour de l\'app',
            value: _appUpdates,
            onChanged: (v) {
              setState(() => _appUpdates = v);
              _savePreference(NotificationPrefs.keyAppUpdates, v);
            },
          ),
          _buildToggleRow(
            context,
            label: 'Nouveaux services',
            value: _newServices,
            onChanged: (v) {
              setState(() => _newServices = v);
              _savePreference(NotificationPrefs.keyNewServices, v);
            },
          ),
          _buildToggleRow(
            context,
            label: 'Annonces importantes',
            value: _announcements,
            onChanged: (v) {
              setState(() => _announcements = v);
              _savePreference(NotificationPrefs.keyAnnouncements, v);
            },
          ),
          SizedBox(height: WkSpacing.xl),

          _buildSectionTitle(context, 'Marketing'),
          _buildToggleRow(
            context,
            label: 'Promotions',
            value: _promotions,
            onChanged: (v) {
              setState(() => _promotions = v);
              _savePreference(NotificationPrefs.keyPromotions, v);
            },
          ),
          _buildToggleRow(
            context,
            label: 'Réductions disponibles',
            value: _discounts,
            onChanged: (v) {
              setState(() => _discounts = v);
              _savePreference(NotificationPrefs.keyDiscounts, v);
            },
          ),
          _buildToggleRow(
            context,
            label: 'Invitations événements',
            value: _eventInvitations,
            onChanged: (v) {
              setState(() => _eventInvitations = v);
              _savePreference(NotificationPrefs.keyEventInvitations, v);
            },
          ),
          _buildToggleRow(
            context,
            label: 'Programme de récompenses',
            value: _rewardUpdates,
            onChanged: (v) {
              setState(() => _rewardUpdates = v);
              _savePreference(NotificationPrefs.keyRewardUpdates, v);
            },
          ),
          _buildToggleRow(
            context,
            label: 'Conseils et tutoriels',
            value: _tipsTutorials,
            onChanged: (v) {
              setState(() => _tipsTutorials = v);
              _savePreference(NotificationPrefs.keyTipsTutorials, v);
            },
          ),

          SizedBox(height: WkSpacing.xl * 2),
        ],
      ),
    );
  }

  Widget _buildMasterToggle(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(WkSpacing.lg),
      decoration: BoxDecoration(
        color: _generalEnabled
            ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
            : FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(WkRadius.md),
        border: Border.all(
          color: _generalEnabled
              ? FlutterFlowTheme.of(context).primary.withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _generalEnabled
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).secondaryText,
              borderRadius: BorderRadius.circular(WkRadius.sm),
            ),
            child: Icon(
              _generalEnabled
                  ? Icons.notifications_active
                  : Icons.notifications_off,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: WkSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'General Sans',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                      ),
                ),
                Text(
                  _generalEnabled
                      ? 'Activées'
                      : 'Désactivées',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'General Sans',
                        color: _generalEnabled
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ),
          ),
          if (_isRegistering)
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: FlutterFlowTheme.of(context).primary,
              ),
            )
          else
            Switch.adaptive(
              value: _generalEnabled,
              onChanged: _onGeneralToggle,
              activeColor: Colors.white,
              activeTrackColor: FlutterFlowTheme.of(context).primary,
              inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
              inactiveThumbColor: Colors.white,
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: WkSpacing.md),
      child: Text(
        title,
        style: FlutterFlowTheme.of(context).titleSmall.override(
              fontFamily: 'General Sans',
              color: FlutterFlowTheme.of(context).secondaryText,
              letterSpacing: 0.0,
            ),
      ),
    );
  }

  Widget _buildToggleRow(
    BuildContext context, {
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isEnabled = _generalEnabled;

    return Padding(
      padding: EdgeInsets.only(bottom: WkSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                    color: isEnabled
                        ? FlutterFlowTheme.of(context).primaryText
                        : FlutterFlowTheme.of(context).secondaryText,
                  ),
            ),
          ),
          Switch.adaptive(
            value: value && isEnabled,
            onChanged: isEnabled ? onChanged : null,
            activeColor: Colors.white,
            activeTrackColor: FlutterFlowTheme.of(context).primary,
            inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
            inactiveThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String message,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(WkSpacing.lg),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(WkRadius.md),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: WkSpacing.md),
          Expanded(
            child: Text(
              message,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'General Sans',
                    color: color,
                    letterSpacing: 0.0,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

