// PR-CLEANUP: Removed unused banner_widget.dart import
import '/client_part/components_client/filter_options/filter_options_widget.dart';
import '/client_part/components_client/mig_nav_bar/mig_nav_bar_widget.dart';
// PR-CLEANUP: Removed unused service_item_widget.dart import
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/missions/mission_models.dart';
import '/services/missions/missions_service.dart';
import 'dart:ui';
import '/index.dart';
import 'home_widget.dart' show HomeWidget;
// PR-CLEANUP: Removed unused smooth_page_indicator import
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeModel extends FlutterFlowModel<HomeWidget> {
  ///  State fields for stateful widgets in this page.

  // PR-F05: Missions state
  MissionsState missionsState = const MissionsState.initial();
  bool missionsInitialized = false;

  // PR-F05b: Missions view mode (list or cards)
  String missionsViewMode = 'list'; // 'list' or 'cards' or 'map'

  // PR-F10: Missions filters
  double selectedRadius = 10.0; // 5, 10, or 25 km
  String selectedSort = 'proximity'; // 'proximity', 'price_asc', 'price_desc', 'newest'
  String? selectedCategory; // null = all categories

  // PR-F13: User location
  double? userLatitude;
  double? userLongitude;
  bool locationPermissionDenied = false;

  // PR-F22: Accept mission loading state (missionId -> isLoading)
  final Set<String> acceptingMissionIds = {};

  // PR-F24: Start mission loading state (missionId -> isLoading)
  final Set<String> startingMissionIds = {};

  // PR-F25: Complete mission loading state (missionId -> isLoading)
  final Set<String> finishingMissionIds = {};

  // PR-F26: Rating submission loading state (missionId -> isLoading)
  final Set<String> ratingMissionIds = {};

  // PR-F26: Track which missions user has already rated (missionId)
  final Set<String> ratedMissionIds = {};

  // PR-RC1: Payment loading state (missionId -> isLoading)
  final Set<String> payingMissionIds = {};

  // PR-F23: Missions tab mode (worker only)
  // 'available' = nearby open missions, 'my_missions' = assigned missions
  String missionsTabMode = 'available';
  
  // PR-F23: Separate state for "my missions" (assigned to worker)
  MissionsState myMissionsState = const MissionsState.initial();
  bool myMissionsInitialized = false;

  // PR-CLEANUP: Removed PageView and Banner models (template data)
  // State field(s) for Search widget.
  FocusNode? searchFocusNode;
  TextEditingController? searchTextController;
  String? Function(BuildContext, String?)? searchTextControllerValidator;
  // PR-CLEANUP: Removed ServiceItem models 1-10 (template data)
  // Model for MigNavBar component.
  late MigNavBarModel migNavBarModel;

  @override
  void initState(BuildContext context) {
    // PR-CLEANUP: Removed banner and serviceItem model initialization (template data)
    migNavBarModel = createModel(context, () => MigNavBarModel());
  }

  @override
  void dispose() {
    // PR-CLEANUP: Removed banner and serviceItem model disposal (template data)
    searchFocusNode?.dispose();
    searchTextController?.dispose();
    migNavBarModel.dispose();
  }
}
