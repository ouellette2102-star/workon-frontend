import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'provider_navbar_menu_model.dart';
export 'provider_navbar_menu_model.dart';

class ProviderNavbarMenuWidget extends StatefulWidget {
  const ProviderNavbarMenuWidget({
    super.key,
    required this.activePage,
  });

  final String? activePage;

  @override
  State<ProviderNavbarMenuWidget> createState() =>
      _ProviderNavbarMenuWidgetState();
}

class _ProviderNavbarMenuWidgetState extends State<ProviderNavbarMenuWidget> {
  late ProviderNavbarMenuModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProviderNavbarMenuModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FFButtonWidget(
            onPressed: () async {
              context.pushNamed(HomeProviderWidget.routeName);
            },
            text: FFLocalizations.of(context).getText(
              '22ve8a9d' /* Dashboard                     ... */,
            ),
            icon: Icon(
              FFIcons.khome254,
              size: 18.0,
            ),
            options: FFButtonOptions(
              width: double.infinity,
              height: 50.0,
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
              color: widget!.activePage == 'dashboard'
                  ? FlutterFlowTheme.of(context).primary
                  : Colors.transparent,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'General Sans',
                    color: widget!.activePage == 'dashboard'
                        ? FlutterFlowTheme.of(context).info
                        : FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
          FFButtonWidget(
            onPressed: () async {
              context.pushNamed(
                JobRequestsWidget.routeName,
                queryParameters: {
                  'initialTab': serializeParam(
                    0,
                    ParamType.int,
                  ),
                }.withoutNulls,
              );
            },
            text: FFLocalizations.of(context).getText(
              'mmdnsns0' /* Job Requests                  ... */,
            ),
            icon: Icon(
              FFIcons.krefresh18,
              size: 18.0,
            ),
            options: FFButtonOptions(
              width: double.infinity,
              height: 50.0,
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
              color: widget!.activePage == 'job_requests'
                  ? FlutterFlowTheme.of(context).primary
                  : Colors.transparent,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'General Sans',
                    color: widget!.activePage == 'job_requests'
                        ? FlutterFlowTheme.of(context).info
                        : FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
          FFButtonWidget(
            onPressed: () async {
              context.pushNamed(MessagesProviderWidget.routeName);
            },
            text: FFLocalizations.of(context).getText(
              '8t9fp2jj' /* Messages                      ... */,
            ),
            icon: Icon(
              FFIcons.kmessage02,
              size: 20.0,
            ),
            options: FFButtonOptions(
              width: double.infinity,
              height: 50.0,
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
              color: widget!.activePage == 'messages'
                  ? FlutterFlowTheme.of(context).primary
                  : Colors.transparent,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'General Sans',
                    color: widget!.activePage == 'messages'
                        ? FlutterFlowTheme.of(context).info
                        : FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
          // PR-JOBS-LIST: Fixed navigation to JobsRealWidget
          FFButtonWidget(
            onPressed: () async {
              context.pushNamed(JobsRealWidget.routeName);
            },
            text: FFLocalizations.of(context).getText(
              '12l3wux4' /* My Jobs                       ... */,
            ),
            icon: Icon(
              FFIcons.kbrifecaseTick13,
              size: 20.0,
            ),
            options: FFButtonOptions(
              width: double.infinity,
              height: 50.0,
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
              color: widget!.activePage == 'my_jobs'
                  ? FlutterFlowTheme.of(context).primary
                  : Colors.transparent,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'General Sans',
                    color: widget!.activePage == 'my_jobs'
                        ? FlutterFlowTheme.of(context).info
                        : FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
          FFButtonWidget(
            onPressed: () async {
              context.pushNamed(ServicesWidget.routeName);
            },
            text: FFLocalizations.of(context).getText(
              'mvey0r5g' /* Services                      ... */,
            ),
            icon: Icon(
              FFIcons.kdocument02,
              size: 20.0,
            ),
            options: FFButtonOptions(
              width: double.infinity,
              height: 50.0,
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
              color: widget!.activePage == 'services'
                  ? FlutterFlowTheme.of(context).primary
                  : Colors.transparent,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'General Sans',
                    color: widget!.activePage == 'services'
                        ? FlutterFlowTheme.of(context).info
                        : FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
          // PR-EARNINGS: Navigate to real earnings widget (backend connected)
          FFButtonWidget(
            onPressed: () async {
              context.pushNamed(EarningsRealWidget.routeName);
            },
            text: FFLocalizations.of(context).getText(
              'tmijg8br' /* Earnings                      ... */,
            ),
            icon: Icon(
              FFIcons.kusdCoinUsdc50,
              size: 18.0,
            ),
            options: FFButtonOptions(
              width: double.infinity,
              height: 50.0,
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
              color: widget!.activePage == 'earnings'
                  ? FlutterFlowTheme.of(context).primary
                  : Colors.transparent,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'General Sans',
                    color: widget!.activePage == 'earnings'
                        ? FlutterFlowTheme.of(context).info
                        : FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
          FFButtonWidget(
            onPressed: () async {
              context.pushNamed(RatingsWidget.routeName);
            },
            text: FFLocalizations.of(context).getText(
              'h7w6lyys' /* Ratings & Reviews             ... */,
            ),
            icon: Icon(
              Icons.star_rounded,
              size: 20.0,
            ),
            options: FFButtonOptions(
              width: double.infinity,
              height: 50.0,
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
              color: widget!.activePage == 'ratings'
                  ? FlutterFlowTheme.of(context).primary
                  : Colors.transparent,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'General Sans',
                    color: widget!.activePage == 'ratings'
                        ? FlutterFlowTheme.of(context).info
                        : FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
        ]
            .divide(SizedBox(height: 15.0))
            .addToStart(SizedBox(height: 20.0))
            .addToEnd(SizedBox(height: 20.0)),
      ),
    );
  }
}
