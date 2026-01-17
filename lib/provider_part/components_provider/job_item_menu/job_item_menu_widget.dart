import '/components/coming_soon_screen.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'job_item_menu_model.dart';
export 'job_item_menu_model.dart';

class JobItemMenuWidget extends StatefulWidget {
  const JobItemMenuWidget({
    super.key,
    required this.bookingStatus,
  });

  final String? bookingStatus;

  @override
  State<JobItemMenuWidget> createState() => _JobItemMenuWidgetState();
}

class _JobItemMenuWidgetState extends State<JobItemMenuWidget> {
  late JobItemMenuModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => JobItemMenuModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(15.0, 8.0, 15.0, 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: AlignmentDirectional(0.0, -1.0),
              child: Container(
                width: 35.0,
                height: 3.5,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).alternate,
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (widget!.bookingStatus == 'pending')
                  FFButtonWidget(
                    onPressed: () {
                      print('Button pressed ...');
                    },
                    text: FFLocalizations.of(context).getText(
                      'hlluzm78' /* Mark as Completed             ... */,
                    ),
                    icon: Icon(
                      FFIcons.ktickSquare50,
                      size: 22.0,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                      iconColor: FlutterFlowTheme.of(context).secondaryText,
                      color: Colors.transparent,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'General Sans',
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                // PR-15: VoiceCall is template-only, show coming soon
                if (widget!.bookingStatus == 'pending')
                  FFButtonWidget(
                    onPressed: () async {
                      showComingSoon(context, 'Appels vocaux');
                    },
                    text: FFLocalizations.of(context).getText(
                      'qk5c1g9j' /* Call Client                   ... */,
                    ),
                    icon: Icon(
                      Icons.call_rounded,
                      size: 22.0,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                      iconColor: FlutterFlowTheme.of(context).secondaryText,
                      color: Colors.transparent,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'General Sans',
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                if (widget!.bookingStatus == 'pending')
                  FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(ChatWidget.routeName);
                    },
                    text: FFLocalizations.of(context).getText(
                      '0zmucfbn' /* Message Client                ... */,
                    ),
                    icon: Icon(
                      FFIcons.kmessage02,
                      size: 22.0,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                      iconColor: FlutterFlowTheme.of(context).secondaryText,
                      color: Colors.transparent,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'General Sans',
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                if (widget!.bookingStatus == 'completed')
                  FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(ShareExperienceWidget.routeName);
                    },
                    text: FFLocalizations.of(context).getText(
                      'm39yj3c5' /* Share Experience with client  ... */,
                    ),
                    icon: Icon(
                      Icons.star_rounded,
                      size: 22.0,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                      iconColor: FlutterFlowTheme.of(context).secondaryText,
                      color: Colors.transparent,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'General Sans',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                // PR-15: CancelBooking is template-only, show coming soon
                if (widget!.bookingStatus == 'pending')
                  FFButtonWidget(
                    onPressed: () async {
                      showComingSoon(context, 'Annulation');
                    },
                    text: FFLocalizations.of(context).getText(
                      'zvdh85my' /* Cancel Job                    ... */,
                    ),
                    icon: Icon(
                      FFIcons.kcloseSquare02,
                      size: 22.0,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                      iconColor: FlutterFlowTheme.of(context).error,
                      color: Colors.transparent,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'General Sans',
                                color: FlutterFlowTheme.of(context).error,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
              ],
            ),
          ].divide(SizedBox(height: 20.0)),
        ),
      ),
    );
  }
}
