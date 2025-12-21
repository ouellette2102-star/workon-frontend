import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/provider_part/components_provider/transaction_item/transaction_item_widget.dart';
import 'dart:ui';
import 'transactions_provider_widget.dart' show TransactionsProviderWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TransactionsProviderModel
    extends FlutterFlowModel<TransactionsProviderWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BackIconBtn component.
  late BackIconBtnModel backIconBtnModel;
  // State field(s) for SearchTransactions widget.
  FocusNode? searchTransactionsFocusNode;
  TextEditingController? searchTransactionsTextController;
  String? Function(BuildContext, String?)?
      searchTransactionsTextControllerValidator;
  // Model for TransactionItem component.
  late TransactionItemModel transactionItemModel1;
  // Model for TransactionItem component.
  late TransactionItemModel transactionItemModel2;
  // Model for TransactionItem component.
  late TransactionItemModel transactionItemModel3;
  // Model for TransactionItem component.
  late TransactionItemModel transactionItemModel4;
  // Model for TransactionItem component.
  late TransactionItemModel transactionItemModel5;
  // Model for TransactionItem component.
  late TransactionItemModel transactionItemModel6;
  // Model for TransactionItem component.
  late TransactionItemModel transactionItemModel7;
  // Model for TransactionItem component.
  late TransactionItemModel transactionItemModel8;
  // Model for TransactionItem component.
  late TransactionItemModel transactionItemModel9;
  // Model for TransactionItem component.
  late TransactionItemModel transactionItemModel10;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
    transactionItemModel1 = createModel(context, () => TransactionItemModel());
    transactionItemModel2 = createModel(context, () => TransactionItemModel());
    transactionItemModel3 = createModel(context, () => TransactionItemModel());
    transactionItemModel4 = createModel(context, () => TransactionItemModel());
    transactionItemModel5 = createModel(context, () => TransactionItemModel());
    transactionItemModel6 = createModel(context, () => TransactionItemModel());
    transactionItemModel7 = createModel(context, () => TransactionItemModel());
    transactionItemModel8 = createModel(context, () => TransactionItemModel());
    transactionItemModel9 = createModel(context, () => TransactionItemModel());
    transactionItemModel10 = createModel(context, () => TransactionItemModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    searchTransactionsFocusNode?.dispose();
    searchTransactionsTextController?.dispose();

    transactionItemModel1.dispose();
    transactionItemModel2.dispose();
    transactionItemModel3.dispose();
    transactionItemModel4.dispose();
    transactionItemModel5.dispose();
    transactionItemModel6.dispose();
    transactionItemModel7.dispose();
    transactionItemModel8.dispose();
    transactionItemModel9.dispose();
    transactionItemModel10.dispose();
  }
}
