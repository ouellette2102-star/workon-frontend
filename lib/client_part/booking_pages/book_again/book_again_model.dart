import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/failed_widget/failed_widget_widget.dart';
import '/client_part/components_client/service_item_remove/service_item_remove_widget.dart';
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
import 'book_again_widget.dart' show BookAgainWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BookAgainModel extends FlutterFlowModel<BookAgainWidget> {
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
  // Model for ServiceItem-Remove component.
  late ServiceItemRemoveModel serviceItemRemoveModel1;
  // Model for ServiceItem-Remove component.
  late ServiceItemRemoveModel serviceItemRemoveModel2;
  // Model for ServiceItem-Remove component.
  late ServiceItemRemoveModel serviceItemRemoveModel3;
  // State field(s) for AddPromo widget.
  FocusNode? addPromoFocusNode;
  TextEditingController? addPromoTextController;
  String? Function(BuildContext, String?)? addPromoTextControllerValidator;
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
    serviceItemRemoveModel1 =
        createModel(context, () => ServiceItemRemoveModel());
    serviceItemRemoveModel2 =
        createModel(context, () => ServiceItemRemoveModel());
    serviceItemRemoveModel3 =
        createModel(context, () => ServiceItemRemoveModel());
    successWidgetModel = createModel(context, () => SuccessWidgetModel());
    failedWidgetModel = createModel(context, () => FailedWidgetModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    serviceItemRemoveModel1.dispose();
    serviceItemRemoveModel2.dispose();
    serviceItemRemoveModel3.dispose();
    addPromoFocusNode?.dispose();
    addPromoTextController?.dispose();

    successWidgetModel.dispose();
    failedWidgetModel.dispose();
  }
}
