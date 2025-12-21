import '/client_part/components_client/filter_options/filter_options_widget.dart';
import '/client_part/components_client/service_item/service_item_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'search_results_model.dart';
export 'search_results_model.dart';

class SearchResultsWidget extends StatefulWidget {
  const SearchResultsWidget({super.key});

  static String routeName = 'SearchResults';
  static String routePath = '/searchResults';

  @override
  State<SearchResultsWidget> createState() => _SearchResultsWidgetState();
}

class _SearchResultsWidgetState extends State<SearchResultsWidget> {
  late SearchResultsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchResultsModel());

    _model.searchTextController ??= TextEditingController();
    _model.searchFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {
          _model.searchTextController?.text =
              FFLocalizations.of(context).getText(
            'k4skgcde' /* Cleaning */,
          );
        }));
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
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: Stack(
                    alignment: AlignmentDirectional(1.0, 0.0),
                    children: [
                      Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _model.searchTextController,
                          focusNode: _model.searchFocusNode,
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            isDense: true,
                            labelStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: 'General Sans',
                                  letterSpacing: 0.0,
                                ),
                            hintText: FFLocalizations.of(context).getText(
                              'svof0pzb' /* Try handyman, plumbing, cleani... */,
                            ),
                            hintStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: 'General Sans',
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            contentPadding: EdgeInsetsDirectional.fromSTEB(
                                15.0, 20.0, 53.0, 20.0),
                            prefixIcon: Icon(
                              FFIcons.ksearchNormal01,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 20.0,
                            ),
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                          cursorColor: FlutterFlowTheme.of(context).primaryText,
                          validator: _model.searchTextControllerValidator
                              .asValidator(context),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                        child: FlutterFlowIconButton(
                          borderRadius: 12.0,
                          buttonSize: 40.0,
                          fillColor:
                              FlutterFlowTheme.of(context).primaryBackground,
                          icon: Icon(
                            FFIcons.kfilter5,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 20.0,
                          ),
                          onPressed: () async {
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              useSafeArea: true,
                              context: context,
                              builder: (context) {
                                return GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  child: Padding(
                                    padding: MediaQuery.viewInsetsOf(context),
                                    child: FilterOptionsWidget(),
                                  ),
                                );
                              },
                            ).then((value) => safeSetState(() {}));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: RichText(
                          textScaler: MediaQuery.of(context).textScaler,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: FFLocalizations.of(context).getText(
                                  '7c9ubpqr' /* Results for " */,
                                ),
                                style: TextStyle(),
                              ),
                              TextSpan(
                                text: FFLocalizations.of(context).getText(
                                  '0oj7dr5t' /* Cleaning */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'General Sans',
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              TextSpan(
                                text: FFLocalizations.of(context).getText(
                                  'xpl5x2xz' /* " */,
                                ),
                                style: TextStyle(),
                              )
                            ],
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'General Sans',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ),
                      Text(
                        FFLocalizations.of(context).getText(
                          '83idls8o' /* 281 found */,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'General Sans',
                              color: FlutterFlowTheme.of(context).primary,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ].divide(SizedBox(width: 20.0)),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                  child: GridView(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.7,
                    ),
                    primary: false,
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
                            '14ohhrtf' /* General Cleaning */,
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
                            'xflxcsd2' /* Bedroom Cleaning */,
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
                            'dzgsznux' /* Kitchen Cleaning */,
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
                            'hgf7j01r' /* Bathroom Cleaning */,
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
                            'jccelwo2' /* Deep Cleaning */,
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
                            'hq98g97s' /* Move-in / Move-out Cleaning */,
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
                            '6zeeamye' /* Upholstery and Furniture Clean... */,
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
                            'yfhx7pyw' /* Pet Area Cleaning */,
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
                            'krgsog2e' /* Green Cleaning */,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]
                  .divide(SizedBox(height: 20.0))
                  .addToStart(SizedBox(height: 20.0))
                  .addToEnd(SizedBox(height: 20.0)),
            ),
          ),
        ),
      ),
    );
  }
}
