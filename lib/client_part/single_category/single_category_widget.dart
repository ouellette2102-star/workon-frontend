import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/search_btn/search_btn_widget.dart';
import '/client_part/components_client/service_item/service_item_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'single_category_model.dart';
export 'single_category_model.dart';

class SingleCategoryWidget extends StatefulWidget {
  const SingleCategoryWidget({super.key});

  static String routeName = 'SingleCategory';
  static String routePath = '/singleCategory';

  @override
  State<SingleCategoryWidget> createState() => _SingleCategoryWidgetState();
}

class _SingleCategoryWidgetState extends State<SingleCategoryWidget> {
  late SingleCategoryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SingleCategoryModel());
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
              wrapWithModel(
                model: _model.backIconBtnModel,
                updateCallback: () => safeSetState(() {}),
                child: BackIconBtnWidget(),
              ),
              Flexible(
                child: Text(
                  FFLocalizations.of(context).getText(
                    'pgh7pxu4' /* Popular Services 🔥 */,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'General Sans',
                        fontSize: 20.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              wrapWithModel(
                model: _model.searchBtnModel,
                updateCallback: () => safeSetState(() {}),
                child: SearchBtnWidget(),
              ),
            ].divide(SizedBox(width: 20.0)),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
            child: GridView(
              padding: EdgeInsets.fromLTRB(
                0,
                20.0,
                0,
                20.0,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.7,
              ),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                wrapWithModel(
                  model: _model.serviceItemModel1,
                  updateCallback: () => safeSetState(() {}),
                  child: ServiceItemWidget(
                    img:
                        'https://plus.unsplash.com/premium_photo-1664301014580-9d9941d1fb51?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8R2VuZXJhbCUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                    title: FFLocalizations.of(context).getText(
                      'dgyxehnw' /* General Cleaning */,
                    ),
                  ),
                ),
                wrapWithModel(
                  model: _model.serviceItemModel2,
                  updateCallback: () => safeSetState(() {}),
                  child: ServiceItemWidget(
                    img:
                        'https://plus.unsplash.com/premium_photo-1677683510057-cc85159ee770?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fEJlZHJvb20lMjBDbGVhbmluZ3xlbnwwfHwwfHx8MA%3D%3D',
                    title: FFLocalizations.of(context).getText(
                      'cfgwdayf' /* Bedroom Cleaning */,
                    ),
                  ),
                ),
                wrapWithModel(
                  model: _model.serviceItemModel3,
                  updateCallback: () => safeSetState(() {}),
                  child: ServiceItemWidget(
                    img:
                        'https://plus.unsplash.com/premium_photo-1679500354595-0feead204a28?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8S2l0Y2hlbiUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                    title: FFLocalizations.of(context).getText(
                      'ww7xhrbb' /* Kitchen Cleaning */,
                    ),
                  ),
                ),
                wrapWithModel(
                  model: _model.serviceItemModel4,
                  updateCallback: () => safeSetState(() {}),
                  child: ServiceItemWidget(
                    img:
                        'https://plus.unsplash.com/premium_photo-1664372899354-99e6d9f50f58?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fEJhdGhyb29tJTIwQ2xlYW5pbmd8ZW58MHx8MHx8fDA%3D',
                    title: FFLocalizations.of(context).getText(
                      'rjvstf6n' /* Bathroom Cleaning */,
                    ),
                  ),
                ),
                wrapWithModel(
                  model: _model.serviceItemModel5,
                  updateCallback: () => safeSetState(() {}),
                  child: ServiceItemWidget(
                    img:
                        'https://plus.unsplash.com/premium_photo-1679500355493-2a1ce67cb938?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8RGVlcCUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                    title: FFLocalizations.of(context).getText(
                      'xu74yv88' /* Deep Cleaning */,
                    ),
                  ),
                ),
                wrapWithModel(
                  model: _model.serviceItemModel6,
                  updateCallback: () => safeSetState(() {}),
                  child: ServiceItemWidget(
                    img:
                        'https://images.unsplash.com/photo-1714647211955-95c3104dc418?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8TW92ZSUyMGluJTIwJTJGJTIwTW92ZSUyMG91dCUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                    title: FFLocalizations.of(context).getText(
                      '3p2fcvy1' /* Move-in / Move-out Cleaning */,
                    ),
                  ),
                ),
                wrapWithModel(
                  model: _model.serviceItemModel7,
                  updateCallback: () => safeSetState(() {}),
                  child: ServiceItemWidget(
                    img:
                        'https://plus.unsplash.com/premium_photo-1678718606857-d4820cecc9bf?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8VXBob2xzdGVyeSUyMGFuZCUyMEZ1cm5pdHVyZSUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                    title: FFLocalizations.of(context).getText(
                      'hbxo77n1' /* Upholstery and Furniture Clean... */,
                    ),
                  ),
                ),
                wrapWithModel(
                  model: _model.serviceItemModel8,
                  updateCallback: () => safeSetState(() {}),
                  child: ServiceItemWidget(
                    img:
                        'https://images.unsplash.com/photo-1686479037314-88bc3732de16?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8UGV0JTIwQXJlYSUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                    title: FFLocalizations.of(context).getText(
                      'jomuqv4m' /* Pet Area Cleaning */,
                    ),
                  ),
                ),
                wrapWithModel(
                  model: _model.serviceItemModel9,
                  updateCallback: () => safeSetState(() {}),
                  child: ServiceItemWidget(
                    img:
                        'https://plus.unsplash.com/premium_photo-1684407616444-d52caf1a828f?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8R3JlZW4lMjBDbGVhbmluZ3xlbnwwfHwwfHx8MA%3D%3D',
                    title: FFLocalizations.of(context).getText(
                      'e0n7q3xa' /* Green Cleaning */,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
