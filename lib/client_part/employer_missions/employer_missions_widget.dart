import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/create_mission/create_mission_widget.dart';
import '/client_part/employer_missions/mission_applications_widget.dart';
import '/client_part/mission_detail/mission_detail_widget.dart';
import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/missions/mission_models.dart';
import '/services/missions/missions_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Page displaying employer's created missions.
///
/// Shows all missions created by the employer with their status.
///
/// **PR-01:** Initial implementation for employer my missions.
/// **PR-10:** Added status filter tabs (Open/Active/Done).
class EmployerMissionsWidget extends StatefulWidget {
  const EmployerMissionsWidget({super.key});

  static String routeName = 'EmployerMissions';
  static String routePath = '/employerMissions';

  @override
  State<EmployerMissionsWidget> createState() => _EmployerMissionsWidgetState();
}

/// PR-10: Filter tabs for mission status
enum _MissionFilter {
  all,
  open,
  active,
  done,
}

class _EmployerMissionsWidgetState extends State<EmployerMissionsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Mission> _allMissions = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  /// PR-10: Current filter selection
  _MissionFilter _currentFilter = _MissionFilter.all;

  @override
  void initState() {
    super.initState();
    _loadMissions();
  }

  /// PR-10: Get filtered missions based on current filter
  List<Mission> get _filteredMissions {
    switch (_currentFilter) {
      case _MissionFilter.all:
        return _allMissions;
      case _MissionFilter.open:
        return _allMissions
            .where((m) => m.status == MissionStatus.open)
            .toList();
      case _MissionFilter.active:
        return _allMissions
            .where((m) =>
                m.status == MissionStatus.assigned ||
                m.status == MissionStatus.inProgress)
            .toList();
      case _MissionFilter.done:
        return _allMissions
            .where((m) =>
                m.status == MissionStatus.completed ||
                m.status == MissionStatus.paid ||
                m.status == MissionStatus.cancelled)
            .toList();
    }
  }

  /// PR-10: Get count for each filter
  int _getFilterCount(_MissionFilter filter) {
    switch (filter) {
      case _MissionFilter.all:
        return _allMissions.length;
      case _MissionFilter.open:
        return _allMissions
            .where((m) => m.status == MissionStatus.open)
            .length;
      case _MissionFilter.active:
        return _allMissions
            .where((m) =>
                m.status == MissionStatus.assigned ||
                m.status == MissionStatus.inProgress)
            .length;
      case _MissionFilter.done:
        return _allMissions
            .where((m) =>
                m.status == MissionStatus.completed ||
                m.status == MissionStatus.paid ||
                m.status == MissionStatus.cancelled)
            .length;
    }
  }

  Future<void> _loadMissions() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final api = MissionsApi();
      final missions = await api.fetchMyMissions();

      if (!mounted) return;

      setState(() {
        _allMissions = missions;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('[EmployerMissions] Error loading missions: $e');
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = WkCopy.errorGeneric;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pushNamed(CreateMissionWidget.routeName);
        },
        backgroundColor: FlutterFlowTheme.of(context).primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Créer une mission',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            // PR-10: Filter tabs
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
          Text(
            'Mes missions',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: 'General Sans',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0,
                ),
          ),
          const Spacer(),
          // Refresh button
          IconButton(
            onPressed: _loadMissions,
            icon: Icon(
              Icons.refresh,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
        ],
      ),
    );
  }

  /// PR-10: Build filter tabs
  Widget _buildFilterTabs(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: WkSpacing.pagePadding),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              context,
              filter: _MissionFilter.all,
              label: 'Toutes',
              icon: Icons.list_alt,
            ),
            SizedBox(width: WkSpacing.sm),
            _buildFilterChip(
              context,
              filter: _MissionFilter.open,
              label: 'Ouvertes',
              icon: Icons.fiber_new,
            ),
            SizedBox(width: WkSpacing.sm),
            _buildFilterChip(
              context,
              filter: _MissionFilter.active,
              label: 'En cours',
              icon: Icons.play_circle_outline,
            ),
            SizedBox(width: WkSpacing.sm),
            _buildFilterChip(
              context,
              filter: _MissionFilter.done,
              label: 'Terminées',
              icon: Icons.check_circle_outline,
            ),
          ],
        ),
      ),
    );
  }

  /// PR-10: Build individual filter chip
  Widget _buildFilterChip(
    BuildContext context, {
    required _MissionFilter filter,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _currentFilter == filter;
    final count = _getFilterCount(filter);

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentFilter = filter;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: WkSpacing.md,
          vertical: WkSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(WkRadius.md),
          border: Border.all(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? Colors.white
                  : FlutterFlowTheme.of(context).primaryText,
            ),
            SizedBox(width: WkSpacing.xs),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : FlutterFlowTheme.of(context).primaryText,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            if (count > 0) ...[
              SizedBox(width: WkSpacing.xs),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : FlutterFlowTheme.of(context).primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
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
      return _buildLoadingState(context);
    }

    if (_errorMessage != null) {
      return _buildErrorState(context);
    }

    // PR-10: Check if all missions is empty vs filtered is empty
    if (_allMissions.isEmpty) {
      return _buildEmptyState(context);
    }

    if (_filteredMissions.isEmpty) {
      return _buildFilteredEmptyState(context);
    }

    return _buildMissionsList(context);
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(WkSpacing.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.work_outline,
              size: 64,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            SizedBox(height: WkSpacing.lg),
            Text(
              'Aucune mission créée',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: WkSpacing.sm),
            Text(
              'Créez votre première mission pour trouver des travailleurs.',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: WkSpacing.xl),
            ElevatedButton.icon(
              onPressed: () {
                context.pushNamed(CreateMissionWidget.routeName);
              },
              icon: const Icon(Icons.add),
              label: const Text('Créer une mission'),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: WkSpacing.xl,
                  vertical: WkSpacing.md,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// PR-10: Empty state for filtered results
  Widget _buildFilteredEmptyState(BuildContext context) {
    String message;
    IconData icon;

    switch (_currentFilter) {
      case _MissionFilter.open:
        message = 'Aucune mission ouverte';
        icon = Icons.fiber_new_outlined;
        break;
      case _MissionFilter.active:
        message = 'Aucune mission en cours';
        icon = Icons.play_circle_outline;
        break;
      case _MissionFilter.done:
        message = 'Aucune mission terminée';
        icon = Icons.check_circle_outline;
        break;
      case _MissionFilter.all:
        message = 'Aucune mission';
        icon = Icons.list_alt_outlined;
        break;
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
              message,
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: WkSpacing.sm),
            Text(
              'Essayez un autre filtre ou créez une nouvelle mission.',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: WkSpacing.xl),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _currentFilter = _MissionFilter.all;
                });
              },
              icon: const Icon(Icons.clear_all),
              label: const Text('Voir toutes les missions'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionsList(BuildContext context) {
    final missions = _filteredMissions; // PR-10: Use filtered list

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

  Widget _buildMissionCard(BuildContext context, Mission mission) {
    return GestureDetector(
      onTap: () {
        // Navigate to mission detail (employer view)
        context.pushNamed(
          MissionDetailWidget.routeName,
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

            // Category
            Row(
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 16,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
                SizedBox(width: WkSpacing.xs),
                Text(
                  _formatCategory(mission.category),
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'General Sans',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ),
            SizedBox(height: WkSpacing.xs),

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

            // Price + View Applications button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${mission.price.toStringAsFixed(0)}',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'General Sans',
                        color: FlutterFlowTheme.of(context).primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                      ),
                ),
                // PR-02: View Applications button
                if (mission.status == MissionStatus.open)
                  TextButton.icon(
                    onPressed: () async {
                      // PR-02: Navigate to applications list
                      // PR-11: Refresh on return in case a worker was accepted
                      await context.pushNamed(
                        MissionApplicationsWidget.routeName,
                        pathParameters: {'missionId': mission.id},
                        extra: {'missionTitle': mission.title},
                      );
                      // Refresh missions list after returning
                      _loadMissions();
                    },
                    icon: Icon(
                      Icons.people_outline,
                      size: 18,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                    label: Text(
                      'Candidatures',
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
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
      case MissionStatus.open:
        backgroundColor = WkStatusColors.open.withOpacity(0.1);
        textColor = WkStatusColors.open;
        break;
      case MissionStatus.assigned:
        backgroundColor = WkStatusColors.assigned.withOpacity(0.1);
        textColor = WkStatusColors.assigned;
        break;
      case MissionStatus.inProgress:
        backgroundColor = WkStatusColors.inProgress.withOpacity(0.1);
        textColor = WkStatusColors.inProgress;
        break;
      case MissionStatus.completed:
        backgroundColor = WkStatusColors.completed.withOpacity(0.1);
        textColor = WkStatusColors.completed;
        break;
      case MissionStatus.paid:
        backgroundColor = WkStatusColors.completed.withOpacity(0.1);
        textColor = WkStatusColors.completed;
        break;
      case MissionStatus.cancelled:
        backgroundColor = WkStatusColors.cancelled.withOpacity(0.1);
        textColor = WkStatusColors.cancelled;
        break;
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

  String _formatCategory(String category) {
    // Convert snake_case to Title Case
    return category
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }
}

