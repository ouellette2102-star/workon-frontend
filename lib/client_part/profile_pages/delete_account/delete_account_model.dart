import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/failed_widget/failed_widget_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'delete_account_widget.dart' show DeleteAccountWidget;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DeleteAccountModel extends FlutterFlowModel<DeleteAccountWidget> {
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
  // State field(s) for Email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  FocusNode? pinCodeFocusNode;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;
  // State field(s) for Checkbox widget.
  bool? checkboxValue1;
  // State field(s) for Checkbox widget.
  bool? checkboxValue2;
  // Model for FailedWidget component.
  late FailedWidgetModel failedWidgetModel;
  
  // PR-F2: Confirm text field and loading state
  FocusNode? confirmFocusNode;
  TextEditingController? confirmTextController;
  bool isLoading = false;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
    pinCodeController = TextEditingController();
    failedWidgetModel = createModel(context, () => FailedWidgetModel());
    confirmTextController = TextEditingController();
    confirmFocusNode = FocusNode();
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    emailFocusNode?.dispose();
    emailTextController?.dispose();

    pinCodeFocusNode?.dispose();
    pinCodeController?.dispose();
    
    confirmFocusNode?.dispose();
    confirmTextController?.dispose();

    failedWidgetModel.dispose();
  }
}
