import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/search_btn/search_btn_widget.dart';
import '/client_part/components_client/service_item3/service_item3_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'bookmarks_widget.dart' show BookmarksWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BookmarksModel extends FlutterFlowModel<BookmarksWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BackIconBtn component.
  late BackIconBtnModel backIconBtnModel;
  // Model for SearchBtn component.
  late SearchBtnModel searchBtnModel;
  // Model for ServiceItem3 component.
  late ServiceItem3Model serviceItem3Model1;
  // Model for ServiceItem3 component.
  late ServiceItem3Model serviceItem3Model2;
  // Model for ServiceItem3 component.
  late ServiceItem3Model serviceItem3Model3;
  // Model for ServiceItem3 component.
  late ServiceItem3Model serviceItem3Model4;
  // Model for ServiceItem3 component.
  late ServiceItem3Model serviceItem3Model5;
  // Model for ServiceItem3 component.
  late ServiceItem3Model serviceItem3Model6;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
    searchBtnModel = createModel(context, () => SearchBtnModel());
    serviceItem3Model1 = createModel(context, () => ServiceItem3Model());
    serviceItem3Model2 = createModel(context, () => ServiceItem3Model());
    serviceItem3Model3 = createModel(context, () => ServiceItem3Model());
    serviceItem3Model4 = createModel(context, () => ServiceItem3Model());
    serviceItem3Model5 = createModel(context, () => ServiceItem3Model());
    serviceItem3Model6 = createModel(context, () => ServiceItem3Model());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    searchBtnModel.dispose();
    serviceItem3Model1.dispose();
    serviceItem3Model2.dispose();
    serviceItem3Model3.dispose();
    serviceItem3Model4.dispose();
    serviceItem3Model5.dispose();
    serviceItem3Model6.dispose();
  }
}
