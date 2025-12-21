import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/radio_list_item/radio_list_item_widget.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'interview_user_widget.dart' show InterviewUserWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class InterviewUserModel extends FlutterFlowModel<InterviewUserWidget> {
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
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
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
  // Model for RadioListItem component.
  late RadioListItemModel radioListItemModel9;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  List<String>? get choiceChipsValues => choiceChipsValueController?.value;
  set choiceChipsValues(List<String>? val) =>
      choiceChipsValueController?.value = val;
  // Model for RadioListItem component.
  late RadioListItemModel radioListItemModel10;
  // Model for RadioListItem component.
  late RadioListItemModel radioListItemModel11;
  // Model for RadioListItem component.
  late RadioListItemModel radioListItemModel12;
  // Model for RadioListItem component.
  late RadioListItemModel radioListItemModel13;
  // Model for RadioListItem component.
  late RadioListItemModel radioListItemModel14;
  // Model for RadioListItem component.
  late RadioListItemModel radioListItemModel15;
  // Model for RadioListItem component.
  late RadioListItemModel radioListItemModel16;
  // Model for RadioListItem component.
  late RadioListItemModel radioListItemModel17;
  // Model for RadioListItem component.
  late RadioListItemModel radioListItemModel18;
  // Model for RadioListItem component.
  late RadioListItemModel radioListItemModel19;
  // Model for RadioListItem component.
  late RadioListItemModel radioListItemModel20;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
    radioListItemModel1 = createModel(context, () => RadioListItemModel());
    radioListItemModel2 = createModel(context, () => RadioListItemModel());
    radioListItemModel3 = createModel(context, () => RadioListItemModel());
    radioListItemModel4 = createModel(context, () => RadioListItemModel());
    radioListItemModel5 = createModel(context, () => RadioListItemModel());
    radioListItemModel6 = createModel(context, () => RadioListItemModel());
    radioListItemModel7 = createModel(context, () => RadioListItemModel());
    radioListItemModel8 = createModel(context, () => RadioListItemModel());
    radioListItemModel9 = createModel(context, () => RadioListItemModel());
    radioListItemModel10 = createModel(context, () => RadioListItemModel());
    radioListItemModel11 = createModel(context, () => RadioListItemModel());
    radioListItemModel12 = createModel(context, () => RadioListItemModel());
    radioListItemModel13 = createModel(context, () => RadioListItemModel());
    radioListItemModel14 = createModel(context, () => RadioListItemModel());
    radioListItemModel15 = createModel(context, () => RadioListItemModel());
    radioListItemModel16 = createModel(context, () => RadioListItemModel());
    radioListItemModel17 = createModel(context, () => RadioListItemModel());
    radioListItemModel18 = createModel(context, () => RadioListItemModel());
    radioListItemModel19 = createModel(context, () => RadioListItemModel());
    radioListItemModel20 = createModel(context, () => RadioListItemModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();

    radioListItemModel1.dispose();
    radioListItemModel2.dispose();
    radioListItemModel3.dispose();
    radioListItemModel4.dispose();
    radioListItemModel5.dispose();
    radioListItemModel6.dispose();
    radioListItemModel7.dispose();
    radioListItemModel8.dispose();
    radioListItemModel9.dispose();
    radioListItemModel10.dispose();
    radioListItemModel11.dispose();
    radioListItemModel12.dispose();
    radioListItemModel13.dispose();
    radioListItemModel14.dispose();
    radioListItemModel15.dispose();
    radioListItemModel16.dispose();
    radioListItemModel17.dispose();
    radioListItemModel18.dispose();
    radioListItemModel19.dispose();
    radioListItemModel20.dispose();
  }
}
