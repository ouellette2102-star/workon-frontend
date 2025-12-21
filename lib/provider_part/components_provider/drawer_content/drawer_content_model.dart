import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/provider_part/components_provider/provider_navbar_menu/provider_navbar_menu_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'drawer_content_widget.dart' show DrawerContentWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DrawerContentModel extends FlutterFlowModel<DrawerContentWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for ProviderNavbarMenu component.
  late ProviderNavbarMenuModel providerNavbarMenuModel;

  @override
  void initState(BuildContext context) {
    providerNavbarMenuModel =
        createModel(context, () => ProviderNavbarMenuModel());
  }

  @override
  void dispose() {
    providerNavbarMenuModel.dispose();
  }
}
