import '/client_part/components_client/conversation_item/conversation_item_widget.dart';
import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/provider_part/components_provider/drawer_content/drawer_content_widget.dart';
import '/provider_part/components_provider/job_request_item/job_request_item_widget.dart';
import '/provider_part/components_provider/message_btn/message_btn_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'home_provider_widget.dart' show HomeProviderWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeProviderModel extends FlutterFlowModel<HomeProviderWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for MessageBtn component.
  late MessageBtnModel messageBtnModel;
  // Model for DrawerContent component.
  late DrawerContentModel drawerContentModel;
  // State field(s) for Gender widget.
  String? genderValue;
  FormFieldController<String>? genderValueController;
  // Model for ConversationItem component.
  late ConversationItemModel conversationItemModel1;
  // Model for ConversationItem component.
  late ConversationItemModel conversationItemModel2;
  // Model for ConversationItem component.
  late ConversationItemModel conversationItemModel3;
  // Model for JobRequestItem component.
  late JobRequestItemModel jobRequestItemModel1;
  // Model for JobRequestItem component.
  late JobRequestItemModel jobRequestItemModel2;
  // Model for JobRequestItem component.
  late JobRequestItemModel jobRequestItemModel3;

  @override
  void initState(BuildContext context) {
    messageBtnModel = createModel(context, () => MessageBtnModel());
    drawerContentModel = createModel(context, () => DrawerContentModel());
    conversationItemModel1 =
        createModel(context, () => ConversationItemModel());
    conversationItemModel2 =
        createModel(context, () => ConversationItemModel());
    conversationItemModel3 =
        createModel(context, () => ConversationItemModel());
    jobRequestItemModel1 = createModel(context, () => JobRequestItemModel());
    jobRequestItemModel2 = createModel(context, () => JobRequestItemModel());
    jobRequestItemModel3 = createModel(context, () => JobRequestItemModel());
  }

  @override
  void dispose() {
    messageBtnModel.dispose();
    drawerContentModel.dispose();
    conversationItemModel1.dispose();
    conversationItemModel2.dispose();
    conversationItemModel3.dispose();
    jobRequestItemModel1.dispose();
    jobRequestItemModel2.dispose();
    jobRequestItemModel3.dispose();
  }
}
