import '/client_part/components_client/radio_btn/radio_btn_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'radio_list_item_widget.dart' show RadioListItemWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RadioListItemModel extends FlutterFlowModel<RadioListItemWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for RadioBtn component.
  late RadioBtnModel radioBtnModel;

  @override
  void initState(BuildContext context) {
    radioBtnModel = createModel(context, () => RadioBtnModel());
  }

  @override
  void dispose() {
    radioBtnModel.dispose();
  }
}
