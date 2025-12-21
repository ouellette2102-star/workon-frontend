import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/counter/counter_widget.dart';
import '/client_part/components_client/radio_btn/radio_btn_widget.dart';
import '/client_part/components_client/service_item_remove/service_item_remove_widget.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'add_information_widget.dart' show AddInformationWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddInformationModel extends FlutterFlowModel<AddInformationWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BackIconBtn component.
  late BackIconBtnModel backIconBtnModel;
  // Model for ServiceItem-Remove component.
  late ServiceItemRemoveModel serviceItemRemoveModel1;
  // Model for ServiceItem-Remove component.
  late ServiceItemRemoveModel serviceItemRemoveModel2;
  // Model for ServiceItem-Remove component.
  late ServiceItemRemoveModel serviceItemRemoveModel3;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // Model for Counter component.
  late CounterModel counterModel1;
  // Model for Counter component.
  late CounterModel counterModel2;
  // Model for Counter component.
  late CounterModel counterModel3;
  // Model for Counter component.
  late CounterModel counterModel4;
  // Model for Counter component.
  late CounterModel counterModel5;
  // Model for Counter component.
  late CounterModel counterModel6;
  // State field(s) for SpaceSize widget.
  String? spaceSizeValue;
  FormFieldController<String>? spaceSizeValueController;
  // State field(s) for SpecialInstructions widget.
  FocusNode? specialInstructionsFocusNode;
  TextEditingController? specialInstructionsTextController;
  String? Function(BuildContext, String?)?
      specialInstructionsTextControllerValidator;
  // Model for RadioBtn component.
  late RadioBtnModel radioBtnModel1;
  // Model for RadioBtn component.
  late RadioBtnModel radioBtnModel2;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
    serviceItemRemoveModel1 =
        createModel(context, () => ServiceItemRemoveModel());
    serviceItemRemoveModel2 =
        createModel(context, () => ServiceItemRemoveModel());
    serviceItemRemoveModel3 =
        createModel(context, () => ServiceItemRemoveModel());
    counterModel1 = createModel(context, () => CounterModel());
    counterModel2 = createModel(context, () => CounterModel());
    counterModel3 = createModel(context, () => CounterModel());
    counterModel4 = createModel(context, () => CounterModel());
    counterModel5 = createModel(context, () => CounterModel());
    counterModel6 = createModel(context, () => CounterModel());
    radioBtnModel1 = createModel(context, () => RadioBtnModel());
    radioBtnModel2 = createModel(context, () => RadioBtnModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    serviceItemRemoveModel1.dispose();
    serviceItemRemoveModel2.dispose();
    serviceItemRemoveModel3.dispose();
    counterModel1.dispose();
    counterModel2.dispose();
    counterModel3.dispose();
    counterModel4.dispose();
    counterModel5.dispose();
    counterModel6.dispose();
    specialInstructionsFocusNode?.dispose();
    specialInstructionsTextController?.dispose();

    radioBtnModel1.dispose();
    radioBtnModel2.dispose();
  }
}
