import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'reject_booking_request_widget.dart' show RejectBookingRequestWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RejectBookingRequestModel
    extends FlutterFlowModel<RejectBookingRequestWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for RejectMessage widget.
  FocusNode? rejectMessageFocusNode;
  TextEditingController? rejectMessageTextController;
  String? Function(BuildContext, String?)? rejectMessageTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    rejectMessageFocusNode?.dispose();
    rejectMessageTextController?.dispose();
  }
}
