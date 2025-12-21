import '/client_part/components_client/app_theme/app_theme_widget.dart';
import '/client_part/components_client/check_for_updates/check_for_updates_widget.dart';
import '/client_part/components_client/confirm_logout/confirm_logout_widget.dart';
import '/client_part/components_client/mig_nav_bar/mig_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'account_widget.dart' show AccountWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AccountModel extends FlutterFlowModel<AccountWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for MigNavBar component.
  late MigNavBarModel migNavBarModel;

  @override
  void initState(BuildContext context) {
    migNavBarModel = createModel(context, () => MigNavBarModel());
  }

  @override
  void dispose() {
    migNavBarModel.dispose();
  }
}
