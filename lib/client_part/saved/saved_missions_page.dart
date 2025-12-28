import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/mission_detail/mission_detail_widget.dart';
import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/missions/mission_models.dart';
import '/services/missions/missions_service.dart';
import '/services/saved/saved_missions_store.dart';
import 'package:flutter/material.dart';

/// Page displaying saved missions (local only).
///
/// Shows list of missions saved by the user.
/// Works offline - no backend required.
///
/// **PR-F11:** Initial implementation.
class SavedMissionsPage extends StatefulWidget {
  const SavedMissionsPage({super.key});

  static String routeName = 'SavedMissions';
  static String routePath = '/savedMissions';

  @override
  State<SavedMissionsPage> createState() => _SavedMissionsPageState();
}

class _SavedMissionsPageState extends State<SavedMissionsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Mission> _savedMissions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedMissions();

    // Listen to changes
    SavedMissionsStore.savedIdsListenable.addListener(_onSavedChanged);
  }

  @override
  void dispose() {
    SavedMissionsStore.savedIdsListenable.removeListener(_onSavedChanged);
    super.dispose();
  }

  void _onSavedChanged() {
    if (mounted) {
      _loadSavedMissions();
    }
  }

  Future<void> _loadSavedMissions() async {
    final savedIds = SavedMissionsStore.savedIds;

    if (savedIds.isEmpty) {
      setState(() {
        _savedMissions = [];
        _isLoading = false;
      });
      return;
    }

    // Get missions from cache or fetch
    final missions = <Mission>[];
    final currentState = MissionsService.state;

    for (final id in savedIds) {
      // Check cache first
      final cached = currentState.missions.where((m) => m.id == id).firstOrNull;
      if (cached != null) {
        missions.add(cached);
      } else {
        // Try to fetch by ID
        final fetched = await MissionsService.getById(id);
        if (fetched != null) {
          missions.add(fetched);
        }
      }
    }

    if (mounted) {
      setState(() {
        _savedMissions = missions;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              wrapWithModel(
                model: createModel(context, () => BackIconBtnModel()),
                updateCallback: () => setState(() {}),
                child: BackIconBtnWidget(),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  WkCopy.savedMissions,
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
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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

    if (_savedMissions.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: _loadSavedMissions,
      color: FlutterFlowTheme.of(context).primary,
      child: ListView.builder(
        padding: EdgeInsets.all(WkSpacing.xl),
        itemCount: _savedMissions.length,
        itemBuilder: (context, index) {
          final mission = _savedMissions[index];
          return _buildMissionCard(context, mission);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(WkSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_outline,
              size: WkIconSize.xxxl,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            SizedBox(height: WkSpacing.lg),
            Text(
              WkCopy.emptySavedMissions,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: WkSpacing.sm),
            Text(
              WkCopy.tapToSaveHint,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: WkSpacing.xxl),
            FFButtonWidget(
              onPressed: () => context.pop(),
              text: WkCopy.back,
              options: FFButtonOptions(
                padding: EdgeInsets.symmetric(
                    horizontal: WkSpacing.xxl, vertical: WkSpacing.md),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      color: Colors.white,
                      letterSpacing: 0.0,
                    ),
                borderRadius: BorderRadius.circular(WkRadius.lg),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionCard(BuildContext context, Mission mission) {
    return Padding(
      padding: EdgeInsets.only(bottom: WkSpacing.md),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            MissionDetailWidget.routeName,
            queryParameters: {
              'missionId': mission.id,
            }.withoutNulls,
            extra: <String, dynamic>{
              'mission': mission,
            },
          );
        },
        borderRadius: BorderRadius.circular(WkRadius.card),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(WkSpacing.cardPadding),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(WkRadius.card),
          ),
          child: Row(
            children: [
              // Category icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(WkRadius.lg),
                ),
                child: Center(
                  child: Icon(
                    _getCategoryIcon(mission.category),
                    color: FlutterFlowTheme.of(context).primary,
                    size: WkIconSize.lg,
                  ),
                ),
              ),
              SizedBox(width: WkSpacing.md),
              // Mission info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'General Sans',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.0,
                          ),
                    ),
                    SizedBox(height: WkSpacing.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: WkIconSize.xs,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        SizedBox(width: WkSpacing.xs),
                        Expanded(
                          child: Text(
                            mission.city,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'General Sans',
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Price and remove button
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    mission.formattedPrice,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'General Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(height: WkSpacing.xs),
                  InkWell(
                    onTap: () async {
                      await SavedMissionsStore.remove(mission.id);
                    },
                    borderRadius: BorderRadius.circular(WkRadius.circle),
                    child: Padding(
                      padding: EdgeInsets.all(WkSpacing.xs),
                      child: Icon(
                        Icons.bookmark,
                        size: WkIconSize.md,
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'snow_removal':
      case 'deneigement':
        return Icons.ac_unit;
      case 'cleaning':
      case 'menage':
        return Icons.cleaning_services;
      case 'plumbing':
      case 'plomberie':
        return Icons.plumbing;
      case 'painting':
      case 'peinture':
        return Icons.format_paint;
      case 'gardening':
      case 'jardinage':
        return Icons.grass;
      case 'moving':
      case 'demenagement':
        return Icons.local_shipping;
      case 'handyman':
      case 'bricolage':
        return Icons.build;
      default:
        return Icons.work_outline;
    }
  }
}

