import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/provider_part/components_provider/drawer_content/drawer_content_widget.dart';
import '/provider_part/components_provider/message_btn/message_btn_widget.dart';
import '/provider_part/components_provider/transaction_item/transaction_item_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'earnings_widget.dart' show EarningsWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EarningsModel extends FlutterFlowModel<EarningsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for MessageBtn component.
  late MessageBtnModel messageBtnModel;
  // Model for DrawerContent component.
  late DrawerContentModel drawerContentModel;
  // State field(s) for Gender widget.
  String? genderValue;
  FormFieldController<String>? genderValueController;
  // Model for TransactionItem component.
  late TransactionItemModel transactionItemModel1;
  // Model for TransactionItem component.
  late TransactionItemModel transactionItemModel2;
  // Model for TransactionItem component.
  late TransactionItemModel transactionItemModel3;
  // Model for TransactionItem component.
  late TransactionItemModel transactionItemModel4;

  @override
  void initState(BuildContext context) {
    messageBtnModel = createModel(context, () => MessageBtnModel());
    drawerContentModel = createModel(context, () => DrawerContentModel());
    transactionItemModel1 = createModel(context, () => TransactionItemModel());
    transactionItemModel2 = createModel(context, () => TransactionItemModel());
    transactionItemModel3 = createModel(context, () => TransactionItemModel());
    transactionItemModel4 = createModel(context, () => TransactionItemModel());
  }

  @override
  void dispose() {
    messageBtnModel.dispose();
    drawerContentModel.dispose();
    transactionItemModel1.dispose();
    transactionItemModel2.dispose();
    transactionItemModel3.dispose();
    transactionItemModel4.dispose();
  }
}
