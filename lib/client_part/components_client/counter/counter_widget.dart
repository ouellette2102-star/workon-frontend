import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'counter_model.dart';
export 'counter_model.dart';

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late CounterModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CounterModel());
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
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlutterFlowIconButton(
              borderRadius: 10.0,
              buttonSize: 30.0,
              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
              icon: Icon(
                FFIcons.kminus,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 15.0,
              ),
              onPressed: (_model.counterValue == 0)
                  ? null
                  : () async {
                      _model.counterValue = _model.counterValue + -1;
                      _model.updatePage(() {});
                    },
            ),
            Text(
              valueOrDefault<String>(
                _model.counterValue.toString(),
                '0',
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    fontSize: 15.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            FlutterFlowIconButton(
              borderRadius: 10.0,
              buttonSize: 30.0,
              fillColor: FlutterFlowTheme.of(context).primary,
              icon: Icon(
                FFIcons.kadd,
                color: FlutterFlowTheme.of(context).info,
                size: 15.0,
              ),
              onPressed: () async {
                _model.counterValue = _model.counterValue + 1;
                _model.updatePage(() {});
              },
            ),
          ].divide(SizedBox(width: 8.0)),
        ),
      ),
    );
  }
}
