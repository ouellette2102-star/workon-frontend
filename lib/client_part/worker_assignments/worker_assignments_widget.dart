/// Worker Assignments page for WorkOn.
///
/// Displays missions where the worker has been assigned.
/// This is the "Booking" equivalent for workers in WorkOn.
///
/// **PR-BOOKING:** Implements Worker Booking Flow.
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/mission_detail/mission_detail_widget.dart';
import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/missions/mission_models.dart';
import '/services/missions/missions_api.dart';

/// Page displaying worker's assigned missions ("My Bookings").
///
/// Shows missions where the worker has been accepted and assigned.
/// Supports filtering by status (Upcoming, In Progress, Completed).
class WorkerAssignmentsWidget extends StatefulWidget {
  const WorkerAssignmentsWidget({super.key});

  static String routeName = 'WorkerAssignments';
  static String routePath = '/workerAssignments';

  @override
  State<WorkerAssignmentsWidget> createState() => _WorkerAssignmentsWidgetState();
}

/// Filter tabs for assignment status
enum _AssignmentFilter {
  all,
  upcoming,   // assigned
  active,     // inProgress
  completed,  // completed, paid
}

class _WorkerAssignmentsWidgetState extends State<WorkerAssignmentsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _api = MissionsApi();

  List<Mission> _allAssignments = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  /// Current filter selection
  _AssignmentFilter _currentFilter = _AssignmentFilter.all;

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  /// Get filtered assignments based on current filter
  List<Mission> get _filteredAssignments {
    switch (_currentFilter) {
      case _AssignmentFilter.all:
        return _allAssignments;
      case _AssignmentFilter.upcoming:
        return _allAssignments
            .where((m) => m.status == MissionStatus.assigned)
            .toList();
      case _AssignmentFilter.active:
        return _allAssignments
            .where((m) => m.status == MissionStatus.inProgress)
            .toList();
      case _AssignmentFilter.completed:
        return _allAssignments
            .where((m) =>
                m.status == MissionStatus.completed ||
                m.status == MissionStatus.paid)
            .toList();
    }
  }

  /// Get count for each filter
  int _getFilterCount(_AssignmentFilter filter) {
    switch (filter) {
      case _AssignmentFilter.all:
        return _allAssignments.length;
      case _AssignmentFilter.upcoming:
        return _allAssignments
            .where((m) => m.status == MissionStatus.assigned)
            .length;
      case _AssignmentFilter.active:
        return _allAssignments
            .where((m) => m.status == MissionStatus.inProgress)
            .length;
      case _AssignmentFilter.completed:
        return _allAssignments
            .where((m) =>
                m.status == MissionStatus.completed ||
                m.status == MissionStatus.paid)
            .length;
    }
  }

  Future<void> _loadAssignments() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final assignments = await _api.fetchMyAssignments();

      if (!mounted) return;

      setState(() {
        _allAssignments = assignments;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('[WorkerAssignments] Error loading assignments: $e');
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Impossible de charger vos missions. Vérifiez votre connexion.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildFilterTabs(context),
            Expanded(child: _buildContent(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: WkSpacing.pagePadding,
        vertical: WkSpacing.lg,
      ),
      child: Row(
        children: [
          wrapWithModel(
            model: createModel(context, () => BackIconBtnModel()),
            updateCallback: () => setState(() {}),
            child: BackIconBtnWidget(),
          ),
          SizedBox(width: WkSpacing.md),
          Expanded(
            child: Text(
              'Mes missions',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.0,
                  ),
            ),
          ),
          // Refresh button
          IconButton(
            onPressed: _loadAssignments,
            icon: Icon(
              Icons.refresh,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
        ],
      ),
    );
  }

  /// PR-BOOKING: Filter tabs for assignment status
  Widget _buildFilterTabs(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: WkSpacing.pagePadding),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              context,
              filter: _AssignmentFilter.all,
              label: 'Toutes',
            ),
            SizedBox(width: WkSpacing.sm),
            _buildFilterChip(
              context,
              filter: _AssignmentFilter.upcoming,
              label: 'À venir',
            ),
            SizedBox(width: WkSpacing.sm),
            _buildFilterChip(
              context,
              filter: _AssignmentFilter.active,
              label: 'En cours',
            ),
            SizedBox(width: WkSpacing.sm),
            _buildFilterChip(
              context,
              filter: _AssignmentFilter.completed,
              label: 'Terminées',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required _AssignmentFilter filter,
    required String label,
  }) {
    final isSelected = _currentFilter == filter;
    final count = _getFilterCount(filter);

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentFilter = filter;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: WkSpacing.lg,
          vertical: WkSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(WkRadius.lg),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: isSelected
                        ? Colors.white
                        : FlutterFlowTheme.of(context).primaryText,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    letterSpacing: 0.0,
                  ),
            ),
            if (count > 0) ...[
              SizedBox(width: WkSpacing.xs),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: WkSpacing.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(WkRadius.sm),
                ),
                child: Text(
                  count.toString(),
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'General Sans',
                        color: isSelected
                            ? Colors.white
                            : FlutterFlowTheme.of(context).primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary,
            ),
            SizedBox(height: WkSpacing.lg),
            Text(
              'Chargement...',
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

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(WkSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: FlutterFlowTheme.of(context).error,
              ),
              SizedBox(height: WkSpacing.lg),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
              SizedBox(height: WkSpacing.lg),
              ElevatedButton(
                onPressed: _loadAssignments,
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                ),
                child: Text(
                  'Réessayer',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final assignments = _filteredAssignments;

    if (assignments.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: _loadAssignments,
      child: ListView.builder(
        padding: EdgeInsets.all(WkSpacing.pagePadding),
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          return _buildAssignmentCard(context, assignments[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    String message;
    IconData icon;

    switch (_currentFilter) {
      case _AssignmentFilter.all:
        message = 'Vous n\'avez pas encore de missions assignées.\nPostulez à des missions pour commencer!';
        icon = Icons.work_outline;
        break;
      case _AssignmentFilter.upcoming:
        message = 'Aucune mission à venir.\nLes missions assignées apparaîtront ici.';
        icon = Icons.event_note_outlined;
        break;
      case _AssignmentFilter.active:
        message = 'Aucune mission en cours.\nDémarrez une mission assignée pour la voir ici.';
        icon = Icons.play_circle_outline;
        break;
      case _AssignmentFilter.completed:
        message = 'Aucune mission terminée.\nVos missions complétées apparaîtront ici.';
        icon = Icons.check_circle_outline;
        break;
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.all(WkSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 80,
              color: FlutterFlowTheme.of(context).secondaryText.withOpacity(0.5),
            ),
            SizedBox(height: WkSpacing.lg),
            Text(
              message,
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

  /// PR-BOOKING: Assignment card matching WorkOn design
  Widget _buildAssignmentCard(BuildContext context, Mission mission) {
    return GestureDetector(
      onTap: () => _openMissionDetail(mission),
      child: Container(
        margin: EdgeInsets.only(bottom: WkSpacing.md),
        padding: EdgeInsets.all(WkSpacing.lg),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(WkRadius.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Status badge + Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusBadge(context, mission.status),
                if (mission.createdAt != null)
                  Text(
                    DateFormat('dd MMM yyyy', 'fr_FR').format(mission.createdAt!),
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
              ],
            ),
            SizedBox(height: WkSpacing.md),

            // Title
            Text(
              mission.title,
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.0,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: WkSpacing.sm),

            // Location
            if (mission.city != null || mission.address != null)
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
                      mission.city ?? mission.address ?? '',
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
            SizedBox(height: WkSpacing.md),

            // Footer: Price + Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price
                Text(
                  '${mission.price?.toStringAsFixed(0) ?? '0'} €',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'General Sans',
                        color: FlutterFlowTheme.of(context).primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                      ),
                ),
                // Action hint
                Row(
                  children: [
                    Text(
                      'Voir détails',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'General Sans',
                            color: FlutterFlowTheme.of(context).primary,
                            letterSpacing: 0.0,
                          ),
                    ),
                    SizedBox(width: WkSpacing.xs),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, MissionStatus status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case MissionStatus.assigned:
        bgColor = WkStatusColors.upcoming.withOpacity(0.1);
        textColor = WkStatusColors.upcoming;
        label = 'À venir';
        break;
      case MissionStatus.inProgress:
        bgColor = WkStatusColors.active.withOpacity(0.1);
        textColor = WkStatusColors.active;
        label = 'En cours';
        break;
      case MissionStatus.completed:
        bgColor = WkStatusColors.completed.withOpacity(0.1);
        textColor = WkStatusColors.completed;
        label = 'Terminée';
        break;
      case MissionStatus.paid:
        bgColor = WkStatusColors.completed.withOpacity(0.1);
        textColor = WkStatusColors.completed;
        label = 'Payée';
        break;
      case MissionStatus.cancelled:
        bgColor = WkStatusColors.error.withOpacity(0.1);
        textColor = WkStatusColors.error;
        label = 'Annulée';
        break;
      default:
        bgColor = FlutterFlowTheme.of(context).secondaryText.withOpacity(0.1);
        textColor = FlutterFlowTheme.of(context).secondaryText;
        label = status.displayName;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: WkSpacing.md,
        vertical: WkSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(WkRadius.sm),
      ),
      child: Text(
        label,
        style: FlutterFlowTheme.of(context).bodySmall.override(
              fontFamily: 'General Sans',
              color: textColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.0,
            ),
      ),
    );
  }

  void _openMissionDetail(Mission mission) {
    context.pushNamed(
      MissionDetailWidget.routeName,
      queryParameters: {
        'missionId': mission.id,
      },
      extra: <String, dynamic>{
        'mission': mission,
      },
    );
  }
}

