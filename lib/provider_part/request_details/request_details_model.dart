import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/menu_booking_item/menu_booking_item_widget.dart';
import '/client_part/components_client/service_item2/service_item2_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'request_details_widget.dart' show RequestDetailsWidget;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RequestDetailsModel extends FlutterFlowModel<RequestDetailsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BackIconBtn component.
  late BackIconBtnModel backIconBtnModel;
  // Model for ServiceItem2 component.
  late ServiceItem2Model serviceItem2Model1;
  // Model for ServiceItem2 component.
  late ServiceItem2Model serviceItem2Model2;
  // Model for ServiceItem2 component.
  late ServiceItem2Model serviceItem2Model3;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
    serviceItem2Model1 = createModel(context, () => ServiceItem2Model());
    serviceItem2Model2 = createModel(context, () => ServiceItem2Model());
    serviceItem2Model3 = createModel(context, () => ServiceItem2Model());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    serviceItem2Model1.dispose();
    serviceItem2Model2.dispose();
    serviceItem2Model3.dispose();
  }
}
