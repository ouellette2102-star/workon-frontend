import '/client_part/components_client/banner/banner_widget.dart';
import '/client_part/components_client/filter_options/filter_options_widget.dart';
import '/client_part/components_client/mig_nav_bar/mig_nav_bar_widget.dart';
import '/client_part/components_client/service_item/service_item_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/missions/mission_models.dart';
import '/services/missions/missions_service.dart';
import 'dart:ui';
import '/index.dart';
import 'home_widget.dart' show HomeWidget;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
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

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Model for Banner component.
  late BannerModel bannerModel1;
  // Model for Banner component.
  late BannerModel bannerModel2;
  // Model for Banner component.
  late BannerModel bannerModel3;
  // State field(s) for Search widget.
  FocusNode? searchFocusNode;
  TextEditingController? searchTextController;
  String? Function(BuildContext, String?)? searchTextControllerValidator;
  // Model for ServiceItem component.
  late ServiceItemModel serviceItemModel1;
  // Model for ServiceItem component.
  late ServiceItemModel serviceItemModel2;
  // Model for ServiceItem component.
  late ServiceItemModel serviceItemModel3;
  // Model for ServiceItem component.
  late ServiceItemModel serviceItemModel4;
  // Model for ServiceItem component.
  late ServiceItemModel serviceItemModel5;
  // Model for ServiceItem component.
  late ServiceItemModel serviceItemModel6;
  // Model for ServiceItem component.
  late ServiceItemModel serviceItemModel7;
  // Model for ServiceItem component.
  late ServiceItemModel serviceItemModel8;
  // Model for ServiceItem component.
  late ServiceItemModel serviceItemModel9;
  // Model for ServiceItem component.
  late ServiceItemModel serviceItemModel10;
  // Model for MigNavBar component.
  late MigNavBarModel migNavBarModel;

  @override
  void initState(BuildContext context) {
    bannerModel1 = createModel(context, () => BannerModel());
    bannerModel2 = createModel(context, () => BannerModel());
    bannerModel3 = createModel(context, () => BannerModel());
    serviceItemModel1 = createModel(context, () => ServiceItemModel());
    serviceItemModel2 = createModel(context, () => ServiceItemModel());
    serviceItemModel3 = createModel(context, () => ServiceItemModel());
    serviceItemModel4 = createModel(context, () => ServiceItemModel());
    serviceItemModel5 = createModel(context, () => ServiceItemModel());
    serviceItemModel6 = createModel(context, () => ServiceItemModel());
    serviceItemModel7 = createModel(context, () => ServiceItemModel());
    serviceItemModel8 = createModel(context, () => ServiceItemModel());
    serviceItemModel9 = createModel(context, () => ServiceItemModel());
    serviceItemModel10 = createModel(context, () => ServiceItemModel());
    migNavBarModel = createModel(context, () => MigNavBarModel());
  }

  @override
  void dispose() {
    bannerModel1.dispose();
    bannerModel2.dispose();
    bannerModel3.dispose();
    searchFocusNode?.dispose();
    searchTextController?.dispose();

    serviceItemModel1.dispose();
    serviceItemModel2.dispose();
    serviceItemModel3.dispose();
    serviceItemModel4.dispose();
    serviceItemModel5.dispose();
    serviceItemModel6.dispose();
    serviceItemModel7.dispose();
    serviceItemModel8.dispose();
    serviceItemModel9.dispose();
    serviceItemModel10.dispose();
    migNavBarModel.dispose();
  }
}
