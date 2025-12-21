import '/client_part/components_client/circle_wraper/circle_wraper_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'failed_widget_model.dart';
export 'failed_widget_model.dart';

class FailedWidgetWidget extends StatefulWidget {
  const FailedWidgetWidget({
    super.key,
    required this.title,
    required this.description,
    required this.btnText,
    required this.btnAction,
  });

  final String? title;
  final String? description;
  final String? btnText;
  final Future Function()? btnAction;

  @override
  State<FailedWidgetWidget> createState() => _FailedWidgetWidgetState();
}

class _FailedWidgetWidgetState extends State<FailedWidgetWidget> {
  late FailedWidgetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FailedWidgetModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(),
          ),
          Align(
            alignment: AlignmentDirectional(0.0, -1.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 30.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  wrapWithModel(
                    model: _model.circleWraperModel,
                    updateCallback: () => safeSetState(() {}),
                    child: CircleWraperWidget(
                      icon: Icon(
                        FFIcons.kcloseCircle55,
                        color: FlutterFlowTheme.of(context).info,
                        size: 80.0,
                      ),
                      color: FlutterFlowTheme.of(context).error,
                    ),
                  ),
                  Text(
                    valueOrDefault<String>(
                      widget!.title,
                      'Ooops! Failed',
                    ),
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).error,
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(1.0, 0.0, 0.0, 0.0),
                    child: Text(
                      valueOrDefault<String>(
                        widget!.description,
                        'Sorry! Failed...',
                      ),
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'General Sans',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ].divide(SizedBox(height: 40.0)),
              ),
            ),
          ),
          FFButtonWidget(
            onPressed: () async {
              await widget.btnAction?.call();
            },
            text: valueOrDefault<String>(
              widget!.btnText,
              'OK',
            ),
            options: FFButtonOptions(
              width: double.infinity,
              height: 50.0,
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'General Sans',
                    color: Colors.white,
                    letterSpacing: 0.0,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ].divide(SizedBox(height: 30.0)),
      ),
    );
  }
}
