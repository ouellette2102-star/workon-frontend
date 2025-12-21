import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/search_btn/search_btn_widget.dart';
import '/client_part/components_client/service_item3/service_item3_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bookmarks_model.dart';
export 'bookmarks_model.dart';

class BookmarksWidget extends StatefulWidget {
  const BookmarksWidget({super.key});

  static String routeName = 'Bookmarks';
  static String routePath = '/bookmarks';

  @override
  State<BookmarksWidget> createState() => _BookmarksWidgetState();
}

class _BookmarksWidgetState extends State<BookmarksWidget> {
  late BookmarksModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BookmarksModel());
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
                    'nr7ljar0' /* My Bookmarks */,
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
            padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Wrap(
                    spacing: 0.0,
                    runSpacing: 15.0,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    runAlignment: WrapAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    clipBehavior: Clip.none,
                    children: [
                      wrapWithModel(
                        model: _model.serviceItem3Model1,
                        updateCallback: () => safeSetState(() {}),
                        child: ServiceItem3Widget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1664372899354-99e6d9f50f58?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fEJhdGhyb29tJTIwQ2xlYW5pbmd8ZW58MHx8MHx8fDA%3D',
                          title: FFLocalizations.of(context).getText(
                            'b3xqm4nm' /* Bathroom Cleaning */,
                          ),
                        ),
                      ),
                      wrapWithModel(
                        model: _model.serviceItem3Model2,
                        updateCallback: () => safeSetState(() {}),
                        child: ServiceItem3Widget(
                          img:
                              'https://images.unsplash.com/photo-1669101602108-fa5ba89507ee?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8RGVlcCUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                          title: FFLocalizations.of(context).getText(
                            '2vaj9b1c' /* Deep Cleaning */,
                          ),
                        ),
                      ),
                      wrapWithModel(
                        model: _model.serviceItem3Model3,
                        updateCallback: () => safeSetState(() {}),
                        child: ServiceItem3Widget(
                          img:
                              'https://images.unsplash.com/photo-1714647211955-95c3104dc418?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8TW92ZSUyMGluJTIwJTJGJTIwTW92ZSUyMG91dCUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                          title: FFLocalizations.of(context).getText(
                            '0f25jvf9' /* Move-in / Move-out Cleaning */,
                          ),
                        ),
                      ),
                      wrapWithModel(
                        model: _model.serviceItem3Model4,
                        updateCallback: () => safeSetState(() {}),
                        child: ServiceItem3Widget(
                          img:
                              'https://images.unsplash.com/photo-1686479037314-88bc3732de16?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8UGV0JTIwQXJlYSUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                          title: FFLocalizations.of(context).getText(
                            '4psi9d7q' /* Pet Area Cleaning */,
                          ),
                        ),
                      ),
                      wrapWithModel(
                        model: _model.serviceItem3Model5,
                        updateCallback: () => safeSetState(() {}),
                        child: ServiceItem3Widget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1733342467205-fa328fc2f21e?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8TGF1bmRyeSUyMFNlcnZpY2VzfGVufDB8fDB8fHww',
                          title: FFLocalizations.of(context).getText(
                            'fyctckwd' /* Laundry Services */,
                          ),
                        ),
                      ),
                      wrapWithModel(
                        model: _model.serviceItem3Model6,
                        updateCallback: () => safeSetState(() {}),
                        child: ServiceItem3Widget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1678718606857-d4820cecc9bf?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8VXBob2xzdGVyeSUyMGFuZCUyMEZ1cm5pdHVyZSUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                          title: FFLocalizations.of(context).getText(
                            'evcujf01' /* Upholstery and Furniture Clean... */,
                          ),
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
