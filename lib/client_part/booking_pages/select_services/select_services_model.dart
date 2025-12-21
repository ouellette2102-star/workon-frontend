import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/service_item_select/service_item_select_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'select_services_widget.dart' show SelectServicesWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SelectServicesModel extends FlutterFlowModel<SelectServicesWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BackIconBtn component.
  late BackIconBtnModel backIconBtnModel;
  // State field(s) for Search widget.
  FocusNode? searchFocusNode;
  TextEditingController? searchTextController;
  String? Function(BuildContext, String?)? searchTextControllerValidator;
  // Model for ServiceItem-Select component.
  late ServiceItemSelectModel serviceItemSelectModel1;
  // Model for ServiceItem-Select component.
  late ServiceItemSelectModel serviceItemSelectModel2;
  // Model for ServiceItem-Select component.
  late ServiceItemSelectModel serviceItemSelectModel3;
  // Model for ServiceItem-Select component.
  late ServiceItemSelectModel serviceItemSelectModel4;
  // Model for ServiceItem-Select component.
  late ServiceItemSelectModel serviceItemSelectModel5;
  // Model for ServiceItem-Select component.
  late ServiceItemSelectModel serviceItemSelectModel6;
  // Model for ServiceItem-Select component.
  late ServiceItemSelectModel serviceItemSelectModel7;
  // Model for ServiceItem-Select component.
  late ServiceItemSelectModel serviceItemSelectModel8;
  // Model for ServiceItem-Select component.
  late ServiceItemSelectModel serviceItemSelectModel9;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
    serviceItemSelectModel1 =
        createModel(context, () => ServiceItemSelectModel());
    serviceItemSelectModel2 =
        createModel(context, () => ServiceItemSelectModel());
    serviceItemSelectModel3 =
        createModel(context, () => ServiceItemSelectModel());
    serviceItemSelectModel4 =
        createModel(context, () => ServiceItemSelectModel());
    serviceItemSelectModel5 =
        createModel(context, () => ServiceItemSelectModel());
    serviceItemSelectModel6 =
        createModel(context, () => ServiceItemSelectModel());
    serviceItemSelectModel7 =
        createModel(context, () => ServiceItemSelectModel());
    serviceItemSelectModel8 =
        createModel(context, () => ServiceItemSelectModel());
    serviceItemSelectModel9 =
        createModel(context, () => ServiceItemSelectModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    searchFocusNode?.dispose();
    searchTextController?.dispose();

    serviceItemSelectModel1.dispose();
    serviceItemSelectModel2.dispose();
    serviceItemSelectModel3.dispose();
    serviceItemSelectModel4.dispose();
    serviceItemSelectModel5.dispose();
    serviceItemSelectModel6.dispose();
    serviceItemSelectModel7.dispose();
    serviceItemSelectModel8.dispose();
    serviceItemSelectModel9.dispose();
  }
}
