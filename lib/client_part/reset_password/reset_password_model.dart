import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/failed_widget/failed_widget_widget.dart';
import '/client_part/components_client/success_widget/success_widget_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'reset_password_widget.dart' show ResetPasswordWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ResetPasswordModel extends FlutterFlowModel<ResetPasswordWidget> {
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
  // State field(s) for NewPassword widget.
  FocusNode? newPasswordFocusNode;
  TextEditingController? newPasswordTextController;
  late bool newPasswordVisibility;
  String? Function(BuildContext, String?)? newPasswordTextControllerValidator;
  // State field(s) for ConfirmPassword widget.
  FocusNode? confirmPasswordFocusNode;
  TextEditingController? confirmPasswordTextController;
  late bool confirmPasswordVisibility;
  String? Function(BuildContext, String?)?
      confirmPasswordTextControllerValidator;
  // Model for SuccessWidget component.
  late SuccessWidgetModel successWidgetModel;
  // Model for FailedWidget component.
  late FailedWidgetModel failedWidgetModel;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
    pinCodeController = TextEditingController();
    newPasswordVisibility = false;
    confirmPasswordVisibility = false;
    successWidgetModel = createModel(context, () => SuccessWidgetModel());
    failedWidgetModel = createModel(context, () => FailedWidgetModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    emailFocusNode?.dispose();
    emailTextController?.dispose();

    pinCodeFocusNode?.dispose();
    pinCodeController?.dispose();

    newPasswordFocusNode?.dispose();
    newPasswordTextController?.dispose();

    confirmPasswordFocusNode?.dispose();
    confirmPasswordTextController?.dispose();

    successWidgetModel.dispose();
    failedWidgetModel.dispose();
  }
}
