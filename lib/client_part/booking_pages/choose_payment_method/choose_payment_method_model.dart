import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/radio_btn/radio_btn_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'choose_payment_method_widget.dart' show ChoosePaymentMethodWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChoosePaymentMethodModel
    extends FlutterFlowModel<ChoosePaymentMethodWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BackIconBtn component.
  late BackIconBtnModel backIconBtnModel;
  // Model for RadioBtn component.
  late RadioBtnModel radioBtnModel1;
  // Model for RadioBtn component.
  late RadioBtnModel radioBtnModel2;
  // Model for RadioBtn component.
  late RadioBtnModel radioBtnModel3;
  // Model for RadioBtn component.
  late RadioBtnModel radioBtnModel4;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
    radioBtnModel1 = createModel(context, () => RadioBtnModel());
    radioBtnModel2 = createModel(context, () => RadioBtnModel());
    radioBtnModel3 = createModel(context, () => RadioBtnModel());
    radioBtnModel4 = createModel(context, () => RadioBtnModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    radioBtnModel1.dispose();
    radioBtnModel2.dispose();
    radioBtnModel3.dispose();
    radioBtnModel4.dispose();
  }
}
