import '/client_part/components_client/filter_options/filter_options_widget.dart';
import '/client_part/components_client/service_item2/service_item2_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'search_widget.dart' show SearchWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SearchModel extends FlutterFlowModel<SearchWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Search widget.
  FocusNode? searchFocusNode;
  TextEditingController? searchTextController;
  String? Function(BuildContext, String?)? searchTextControllerValidator;
  // Model for ServiceItem2 component.
  late ServiceItem2Model serviceItem2Model1;
  // Model for ServiceItem2 component.
  late ServiceItem2Model serviceItem2Model2;
  // Model for ServiceItem2 component.
  late ServiceItem2Model serviceItem2Model3;

  @override
  void initState(BuildContext context) {
    serviceItem2Model1 = createModel(context, () => ServiceItem2Model());
    serviceItem2Model2 = createModel(context, () => ServiceItem2Model());
    serviceItem2Model3 = createModel(context, () => ServiceItem2Model());
  }

  @override
  void dispose() {
    searchFocusNode?.dispose();
    searchTextController?.dispose();

    serviceItem2Model1.dispose();
    serviceItem2Model2.dispose();
    serviceItem2Model3.dispose();
  }
}
