import '/client_part/components_client/select_service_item/select_service_item_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'service_item_select_widget.dart' show ServiceItemSelectWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ServiceItemSelectModel extends FlutterFlowModel<ServiceItemSelectWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for SelectServiceItem component.
  late SelectServiceItemModel selectServiceItemModel;

  @override
  void initState(BuildContext context) {
    selectServiceItemModel =
        createModel(context, () => SelectServiceItemModel());
  }

  @override
  void dispose() {
    selectServiceItemModel.dispose();
  }
}
