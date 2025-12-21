import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'on_screen_keyboard_model.dart';
export 'on_screen_keyboard_model.dart';

class OnScreenKeyboardWidget extends StatefulWidget {
  const OnScreenKeyboardWidget({super.key});

  @override
  State<OnScreenKeyboardWidget> createState() => _OnScreenKeyboardWidgetState();
}

class _OnScreenKeyboardWidgetState extends State<OnScreenKeyboardWidget> {
  late OnScreenKeyboardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnScreenKeyboardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(0.0),
        bottomRight: Radius.circular(0.0),
        topLeft: Radius.circular(40.0),
        topRight: Radius.circular(40.0),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        child: GridView(
          padding: EdgeInsets.fromLTRB(
            0,
            20.0,
            0,
            20.0,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 2.2,
          ),
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
                  onPressed: () async {
                    if (FFAppState().OnScreenKeyboardValue == '0') {
                      FFAppState().OnScreenKeyboardValue = '1';
                      FFAppState().update(() {});
                    } else {
                      FFAppState().OnScreenKeyboardValue =
                          (String currentValue, String newValue) {
                        return currentValue += newValue;
                      }(FFAppState().OnScreenKeyboardValue, '1');
                      FFAppState().update(() {});
                    }
                  },
                  text: FFLocalizations.of(context).getText(
                    '9ur7m1zi' /* 1 */,
                  ),
                  options: FFButtonOptions(
                    width: 55.0,
                    height: 55.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Colors.transparent,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
                  onPressed: () async {
                    if (FFAppState().OnScreenKeyboardValue == '0') {
                      FFAppState().OnScreenKeyboardValue = '2';
                      FFAppState().update(() {});
                    } else {
                      FFAppState().OnScreenKeyboardValue =
                          (String currentValue, String newValue) {
                        return currentValue += newValue;
                      }(FFAppState().OnScreenKeyboardValue, '2');
                      FFAppState().update(() {});
                    }
                  },
                  text: FFLocalizations.of(context).getText(
                    'cuo018bz' /* 2 */,
                  ),
                  options: FFButtonOptions(
                    width: 55.0,
                    height: 55.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Colors.transparent,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
                  onPressed: () async {
                    if (FFAppState().OnScreenKeyboardValue == '0') {
                      FFAppState().OnScreenKeyboardValue = '3';
                      FFAppState().update(() {});
                    } else {
                      FFAppState().OnScreenKeyboardValue =
                          (String currentValue, String newValue) {
                        return currentValue += newValue;
                      }(FFAppState().OnScreenKeyboardValue, '3');
                      FFAppState().update(() {});
                    }
                  },
                  text: FFLocalizations.of(context).getText(
                    'h9pclz7k' /* 3 */,
                  ),
                  options: FFButtonOptions(
                    width: 55.0,
                    height: 55.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Colors.transparent,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
                  onPressed: () async {
                    if (FFAppState().OnScreenKeyboardValue == '0') {
                      FFAppState().OnScreenKeyboardValue = '4';
                      FFAppState().update(() {});
                    } else {
                      FFAppState().OnScreenKeyboardValue =
                          (String currentValue, String newValue) {
                        return currentValue += newValue;
                      }(FFAppState().OnScreenKeyboardValue, '4');
                      FFAppState().update(() {});
                    }
                  },
                  text: FFLocalizations.of(context).getText(
                    '9j2j833g' /* 4 */,
                  ),
                  options: FFButtonOptions(
                    width: 55.0,
                    height: 55.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Colors.transparent,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
                  onPressed: () async {
                    if (FFAppState().OnScreenKeyboardValue == '0') {
                      FFAppState().OnScreenKeyboardValue = '5';
                      FFAppState().update(() {});
                    } else {
                      FFAppState().OnScreenKeyboardValue =
                          (String currentValue, String newValue) {
                        return currentValue += newValue;
                      }(FFAppState().OnScreenKeyboardValue, '5');
                      FFAppState().update(() {});
                    }
                  },
                  text: FFLocalizations.of(context).getText(
                    'lqltbz1k' /* 5 */,
                  ),
                  options: FFButtonOptions(
                    width: 55.0,
                    height: 55.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Colors.transparent,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
                  onPressed: () async {
                    if (FFAppState().OnScreenKeyboardValue == '0') {
                      FFAppState().OnScreenKeyboardValue = '6';
                      FFAppState().update(() {});
                    } else {
                      FFAppState().OnScreenKeyboardValue =
                          (String currentValue, String newValue) {
                        return currentValue += newValue;
                      }(FFAppState().OnScreenKeyboardValue, '6');
                      FFAppState().update(() {});
                    }
                  },
                  text: FFLocalizations.of(context).getText(
                    'h0mvhudm' /* 6 */,
                  ),
                  options: FFButtonOptions(
                    width: 55.0,
                    height: 55.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Colors.transparent,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
                  onPressed: () async {
                    if (FFAppState().OnScreenKeyboardValue == '0') {
                      FFAppState().OnScreenKeyboardValue = '7';
                      FFAppState().update(() {});
                    } else {
                      FFAppState().OnScreenKeyboardValue =
                          (String currentValue, String newValue) {
                        return currentValue += newValue;
                      }(FFAppState().OnScreenKeyboardValue, '7');
                      FFAppState().update(() {});
                    }
                  },
                  text: FFLocalizations.of(context).getText(
                    'eht9gpwt' /* 7 */,
                  ),
                  options: FFButtonOptions(
                    width: 55.0,
                    height: 55.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Colors.transparent,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
                  onPressed: () async {
                    if (FFAppState().OnScreenKeyboardValue == '0') {
                      FFAppState().OnScreenKeyboardValue = '8';
                      FFAppState().update(() {});
                    } else {
                      FFAppState().OnScreenKeyboardValue =
                          (String currentValue, String newValue) {
                        return currentValue += newValue;
                      }(FFAppState().OnScreenKeyboardValue, '8');
                      FFAppState().update(() {});
                    }
                  },
                  text: FFLocalizations.of(context).getText(
                    'ulo9qh2t' /* 8 */,
                  ),
                  options: FFButtonOptions(
                    width: 55.0,
                    height: 55.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Colors.transparent,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
                  onPressed: () async {
                    if (FFAppState().OnScreenKeyboardValue == '0') {
                      FFAppState().OnScreenKeyboardValue = '9';
                      FFAppState().update(() {});
                    } else {
                      FFAppState().OnScreenKeyboardValue =
                          (String currentValue, String newValue) {
                        return currentValue += newValue;
                      }(FFAppState().OnScreenKeyboardValue, '9');
                      FFAppState().update(() {});
                    }
                  },
                  text: FFLocalizations.of(context).getText(
                    'orildkpx' /* 9 */,
                  ),
                  options: FFButtonOptions(
                    width: 55.0,
                    height: 55.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Colors.transparent,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
                  onPressed: () async {
                    if (FFAppState().OnScreenKeyboardValue == '0') {
                      FFAppState().OnScreenKeyboardValue = '*';
                      FFAppState().update(() {});
                    } else {
                      FFAppState().OnScreenKeyboardValue =
                          (String currentValue, String newValue) {
                        return currentValue += newValue;
                      }(FFAppState().OnScreenKeyboardValue, '*');
                      FFAppState().update(() {});
                    }
                  },
                  text: FFLocalizations.of(context).getText(
                    '7xqcxswq' /* * */,
                  ),
                  options: FFButtonOptions(
                    width: 55.0,
                    height: 55.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Colors.transparent,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 24.0,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
                  onPressed: () async {
                    if (FFAppState().OnScreenKeyboardValue != '0') {
                      FFAppState().OnScreenKeyboardValue =
                          (String currentValue, String newValue) {
                        return currentValue += newValue;
                      }(FFAppState().OnScreenKeyboardValue, '0');
                      FFAppState().update(() {});
                    }
                  },
                  text: FFLocalizations.of(context).getText(
                    'pypcpeeq' /* 0 */,
                  ),
                  options: FFButtonOptions(
                    width: 55.0,
                    height: 55.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Colors.transparent,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterFlowIconButton(
                  borderRadius: 30.0,
                  buttonSize: 50.0,
                  icon: Icon(
                    Icons.backspace_outlined,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 20.0,
                  ),
                  onPressed: () async {
                    if ((String currentValue) {
                      return currentValue.length == 1 ? true : false;
                    }(FFAppState().OnScreenKeyboardValue)) {
                      FFAppState().OnScreenKeyboardValue = '0';
                      FFAppState().update(() {});
                    } else {
                      FFAppState().OnScreenKeyboardValue = FFAppState()
                          .OnScreenKeyboardValue
                          .substring(
                              0, FFAppState().OnScreenKeyboardValue.length - 1);
                      FFAppState().update(() {});
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
