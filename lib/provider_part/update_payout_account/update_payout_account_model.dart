import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/failed_widget/failed_widget_widget.dart';
import '/client_part/components_client/success_widget/success_widget_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'update_payout_account_widget.dart' show UpdatePayoutAccountWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UpdatePayoutAccountModel
    extends FlutterFlowModel<UpdatePayoutAccountWidget> {
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
  // State field(s) for AccountNumber widget.
  FocusNode? accountNumberFocusNode1;
  TextEditingController? accountNumberTextController1;
  String? Function(BuildContext, String?)?
      accountNumberTextController1Validator;
  // State field(s) for SearchBank widget.
  FocusNode? searchBankFocusNode;
  TextEditingController? searchBankTextController;
  String? Function(BuildContext, String?)? searchBankTextControllerValidator;
  // State field(s) for AccountHolderName widget.
  FocusNode? accountHolderNameFocusNode;
  TextEditingController? accountHolderNameTextController;
  String? Function(BuildContext, String?)?
      accountHolderNameTextControllerValidator;
  // State field(s) for AccountNumber widget.
  FocusNode? accountNumberFocusNode2;
  TextEditingController? accountNumberTextController2;
  String? Function(BuildContext, String?)?
      accountNumberTextController2Validator;
  // Model for SuccessWidget component.
  late SuccessWidgetModel successWidgetModel;
  // Model for FailedWidget component.
  late FailedWidgetModel failedWidgetModel;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
    successWidgetModel = createModel(context, () => SuccessWidgetModel());
    failedWidgetModel = createModel(context, () => FailedWidgetModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    accountNumberFocusNode1?.dispose();
    accountNumberTextController1?.dispose();

    searchBankFocusNode?.dispose();
    searchBankTextController?.dispose();

    accountHolderNameFocusNode?.dispose();
    accountHolderNameTextController?.dispose();

    accountNumberFocusNode2?.dispose();
    accountNumberTextController2?.dispose();

    successWidgetModel.dispose();
    failedWidgetModel.dispose();
  }
}
