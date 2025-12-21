import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/provider_part/components_provider/availability_item/availability_item_widget.dart';
import 'dart:ui';
import 'availability_widget.dart' show AvailabilityWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AvailabilityModel extends FlutterFlowModel<AvailabilityWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BackIconBtn component.
  late BackIconBtnModel backIconBtnModel;
  // State field(s) for VacationSwitch widget.
  bool? vacationSwitchValue;
  // Model for AvailabilityItem component.
  late AvailabilityItemModel availabilityItemModel1;
  // Model for AvailabilityItem component.
  late AvailabilityItemModel availabilityItemModel2;
  // Model for AvailabilityItem component.
  late AvailabilityItemModel availabilityItemModel3;
  // Model for AvailabilityItem component.
  late AvailabilityItemModel availabilityItemModel4;
  // Model for AvailabilityItem component.
  late AvailabilityItemModel availabilityItemModel5;
  // Model for AvailabilityItem component.
  late AvailabilityItemModel availabilityItemModel6;
  // Model for AvailabilityItem component.
  late AvailabilityItemModel availabilityItemModel7;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
    availabilityItemModel1 =
        createModel(context, () => AvailabilityItemModel());
    availabilityItemModel2 =
        createModel(context, () => AvailabilityItemModel());
    availabilityItemModel3 =
        createModel(context, () => AvailabilityItemModel());
    availabilityItemModel4 =
        createModel(context, () => AvailabilityItemModel());
    availabilityItemModel5 =
        createModel(context, () => AvailabilityItemModel());
    availabilityItemModel6 =
        createModel(context, () => AvailabilityItemModel());
    availabilityItemModel7 =
        createModel(context, () => AvailabilityItemModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    availabilityItemModel1.dispose();
    availabilityItemModel2.dispose();
    availabilityItemModel3.dispose();
    availabilityItemModel4.dispose();
    availabilityItemModel5.dispose();
    availabilityItemModel6.dispose();
    availabilityItemModel7.dispose();
  }
}
