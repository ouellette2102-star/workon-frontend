import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'background_circle_design_model.dart';
export 'background_circle_design_model.dart';

class BackgroundCircleDesignWidget extends StatefulWidget {
  const BackgroundCircleDesignWidget({super.key});

  @override
  State<BackgroundCircleDesignWidget> createState() =>
      _BackgroundCircleDesignWidgetState();
}

class _BackgroundCircleDesignWidgetState
    extends State<BackgroundCircleDesignWidget> {
  late BackgroundCircleDesignModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BackgroundCircleDesignModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.7,
              height: MediaQuery.sizeOf(context).width * 0.7,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    FlutterFlowTheme.of(context).primary,
                    FlutterFlowTheme.of(context).secondary
                  ],
                  stops: [0.0, 1.0],
                  begin: AlignmentDirectional(1.0, 0.0),
                  end: AlignmentDirectional(-1.0, 0),
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.87, -0.66),
            child: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.91, -0.67),
            child: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.8, -0.1),
            child: Container(
              width: 15.0,
              height: 15.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.72, 0.46),
            child: Container(
              width: 15.0,
              height: 15.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.35, 0.65),
            child: Container(
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.31, 0.78),
            child: Container(
              width: 30.0,
              height: 30.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.91, -0.01),
            child: Container(
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.92, 0.43),
            child: Container(
              width: 30.0,
              height: 30.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
