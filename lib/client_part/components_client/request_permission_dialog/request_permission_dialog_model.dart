import '/client_part/components_client/circle_wraper/circle_wraper_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'request_permission_dialog_widget.dart'
    show RequestPermissionDialogWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RequestPermissionDialogModel
    extends FlutterFlowModel<RequestPermissionDialogWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for CircleWraper component.
  late CircleWraperModel circleWraperModel;

  @override
  void initState(BuildContext context) {
    circleWraperModel = createModel(context, () => CircleWraperModel());
  }

  @override
  void dispose() {
    circleWraperModel.dispose();
  }
}
