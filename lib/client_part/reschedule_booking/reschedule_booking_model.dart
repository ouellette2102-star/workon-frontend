import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/failed_widget/failed_widget_widget.dart';
import '/client_part/components_client/radio_list_item/radio_list_item_widget.dart';
import '/client_part/components_client/success_widget/success_widget_widget.dart';
import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'reschedule_booking_widget.dart' show RescheduleBookingWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RescheduleBookingModel extends FlutterFlowModel<RescheduleBookingWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BackIconBtn component.
  late BackIconBtnModel backIconBtnModel;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // State field(s) for Calendar widget.
  DateTimeRange? calendarSelectedDay;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  List<String>? get choiceChipsValues => choiceChipsValueController?.value;
  set choiceChipsValues(List<String>? val) =>
      choiceChipsValueController?.value = val;
  // Model for RadioListItem component.
  late RadioListItemModel radioListItemModel1;
  // Model for RadioListItem component.
  late RadioListItemModel radioListItemModel2;
  // Model for RadioListItem component.
  late RadioListItemModel radioListItemModel3;
  // Model for RadioListItem component.
  late RadioListItemModel radioListItemModel4;
  // Model for RadioListItem component.
  late RadioListItemModel radioListItemModel5;
  // Model for RadioListItem component.
  late RadioListItemModel radioListItemModel6;
  // Model for RadioListItem component.
  late RadioListItemModel radioListItemModel7;
  // Model for RadioListItem component.
  late RadioListItemModel radioListItemModel8;
  // State field(s) for RescheduleMessage widget.
  FocusNode? rescheduleMessageFocusNode;
  TextEditingController? rescheduleMessageTextController;
  String? Function(BuildContext, String?)?
      rescheduleMessageTextControllerValidator;
  // Model for SuccessWidget component.
  late SuccessWidgetModel successWidgetModel;
  // Model for FailedWidget component.
  late FailedWidgetModel failedWidgetModel;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
    calendarSelectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );
    radioListItemModel1 = createModel(context, () => RadioListItemModel());
    radioListItemModel2 = createModel(context, () => RadioListItemModel());
    radioListItemModel3 = createModel(context, () => RadioListItemModel());
    radioListItemModel4 = createModel(context, () => RadioListItemModel());
    radioListItemModel5 = createModel(context, () => RadioListItemModel());
    radioListItemModel6 = createModel(context, () => RadioListItemModel());
    radioListItemModel7 = createModel(context, () => RadioListItemModel());
    radioListItemModel8 = createModel(context, () => RadioListItemModel());
    successWidgetModel = createModel(context, () => SuccessWidgetModel());
    failedWidgetModel = createModel(context, () => FailedWidgetModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    radioListItemModel1.dispose();
    radioListItemModel2.dispose();
    radioListItemModel3.dispose();
    radioListItemModel4.dispose();
    radioListItemModel5.dispose();
    radioListItemModel6.dispose();
    radioListItemModel7.dispose();
    radioListItemModel8.dispose();
    rescheduleMessageFocusNode?.dispose();
    rescheduleMessageTextController?.dispose();

    successWidgetModel.dispose();
    failedWidgetModel.dispose();
  }
}
