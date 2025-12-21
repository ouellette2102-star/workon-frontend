import '/client_part/components_client/app_theme/app_theme_widget.dart';
import '/client_part/components_client/read_more_text/read_more_text_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/provider_part/components_provider/drawer_content/drawer_content_widget.dart';
import '/provider_part/components_provider/message_btn/message_btn_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'profile_widget.dart' show ProfileWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileModel extends FlutterFlowModel<ProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for MessageBtn component.
  late MessageBtnModel messageBtnModel;
  // Model for DrawerContent component.
  late DrawerContentModel drawerContentModel;
  // Model for ReadMoreText component.
  late ReadMoreTextModel readMoreTextModel;

  @override
  void initState(BuildContext context) {
    messageBtnModel = createModel(context, () => MessageBtnModel());
    drawerContentModel = createModel(context, () => DrawerContentModel());
    readMoreTextModel = createModel(context, () => ReadMoreTextModel());
  }

  @override
  void dispose() {
    messageBtnModel.dispose();
    drawerContentModel.dispose();
    readMoreTextModel.dispose();
  }
}
