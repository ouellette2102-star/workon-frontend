import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/provider_part/components_provider/drawer_content/drawer_content_widget.dart';
import '/provider_part/components_provider/message_btn/message_btn_widget.dart';
import '/services/missions/mission_models.dart';
import '/services/missions/missions_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// PR-07: Real Jobs widget for providers.
///
/// Shows assigned missions from backend (not hardcoded data).
class JobsRealWidget extends StatefulWidget {
  const JobsRealWidget({
    super.key,
    this.initialTab = 0,
  });

  final int initialTab;

  static String routeName = 'JobsReal';
  static String routePath = '/jobsReal';

  @override
  State<JobsRealWidget> createState() => _JobsRealWidgetState();
}

class _JobsRealWidgetState extends State<JobsRealWidget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _api = MissionsApi();
  late TabController _tabController;

  List<Mission> _allMissions = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, 3),
    );
    _loadMissions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMissions() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final missions = await _api.fetchMyAssignments();

      if (!mounted) return;

      setState(() {
        _allMissions = missions;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('[JobsReal] Error loading missions: $e');
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e is MissionsApiException
            ? e.message
            : WkCopy.errorGeneric;
      });
    }
  }

  // Filter missions by status
  List<Mission> get _upcomingMissions => _allMissions
      .where((m) => m.status == MissionStatus.assigned)
      .toList();

  List<Mission> get _inProgressMissions => _allMissions
      .where((m) => m.status == MissionStatus.inProgress)
      .toList();

  List<Mission> get _completedMissions => _allMissions
      .where((m) =>
          m.status == MissionStatus.completed ||
          m.status == MissionStatus.paid)
      .toList();

  List<Mission> get _cancelledMissions => _allMissions
      .where((m) => m.status == MissionStatus.cancelled)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      drawer: Drawer(
        elevation: 16.0,
        child: DrawerContentWidget(activePage: 'my_jobs'),
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
                      'Mes missions',
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
                  onPressed: _loadMissions,
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
        child: Column(
          children: [
            // Tab bar
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: FlutterFlowTheme.of(context).primary,
              unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
              labelStyle: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'General Sans',
                    fontSize: 15.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
              indicatorColor: FlutterFlowTheme.of(context).primary,
              tabs: [
                Tab(text: 'À venir (${_upcomingMissions.length})'),
                Tab(text: 'En cours (${_inProgressMissions.length})'),
                Tab(text: 'Terminées (${_completedMissions.length})'),
                Tab(text: 'Annulées (${_cancelledMissions.length})'),
              ],
            ),

            // Tab content
            Expanded(
              child: _isLoading
                  ? _buildLoadingState(context)
                  : _errorMessage != null
                      ? _buildErrorState(context)
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            _buildMissionsList(context, _upcomingMissions, 'assigned'),
                            _buildMissionsList(context, _inProgressMissions, 'inProgress'),
                            _buildMissionsList(context, _completedMissions, 'completed'),
                            _buildMissionsList(context, _cancelledMissions, 'cancelled'),
                          ],
                        ),
            ),
          ],
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
              onPressed: _loadMissions,
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

  Widget _buildMissionsList(
    BuildContext context,
    List<Mission> missions,
    String type,
  ) {
    if (missions.isEmpty) {
      return _buildEmptyState(context, type);
    }

    return RefreshIndicator(
      onRefresh: _loadMissions,
      color: FlutterFlowTheme.of(context).primary,
      child: ListView.separated(
        padding: EdgeInsets.all(WkSpacing.pagePadding),
        itemCount: missions.length,
        separatorBuilder: (_, __) => SizedBox(height: WkSpacing.md),
        itemBuilder: (context, index) {
          final mission = missions[index];
          return _buildMissionCard(context, mission);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String type) {
    String title;
    String subtitle;
    IconData icon;

    switch (type) {
      case 'assigned':
        title = 'Aucune mission à venir';
        subtitle = 'Vos prochaines missions apparaîtront ici.';
        icon = Icons.event_available_outlined;
        break;
      case 'inProgress':
        title = 'Aucune mission en cours';
        subtitle = 'Démarrez une mission pour la voir ici.';
        icon = Icons.work_outline;
        break;
      case 'completed':
        title = 'Aucune mission terminée';
        subtitle = 'Vos missions complétées seront listées ici.';
        icon = Icons.check_circle_outline;
        break;
      case 'cancelled':
        title = 'Aucune mission annulée';
        subtitle = 'Bonne nouvelle ! Aucune annulation.';
        icon = Icons.cancel_outlined;
        break;
      default:
        title = 'Aucune mission';
        subtitle = '';
        icon = Icons.inbox_outlined;
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.all(WkSpacing.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            SizedBox(height: WkSpacing.lg),
            Text(
              title,
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: WkSpacing.sm),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionCard(BuildContext context, Mission mission) {
    return GestureDetector(
      onTap: () {
        // Navigate to mission detail
        context.pushNamed(
          'MissionDetail',
          pathParameters: {'missionId': mission.id},
          extra: {'mission': mission},
        );
      },
      child: Container(
        padding: EdgeInsets.all(WkSpacing.lg),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(WkRadius.md),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    mission.title,
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: 'General Sans',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.0,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: WkSpacing.sm),
                _buildStatusChip(context, mission.status),
              ],
            ),
            SizedBox(height: WkSpacing.sm),

            // Location
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
                SizedBox(width: WkSpacing.xs),
                Expanded(
                  child: Text(
                    mission.city.isNotEmpty ? mission.city : 'Lieu non spécifié',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: WkSpacing.xs),

            // Date
            Row(
              children: [
                Icon(
                  Icons.schedule_outlined,
                  size: 16,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
                SizedBox(width: WkSpacing.xs),
                Text(
                  DateFormat('dd MMM yyyy', 'fr_FR').format(mission.createdAt),
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'General Sans',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ),
            SizedBox(height: WkSpacing.md),

            // Price
            Text(
              '\$${mission.price.toStringAsFixed(0)}',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, MissionStatus status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case MissionStatus.assigned:
        backgroundColor = WkStatusColors.assigned.withOpacity(0.1);
        textColor = WkStatusColors.assigned;
        break;
      case MissionStatus.inProgress:
        backgroundColor = WkStatusColors.inProgress.withOpacity(0.1);
        textColor = WkStatusColors.inProgress;
        break;
      case MissionStatus.completed:
      case MissionStatus.paid:
        backgroundColor = WkStatusColors.completed.withOpacity(0.1);
        textColor = WkStatusColors.completed;
        break;
      case MissionStatus.cancelled:
        backgroundColor = WkStatusColors.cancelled.withOpacity(0.1);
        textColor = WkStatusColors.cancelled;
        break;
      default:
        backgroundColor = FlutterFlowTheme.of(context).secondaryText.withOpacity(0.1);
        textColor = FlutterFlowTheme.of(context).secondaryText;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: WkSpacing.sm,
        vertical: WkSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(WkRadius.xs),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

