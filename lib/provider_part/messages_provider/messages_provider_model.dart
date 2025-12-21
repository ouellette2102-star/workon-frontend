import '/client_part/components_client/conversation_item/conversation_item_widget.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/provider_part/components_provider/drawer_content/drawer_content_widget.dart';
import 'dart:ui';
import 'messages_provider_widget.dart' show MessagesProviderWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MessagesProviderModel extends FlutterFlowModel<MessagesProviderWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for DrawerContent component.
  late DrawerContentModel drawerContentModel;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  List<String>? get choiceChipsValues => choiceChipsValueController?.value;
  set choiceChipsValues(List<String>? val) =>
      choiceChipsValueController?.value = val;
  // Model for ConversationItem component.
  late ConversationItemModel conversationItemModel1;
  // Model for ConversationItem component.
  late ConversationItemModel conversationItemModel2;
  // Model for ConversationItem component.
  late ConversationItemModel conversationItemModel3;
  // Model for ConversationItem component.
  late ConversationItemModel conversationItemModel4;
  // Model for ConversationItem component.
  late ConversationItemModel conversationItemModel5;
  // Model for ConversationItem component.
  late ConversationItemModel conversationItemModel6;
  // Model for ConversationItem component.
  late ConversationItemModel conversationItemModel7;
  // Model for ConversationItem component.
  late ConversationItemModel conversationItemModel8;
  // Model for ConversationItem component.
  late ConversationItemModel conversationItemModel9;
  // Model for ConversationItem component.
  late ConversationItemModel conversationItemModel10;
  // Model for ConversationItem component.
  late ConversationItemModel conversationItemModel11;

  @override
  void initState(BuildContext context) {
    drawerContentModel = createModel(context, () => DrawerContentModel());
    conversationItemModel1 =
        createModel(context, () => ConversationItemModel());
    conversationItemModel2 =
        createModel(context, () => ConversationItemModel());
    conversationItemModel3 =
        createModel(context, () => ConversationItemModel());
    conversationItemModel4 =
        createModel(context, () => ConversationItemModel());
    conversationItemModel5 =
        createModel(context, () => ConversationItemModel());
    conversationItemModel6 =
        createModel(context, () => ConversationItemModel());
    conversationItemModel7 =
        createModel(context, () => ConversationItemModel());
    conversationItemModel8 =
        createModel(context, () => ConversationItemModel());
    conversationItemModel9 =
        createModel(context, () => ConversationItemModel());
    conversationItemModel10 =
        createModel(context, () => ConversationItemModel());
    conversationItemModel11 =
        createModel(context, () => ConversationItemModel());
  }

  @override
  void dispose() {
    drawerContentModel.dispose();
    conversationItemModel1.dispose();
    conversationItemModel2.dispose();
    conversationItemModel3.dispose();
    conversationItemModel4.dispose();
    conversationItemModel5.dispose();
    conversationItemModel6.dispose();
    conversationItemModel7.dispose();
    conversationItemModel8.dispose();
    conversationItemModel9.dispose();
    conversationItemModel10.dispose();
    conversationItemModel11.dispose();
  }
}
