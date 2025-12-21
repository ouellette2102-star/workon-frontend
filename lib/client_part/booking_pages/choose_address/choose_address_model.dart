import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/select_address_item/select_address_item_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'choose_address_widget.dart' show ChooseAddressWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChooseAddressModel extends FlutterFlowModel<ChooseAddressWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BackIconBtn component.
  late BackIconBtnModel backIconBtnModel;
  // Model for SelectAddressItem component.
  late SelectAddressItemModel selectAddressItemModel1;
  // Model for SelectAddressItem component.
  late SelectAddressItemModel selectAddressItemModel2;
  // Model for SelectAddressItem component.
  late SelectAddressItemModel selectAddressItemModel3;
  // Model for SelectAddressItem component.
  late SelectAddressItemModel selectAddressItemModel4;
  // Model for SelectAddressItem component.
  late SelectAddressItemModel selectAddressItemModel5;
  // Model for SelectAddressItem component.
  late SelectAddressItemModel selectAddressItemModel6;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
    selectAddressItemModel1 =
        createModel(context, () => SelectAddressItemModel());
    selectAddressItemModel2 =
        createModel(context, () => SelectAddressItemModel());
    selectAddressItemModel3 =
        createModel(context, () => SelectAddressItemModel());
    selectAddressItemModel4 =
        createModel(context, () => SelectAddressItemModel());
    selectAddressItemModel5 =
        createModel(context, () => SelectAddressItemModel());
    selectAddressItemModel6 =
        createModel(context, () => SelectAddressItemModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    selectAddressItemModel1.dispose();
    selectAddressItemModel2.dispose();
    selectAddressItemModel3.dispose();
    selectAddressItemModel4.dispose();
    selectAddressItemModel5.dispose();
    selectAddressItemModel6.dispose();
  }
}
