import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/menu_booking_item/menu_booking_item_widget.dart';
import '/client_part/components_client/reject_booking_request/reject_booking_request_widget.dart';
import '/client_part/components_client/service_item2/service_item2_widget.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'booking_details_widget.dart' show BookingDetailsWidget;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BookingDetailsModel extends FlutterFlowModel<BookingDetailsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BackIconBtn component.
  late BackIconBtnModel backIconBtnModel;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Model for ServiceItem2 component.
  late ServiceItem2Model serviceItem2Model1;
  // Model for ServiceItem2 component.
  late ServiceItem2Model serviceItem2Model2;
  // Model for ServiceItem2 component.
  late ServiceItem2Model serviceItem2Model3;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController1;

  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController2;

  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController3;

  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController4;

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
    tabBarController?.dispose();
    serviceItem2Model1.dispose();
    serviceItem2Model2.dispose();
    serviceItem2Model3.dispose();
    expandableExpandableController1.dispose();
    expandableExpandableController2.dispose();
    expandableExpandableController3.dispose();
    expandableExpandableController4.dispose();
  }
}
