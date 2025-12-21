import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/provider_part/components_provider/transaction_item/transaction_item_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'transactions_provider_model.dart';
export 'transactions_provider_model.dart';

class TransactionsProviderWidget extends StatefulWidget {
  const TransactionsProviderWidget({super.key});

  static String routeName = 'Transactions-Provider';
  static String routePath = '/transactionsProvider';

  @override
  State<TransactionsProviderWidget> createState() =>
      _TransactionsProviderWidgetState();
}

class _TransactionsProviderWidgetState
    extends State<TransactionsProviderWidget> {
  late TransactionsProviderModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TransactionsProviderModel());

    _model.searchTransactionsTextController ??= TextEditingController();
    _model.searchTransactionsFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    wrapWithModel(
                      model: _model.backIconBtnModel,
                      updateCallback: () => safeSetState(() {}),
                      child: BackIconBtnWidget(),
                    ),
                    Flexible(
                      child: Text(
                        FFLocalizations.of(context).getText(
                          'xpr2ycgy' /* Transactions */,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'General Sans',
                              fontSize: 20.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ].divide(SizedBox(width: 15.0)),
                ),
              ),
              FlutterFlowIconButton(
                borderRadius: 14.0,
                buttonSize: 40.0,
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                icon: Icon(
                  Icons.more_vert_sharp,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                onPressed: () {
                  print('IconButton pressed ...');
                },
              ),
            ].divide(SizedBox(width: 15.0)),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    child: TextFormField(
                      controller: _model.searchTransactionsTextController,
                      focusNode: _model.searchTransactionsFocusNode,
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'General Sans',
                                  letterSpacing: 0.0,
                                ),
                        hintText: FFLocalizations.of(context).getText(
                          'io6dnnq3' /* Search transactions */,
                        ),
                        hintStyle:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'General Sans',
                                  fontSize: 13.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        contentPadding: EdgeInsetsDirectional.fromSTEB(
                            15.0, 18.0, 53.0, 18.0),
                        prefixIcon: Icon(
                          FFIcons.ksearchNormal01,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 16.0,
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'General Sans',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                      cursorColor: FlutterFlowTheme.of(context).primaryText,
                      validator: _model
                          .searchTransactionsTextControllerValidator
                          .asValidator(context),
                    ),
                  ),
                  Wrap(
                    spacing: 0.0,
                    runSpacing: 10.0,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    runAlignment: WrapAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    clipBehavior: Clip.none,
                    children: [
                      wrapWithModel(
                        model: _model.transactionItemModel1,
                        updateCallback: () => safeSetState(() {}),
                        child: TransactionItemWidget(),
                      ),
                      wrapWithModel(
                        model: _model.transactionItemModel2,
                        updateCallback: () => safeSetState(() {}),
                        child: TransactionItemWidget(),
                      ),
                      wrapWithModel(
                        model: _model.transactionItemModel3,
                        updateCallback: () => safeSetState(() {}),
                        child: TransactionItemWidget(),
                      ),
                      wrapWithModel(
                        model: _model.transactionItemModel4,
                        updateCallback: () => safeSetState(() {}),
                        child: TransactionItemWidget(),
                      ),
                      wrapWithModel(
                        model: _model.transactionItemModel5,
                        updateCallback: () => safeSetState(() {}),
                        child: TransactionItemWidget(),
                      ),
                      wrapWithModel(
                        model: _model.transactionItemModel6,
                        updateCallback: () => safeSetState(() {}),
                        child: TransactionItemWidget(),
                      ),
                      wrapWithModel(
                        model: _model.transactionItemModel7,
                        updateCallback: () => safeSetState(() {}),
                        child: TransactionItemWidget(),
                      ),
                      wrapWithModel(
                        model: _model.transactionItemModel8,
                        updateCallback: () => safeSetState(() {}),
                        child: TransactionItemWidget(),
                      ),
                      wrapWithModel(
                        model: _model.transactionItemModel9,
                        updateCallback: () => safeSetState(() {}),
                        child: TransactionItemWidget(),
                      ),
                      wrapWithModel(
                        model: _model.transactionItemModel10,
                        updateCallback: () => safeSetState(() {}),
                        child: TransactionItemWidget(),
                      ),
                    ],
                  ),
                ]
                    .divide(SizedBox(height: 20.0))
                    .addToStart(SizedBox(height: 20.0))
                    .addToEnd(SizedBox(height: 50.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
