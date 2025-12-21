import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/provider_part/components_provider/drawer_content/drawer_content_widget.dart';
import '/provider_part/components_provider/message_btn/message_btn_widget.dart';
import '/provider_part/components_provider/provider_service_item/provider_service_item_widget.dart';
import 'dart:ui';
import 'services_widget.dart' show ServicesWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ServicesModel extends FlutterFlowModel<ServicesWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for MessageBtn component.
  late MessageBtnModel messageBtnModel;
  // Model for DrawerContent component.
  late DrawerContentModel drawerContentModel;
  // Model for ProviderServiceItem component.
  late ProviderServiceItemModel providerServiceItemModel1;
  // Model for ProviderServiceItem component.
  late ProviderServiceItemModel providerServiceItemModel2;
  // Model for ProviderServiceItem component.
  late ProviderServiceItemModel providerServiceItemModel3;
  // Model for ProviderServiceItem component.
  late ProviderServiceItemModel providerServiceItemModel4;

  @override
  void initState(BuildContext context) {
    messageBtnModel = createModel(context, () => MessageBtnModel());
    drawerContentModel = createModel(context, () => DrawerContentModel());
    providerServiceItemModel1 =
        createModel(context, () => ProviderServiceItemModel());
    providerServiceItemModel2 =
        createModel(context, () => ProviderServiceItemModel());
    providerServiceItemModel3 =
        createModel(context, () => ProviderServiceItemModel());
    providerServiceItemModel4 =
        createModel(context, () => ProviderServiceItemModel());
  }

  @override
  void dispose() {
    messageBtnModel.dispose();
    drawerContentModel.dispose();
    providerServiceItemModel1.dispose();
    providerServiceItemModel2.dispose();
    providerServiceItemModel3.dispose();
    providerServiceItemModel4.dispose();
  }
}
