import '/client_part/components_client/circle_wraper/circle_wraper_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'success_loading_dialog_model.dart';
export 'success_loading_dialog_model.dart';

class SuccessLoadingDialogWidget extends StatefulWidget {
  const SuccessLoadingDialogWidget({
    super.key,
    required this.title,
    required this.description,
  });

  final String? title;
  final String? description;

  @override
  State<SuccessLoadingDialogWidget> createState() =>
      _SuccessLoadingDialogWidgetState();
}

class _SuccessLoadingDialogWidgetState
    extends State<SuccessLoadingDialogWidget> {
  late SuccessLoadingDialogModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SuccessLoadingDialogModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.8,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(15.0, 25.0, 15.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              wrapWithModel(
                model: _model.circleWraperModel,
                updateCallback: () => safeSetState(() {}),
                child: CircleWraperWidget(
                  icon: Icon(
                    FFIcons.ktickCircle56,
                    color: FlutterFlowTheme.of(context).info,
                    size: 70.0,
                  ),
                  color: FlutterFlowTheme.of(context).success,
                ),
              ),
              Text(
                valueOrDefault<String>(
                  widget!.title,
                  'Successful!',
                ),
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      color: FlutterFlowTheme.of(context).success,
                      fontSize: 20.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                valueOrDefault<String>(
                  widget!.description,
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                ),
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 14.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.normal,
                      lineHeight: 1.5,
                    ),
              ),
              Lottie.network(
                'https://lottie.host/453ed909-fe76-42ce-aa02-ba77f5235f33/MyngiwDQb7.json',
                width: 100.0,
                height: 100.0,
                fit: BoxFit.contain,
                animate: true,
              ),
            ].divide(SizedBox(height: 20.0)),
          ),
        ),
      ),
    );
  }
}
