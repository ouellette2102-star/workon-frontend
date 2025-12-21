import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/read_more_text/read_more_text_widget.dart';
import '/client_part/components_client/review_item/review_item_widget.dart';
import '/client_part/components_client/service_item_provider/service_item_provider_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'provider_public_profile_widget.dart' show ProviderPublicProfileWidget;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProviderPublicProfileModel
    extends FlutterFlowModel<ProviderPublicProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BackIconBtn component.
  late BackIconBtnModel backIconBtnModel;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Model for ReadMoreText component.
  late ReadMoreTextModel readMoreTextModel;
  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController;

  // Model for ServiceItemProvider component.
  late ServiceItemProviderModel serviceItemProviderModel1;
  // Model for ServiceItemProvider component.
  late ServiceItemProviderModel serviceItemProviderModel2;
  // Model for ServiceItemProvider component.
  late ServiceItemProviderModel serviceItemProviderModel3;
  // Model for ServiceItemProvider component.
  late ServiceItemProviderModel serviceItemProviderModel4;
  // Model for ReviewItem component.
  late ReviewItemModel reviewItemModel1;
  // Model for ReviewItem component.
  late ReviewItemModel reviewItemModel2;
  // Model for ReviewItem component.
  late ReviewItemModel reviewItemModel3;
  // Model for ReviewItem component.
  late ReviewItemModel reviewItemModel4;
  // Model for ReviewItem component.
  late ReviewItemModel reviewItemModel5;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
    readMoreTextModel = createModel(context, () => ReadMoreTextModel());
    serviceItemProviderModel1 =
        createModel(context, () => ServiceItemProviderModel());
    serviceItemProviderModel2 =
        createModel(context, () => ServiceItemProviderModel());
    serviceItemProviderModel3 =
        createModel(context, () => ServiceItemProviderModel());
    serviceItemProviderModel4 =
        createModel(context, () => ServiceItemProviderModel());
    reviewItemModel1 = createModel(context, () => ReviewItemModel());
    reviewItemModel2 = createModel(context, () => ReviewItemModel());
    reviewItemModel3 = createModel(context, () => ReviewItemModel());
    reviewItemModel4 = createModel(context, () => ReviewItemModel());
    reviewItemModel5 = createModel(context, () => ReviewItemModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    tabBarController?.dispose();
    readMoreTextModel.dispose();
    expandableExpandableController.dispose();
    serviceItemProviderModel1.dispose();
    serviceItemProviderModel2.dispose();
    serviceItemProviderModel3.dispose();
    serviceItemProviderModel4.dispose();
    reviewItemModel1.dispose();
    reviewItemModel2.dispose();
    reviewItemModel3.dispose();
    reviewItemModel4.dispose();
    reviewItemModel5.dispose();
  }
}
