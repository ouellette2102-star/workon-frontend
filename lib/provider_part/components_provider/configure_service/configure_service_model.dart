import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'configure_service_widget.dart' show ConfigureServiceWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ConfigureServiceModel extends FlutterFlowModel<ConfigureServiceWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Years widget.
  String? yearsValue;
  FormFieldController<String>? yearsValueController;
  // State field(s) for Tools widget.
  String? toolsValue;
  FormFieldController<String>? toolsValueController;
  // State field(s) for Rate widget.
  FocusNode? rateFocusNode;
  TextEditingController? rateTextController;
  String? Function(BuildContext, String?)? rateTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    rateFocusNode?.dispose();
    rateTextController?.dispose();
  }
}
