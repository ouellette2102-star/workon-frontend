import '/client_part/components_client/address_item/address_item_widget.dart';
import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'my_address_model.dart';
export 'my_address_model.dart';

class MyAddressWidget extends StatefulWidget {
  const MyAddressWidget({super.key});

  static String routeName = 'MyAddress';
  static String routePath = '/myAddress';

  @override
  State<MyAddressWidget> createState() => _MyAddressWidgetState();
}

class _MyAddressWidgetState extends State<MyAddressWidget> {
  late MyAddressModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyAddressModel());
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
                          '8vwjh4lv' /* My Address */,
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
                borderRadius: 12.0,
                buttonSize: 40.0,
                icon: Icon(
                  FFIcons.kadd,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                onPressed: () async {
                  context.pushNamed(AddNewAddressWidget.routeName);
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
                  Wrap(
                    spacing: 0.0,
                    runSpacing: 20.0,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    runAlignment: WrapAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    clipBehavior: Clip.none,
                    children: [
                      wrapWithModel(
                        model: _model.addressItemModel1,
                        updateCallback: () => safeSetState(() {}),
                        child: AddressItemWidget(
                          isDefault: true,
                        ),
                      ),
                      wrapWithModel(
                        model: _model.addressItemModel2,
                        updateCallback: () => safeSetState(() {}),
                        child: AddressItemWidget(
                          isDefault: false,
                        ),
                      ),
                      wrapWithModel(
                        model: _model.addressItemModel3,
                        updateCallback: () => safeSetState(() {}),
                        child: AddressItemWidget(
                          isDefault: false,
                        ),
                      ),
                      wrapWithModel(
                        model: _model.addressItemModel4,
                        updateCallback: () => safeSetState(() {}),
                        child: AddressItemWidget(
                          isDefault: false,
                        ),
                      ),
                      wrapWithModel(
                        model: _model.addressItemModel5,
                        updateCallback: () => safeSetState(() {}),
                        child: AddressItemWidget(
                          isDefault: false,
                        ),
                      ),
                      wrapWithModel(
                        model: _model.addressItemModel6,
                        updateCallback: () => safeSetState(() {}),
                        child: AddressItemWidget(
                          isDefault: false,
                        ),
                      ),
                      wrapWithModel(
                        model: _model.addressItemModel7,
                        updateCallback: () => safeSetState(() {}),
                        child: AddressItemWidget(
                          isDefault: false,
                        ),
                      ),
                      wrapWithModel(
                        model: _model.addressItemModel8,
                        updateCallback: () => safeSetState(() {}),
                        child: AddressItemWidget(
                          isDefault: false,
                        ),
                      ),
                    ],
                  ),
                ]
                    .divide(SizedBox(height: 20.0))
                    .addToStart(SizedBox(height: 20.0))
                    .addToEnd(SizedBox(height: 20.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
