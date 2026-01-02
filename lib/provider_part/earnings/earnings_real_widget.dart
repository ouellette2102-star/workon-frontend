import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/provider_part/components_provider/drawer_content/drawer_content_widget.dart';
import '/provider_part/components_provider/message_btn/message_btn_widget.dart';
import '/services/missions/mission_models.dart';
import '/services/missions/missions_api.dart';
import 'package:flutter/material.dart';

/// PR-07: Real Earnings widget for providers.
///
/// Shows earnings summary based on completed missions.
/// Note: No dedicated earnings endpoint exists yet - shows placeholder.
class EarningsRealWidget extends StatefulWidget {
  const EarningsRealWidget({super.key});

  static String routeName = 'EarningsReal';
  static String routePath = '/earningsReal';

  @override
  State<EarningsRealWidget> createState() => _EarningsRealWidgetState();
}

class _EarningsRealWidgetState extends State<EarningsRealWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _api = MissionsApi();

  List<Mission> _completedMissions = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadEarnings();
  }

  Future<void> _loadEarnings() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Use my-assignments and filter for completed/paid missions
      final missions = await _api.fetchMyAssignments();

      if (!mounted) return;

      setState(() {
        _completedMissions = missions
            .where((m) =>
                m.status == MissionStatus.completed ||
                m.status == MissionStatus.paid)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('[EarningsReal] Error loading earnings: $e');
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e is MissionsApiException
            ? e.message
            : WkCopy.errorGeneric;
      });
    }
  }

  double get _totalEarnings {
    return _completedMissions.fold(0.0, (sum, m) => sum + m.price);
  }

  int get _completedCount => _completedMissions.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      drawer: Drawer(
        elevation: 16.0,
        child: DrawerContentWidget(activePage: 'earnings'),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  FlutterFlowIconButton(
                    borderRadius: 12.0,
                    buttonSize: 40.0,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    icon: Icon(
                      Icons.menu,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 24.0,
                    ),
                    onPressed: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Text(
                      'Revenus',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'General Sans',
                            fontSize: 20.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _loadEarnings,
                ),
                MessageBtnWidget(),
              ],
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
              onPressed: _loadEarnings,
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
          // Total earnings card
          _buildTotalCard(context),
          SizedBox(height: WkSpacing.xl),

          // Stats
          _buildStatsRow(context),
          SizedBox(height: WkSpacing.xl),

          // Note about detailed earnings
          _buildInfoCard(context),
          SizedBox(height: WkSpacing.xl),

          // Completed missions list
          Text(
            'Missions terminées',
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: 'General Sans',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0,
                ),
          ),
          SizedBox(height: WkSpacing.md),

          if (_completedMissions.isEmpty)
            _buildEmptyMissions(context)
          else
            ..._completedMissions.map((m) => Padding(
                  padding: EdgeInsets.only(bottom: WkSpacing.md),
                  child: _buildMissionCard(context, m),
                )),
        ],
      ),
    );
  }

  Widget _buildTotalCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(WkSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).primary,
            FlutterFlowTheme.of(context).primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(WkRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total des revenus',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'General Sans',
                  color: Colors.white.withOpacity(0.8),
                  letterSpacing: 0.0,
                ),
          ),
          SizedBox(height: WkSpacing.sm),
          Text(
            '\$${_totalEarnings.toStringAsFixed(2)}',
            style: FlutterFlowTheme.of(context).displaySmall.override(
                  fontFamily: 'General Sans',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0,
                ),
          ),
          SizedBox(height: WkSpacing.sm),
          Text(
            'Basé sur ${_completedCount} mission${_completedCount > 1 ? 's' : ''} terminée${_completedCount > 1 ? 's' : ''}',
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'General Sans',
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.check_circle_outline,
            label: 'Terminées',
            value: '$_completedCount',
            color: WkStatusColors.completed,
          ),
        ),
        SizedBox(width: WkSpacing.md),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.attach_money,
            label: 'Moyenne',
            value: _completedCount > 0
                ? '\$${(_totalEarnings / _completedCount).toStringAsFixed(0)}'
                : '-',
            color: FlutterFlowTheme.of(context).primary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(WkSpacing.lg),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(WkRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: WkSpacing.sm),
          Text(
            value,
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: 'General Sans',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0,
                ),
          ),
          Text(
            label,
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'General Sans',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(WkSpacing.lg),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(WkRadius.md),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: FlutterFlowTheme.of(context).primary,
          ),
          SizedBox(width: WkSpacing.md),
          Expanded(
            child: Text(
              'Les statistiques détaillées et les options de retrait seront disponibles prochainement.',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).primary,
                    letterSpacing: 0.0,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMissions(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(WkSpacing.xl),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(WkRadius.md),
      ),
      child: Column(
        children: [
          Icon(
            Icons.work_off_outlined,
            size: 48,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          SizedBox(height: WkSpacing.md),
          Text(
            'Aucune mission terminée',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'General Sans',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
          ),
          SizedBox(height: WkSpacing.sm),
          Text(
            'Complétez des missions pour voir vos revenus ici.',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'General Sans',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(BuildContext context, Mission mission) {
    return Container(
      padding: EdgeInsets.all(WkSpacing.lg),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(WkRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: WkStatusColors.completed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(WkRadius.sm),
            ),
            child: Icon(
              Icons.check_circle,
              color: WkStatusColors.completed,
              size: 24,
            ),
          ),
          SizedBox(width: WkSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission.title,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'General Sans',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.0,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  mission.city,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'General Sans',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ),
          ),
          Text(
            '\$${mission.price.toStringAsFixed(0)}',
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: 'General Sans',
                  color: WkStatusColors.completed,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
  }
}

