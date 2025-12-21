import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'notification_settings_provider_model.dart';
export 'notification_settings_provider_model.dart';

class NotificationSettingsProviderWidget extends StatefulWidget {
  const NotificationSettingsProviderWidget({super.key});

  static String routeName = 'NotificationSettings-Provider';
  static String routePath = '/notificationSettingsProvider';

  @override
  State<NotificationSettingsProviderWidget> createState() =>
      _NotificationSettingsProviderWidgetState();
}

class _NotificationSettingsProviderWidgetState
    extends State<NotificationSettingsProviderWidget> {
  late NotificationSettingsProviderModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationSettingsProviderModel());

    _model.switchValue1 = false;
    _model.switchValue2 = true;
    _model.switchValue3 = true;
    _model.switchValue4 = false;
    _model.switchValue5 = false;
    _model.switchValue6 = true;
    _model.switchValue7 = false;
    _model.switchValue8 = true;
    _model.switchValue9 = false;
    _model.switchValue10 = true;
    _model.switchValue11 = false;
    _model.switchValue12 = true;
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
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  wrapWithModel(
                    model: _model.backIconBtnModel,
                    updateCallback: () => safeSetState(() {}),
                    child: BackIconBtnWidget(),
                  ),
                  Text(
                    FFLocalizations.of(context).getText(
                      '2z5quk3t' /* Notification Settings */,
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'General Sans',
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ].divide(SizedBox(width: 15.0)),
              ),
            ].divide(SizedBox(width: 15.0)),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'ht9i1uh5' /* General Notification */,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Switch.adaptive(
                        value: _model.switchValue1!,
                        onChanged: (newValue) async {
                          safeSetState(() => _model.switchValue1 = newValue!);
                        },
                        activeColor: FlutterFlowTheme.of(context).info,
                        activeTrackColor: FlutterFlowTheme.of(context).primary,
                        inactiveTrackColor:
                            FlutterFlowTheme.of(context).alternate,
                        inactiveThumbColor: FlutterFlowTheme.of(context).info,
                      ),
                    ].divide(SizedBox(width: 15.0)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'nuw68tq9' /* Security Alerts */,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Switch.adaptive(
                        value: _model.switchValue2!,
                        onChanged: (newValue) async {
                          safeSetState(() => _model.switchValue2 = newValue!);
                        },
                        activeColor: FlutterFlowTheme.of(context).info,
                        activeTrackColor: FlutterFlowTheme.of(context).primary,
                        inactiveTrackColor:
                            FlutterFlowTheme.of(context).alternate,
                        inactiveThumbColor: FlutterFlowTheme.of(context).info,
                      ),
                    ].divide(SizedBox(width: 15.0)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'jsrq6dht' /* App Updates */,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Switch.adaptive(
                        value: _model.switchValue3!,
                        onChanged: (newValue) async {
                          safeSetState(() => _model.switchValue3 = newValue!);
                        },
                        activeColor: FlutterFlowTheme.of(context).info,
                        activeTrackColor: FlutterFlowTheme.of(context).primary,
                        inactiveTrackColor:
                            FlutterFlowTheme.of(context).alternate,
                        inactiveThumbColor: FlutterFlowTheme.of(context).info,
                      ),
                    ].divide(SizedBox(width: 15.0)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'jjrvshfq' /* Bill Reminder */,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Switch.adaptive(
                        value: _model.switchValue4!,
                        onChanged: (newValue) async {
                          safeSetState(() => _model.switchValue4 = newValue!);
                        },
                        activeColor: FlutterFlowTheme.of(context).info,
                        activeTrackColor: FlutterFlowTheme.of(context).primary,
                        inactiveTrackColor:
                            FlutterFlowTheme.of(context).alternate,
                        inactiveThumbColor: FlutterFlowTheme.of(context).info,
                      ),
                    ].divide(SizedBox(width: 15.0)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'f94jmd2q' /* Promotions */,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Switch.adaptive(
                        value: _model.switchValue5!,
                        onChanged: (newValue) async {
                          safeSetState(() => _model.switchValue5 = newValue!);
                        },
                        activeColor: FlutterFlowTheme.of(context).info,
                        activeTrackColor: FlutterFlowTheme.of(context).primary,
                        inactiveTrackColor:
                            FlutterFlowTheme.of(context).alternate,
                        inactiveThumbColor: FlutterFlowTheme.of(context).info,
                      ),
                    ].divide(SizedBox(width: 15.0)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          FFLocalizations.of(context).getText(
                            't54kaonj' /* Discount Available */,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Switch.adaptive(
                        value: _model.switchValue6!,
                        onChanged: (newValue) async {
                          safeSetState(() => _model.switchValue6 = newValue!);
                        },
                        activeColor: FlutterFlowTheme.of(context).info,
                        activeTrackColor: FlutterFlowTheme.of(context).primary,
                        inactiveTrackColor:
                            FlutterFlowTheme.of(context).alternate,
                        inactiveThumbColor: FlutterFlowTheme.of(context).info,
                      ),
                    ].divide(SizedBox(width: 15.0)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          FFLocalizations.of(context).getText(
                            '5iiihegg' /* New Service Available */,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Switch.adaptive(
                        value: _model.switchValue7!,
                        onChanged: (newValue) async {
                          safeSetState(() => _model.switchValue7 = newValue!);
                        },
                        activeColor: FlutterFlowTheme.of(context).info,
                        activeTrackColor: FlutterFlowTheme.of(context).primary,
                        inactiveTrackColor:
                            FlutterFlowTheme.of(context).alternate,
                        inactiveThumbColor: FlutterFlowTheme.of(context).info,
                      ),
                    ].divide(SizedBox(width: 15.0)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'xvflqzna' /* App Updates & News */,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Switch.adaptive(
                        value: _model.switchValue8!,
                        onChanged: (newValue) async {
                          safeSetState(() => _model.switchValue8 = newValue!);
                        },
                        activeColor: FlutterFlowTheme.of(context).info,
                        activeTrackColor: FlutterFlowTheme.of(context).primary,
                        inactiveTrackColor:
                            FlutterFlowTheme.of(context).alternate,
                        inactiveThumbColor: FlutterFlowTheme.of(context).info,
                      ),
                    ].divide(SizedBox(width: 15.0)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'xyyjoubk' /* Event Invitation */,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Switch.adaptive(
                        value: _model.switchValue9!,
                        onChanged: (newValue) async {
                          safeSetState(() => _model.switchValue9 = newValue!);
                        },
                        activeColor: FlutterFlowTheme.of(context).info,
                        activeTrackColor: FlutterFlowTheme.of(context).primary,
                        inactiveTrackColor:
                            FlutterFlowTheme.of(context).alternate,
                        inactiveThumbColor: FlutterFlowTheme.of(context).info,
                      ),
                    ].divide(SizedBox(width: 15.0)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          FFLocalizations.of(context).getText(
                            '2y1l9qoo' /* Reward program updates */,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Switch.adaptive(
                        value: _model.switchValue10!,
                        onChanged: (newValue) async {
                          safeSetState(() => _model.switchValue10 = newValue!);
                        },
                        activeColor: FlutterFlowTheme.of(context).info,
                        activeTrackColor: FlutterFlowTheme.of(context).primary,
                        inactiveTrackColor:
                            FlutterFlowTheme.of(context).alternate,
                        inactiveThumbColor: FlutterFlowTheme.of(context).info,
                      ),
                    ].divide(SizedBox(width: 15.0)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'kkh0yws8' /* Important Announcement */,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Switch.adaptive(
                        value: _model.switchValue11!,
                        onChanged: (newValue) async {
                          safeSetState(() => _model.switchValue11 = newValue!);
                        },
                        activeColor: FlutterFlowTheme.of(context).info,
                        activeTrackColor: FlutterFlowTheme.of(context).primary,
                        inactiveTrackColor:
                            FlutterFlowTheme.of(context).alternate,
                        inactiveThumbColor: FlutterFlowTheme.of(context).info,
                      ),
                    ].divide(SizedBox(width: 15.0)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          FFLocalizations.of(context).getText(
                            '8oo9g54u' /* App Tips & Tutorials */,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Switch.adaptive(
                        value: _model.switchValue12!,
                        onChanged: (newValue) async {
                          safeSetState(() => _model.switchValue12 = newValue!);
                        },
                        activeColor: FlutterFlowTheme.of(context).info,
                        activeTrackColor: FlutterFlowTheme.of(context).primary,
                        inactiveTrackColor:
                            FlutterFlowTheme.of(context).alternate,
                        inactiveThumbColor: FlutterFlowTheme.of(context).info,
                      ),
                    ].divide(SizedBox(width: 15.0)),
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
