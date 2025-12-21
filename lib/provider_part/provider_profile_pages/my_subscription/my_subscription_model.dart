import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'my_subscription_widget.dart' show MySubscriptionWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MySubscriptionModel extends FlutterFlowModel<MySubscriptionWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BackIconBtn component.
  late BackIconBtnModel backIconBtnModel;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
  }
}
