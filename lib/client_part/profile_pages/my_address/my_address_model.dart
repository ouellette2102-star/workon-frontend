import '/client_part/components_client/address_item/address_item_widget.dart';
import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'my_address_widget.dart' show MyAddressWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyAddressModel extends FlutterFlowModel<MyAddressWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BackIconBtn component.
  late BackIconBtnModel backIconBtnModel;
  // Model for AddressItem component.
  late AddressItemModel addressItemModel1;
  // Model for AddressItem component.
  late AddressItemModel addressItemModel2;
  // Model for AddressItem component.
  late AddressItemModel addressItemModel3;
  // Model for AddressItem component.
  late AddressItemModel addressItemModel4;
  // Model for AddressItem component.
  late AddressItemModel addressItemModel5;
  // Model for AddressItem component.
  late AddressItemModel addressItemModel6;
  // Model for AddressItem component.
  late AddressItemModel addressItemModel7;
  // Model for AddressItem component.
  late AddressItemModel addressItemModel8;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
    addressItemModel1 = createModel(context, () => AddressItemModel());
    addressItemModel2 = createModel(context, () => AddressItemModel());
    addressItemModel3 = createModel(context, () => AddressItemModel());
    addressItemModel4 = createModel(context, () => AddressItemModel());
    addressItemModel5 = createModel(context, () => AddressItemModel());
    addressItemModel6 = createModel(context, () => AddressItemModel());
    addressItemModel7 = createModel(context, () => AddressItemModel());
    addressItemModel8 = createModel(context, () => AddressItemModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    addressItemModel1.dispose();
    addressItemModel2.dispose();
    addressItemModel3.dispose();
    addressItemModel4.dispose();
    addressItemModel5.dispose();
    addressItemModel6.dispose();
    addressItemModel7.dispose();
    addressItemModel8.dispose();
  }
}
