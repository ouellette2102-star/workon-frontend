import '/flutter_flow/flutter_flow_radio_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'app_theme_model.dart';
export 'app_theme_model.dart';

class AppThemeWidget extends StatefulWidget {
  const AppThemeWidget({super.key});

  @override
  State<AppThemeWidget> createState() => _AppThemeWidgetState();
}

class _AppThemeWidgetState extends State<AppThemeWidget> {
  late AppThemeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AppThemeModel());
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
        padding: EdgeInsetsDirectional.fromSTEB(20.0, 8.0, 20.0, 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Text(
              FFLocalizations.of(context).getText(
                'b2pj60vs' /* App Theme */,
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    fontSize: 18.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Align(
              alignment: AlignmentDirectional(-1.0, -1.0),
              child: FlutterFlowRadioButton(
                options: [
                  FFLocalizations.of(context).getText(
                    '5wpcg83a' /* System */,
                  ),
                  FFLocalizations.of(context).getText(
                    '0pfu30n7' /* Light */,
                  ),
                  FFLocalizations.of(context).getText(
                    'vzofmwxu' /* Dark */,
                  )
                ].toList(),
                onChanged: (val) async {
                  safeSetState(() {});
                  if (_model.radioButtonValue == 'Light') {
                    setDarkModeSetting(context, ThemeMode.light);
                  } else {
                    if (_model.radioButtonValue == 'Dark') {
                      setDarkModeSetting(context, ThemeMode.dark);
                    } else {
                      setDarkModeSetting(context, ThemeMode.system);
                    }
                  }
                },
                controller: _model.radioButtonValueController ??=
                    FormFieldController<String>(() {
                  if (Theme.of(context).brightness == Brightness.dark) {
                    return 'Dark';
                  } else if (Theme.of(context).brightness == Brightness.light) {
                    return 'Light';
                  } else {
                    return 'System';
                  }
                }()),
                optionHeight: 45.0,
                textStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'General Sans',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
                selectedTextStyle:
                    FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'General Sans',
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                textPadding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                buttonPosition: RadioButtonPosition.left,
                direction: Axis.vertical,
                radioButtonColor: FlutterFlowTheme.of(context).primary,
                inactiveRadioButtonColor: FlutterFlowTheme.of(context).primary,
                toggleable: false,
                horizontalAlignment: WrapAlignment.start,
                verticalAlignment: WrapCrossAlignment.start,
              ),
            ),
          ].divide(SizedBox(height: 20.0)),
        ),
      ),
    );
  }
}
