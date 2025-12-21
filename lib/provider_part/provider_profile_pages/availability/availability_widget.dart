import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/provider_part/components_provider/availability_item/availability_item_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'availability_model.dart';
export 'availability_model.dart';

class AvailabilityWidget extends StatefulWidget {
  const AvailabilityWidget({super.key});

  static String routeName = 'Availability';
  static String routePath = '/availability';

  @override
  State<AvailabilityWidget> createState() => _AvailabilityWidgetState();
}

class _AvailabilityWidgetState extends State<AvailabilityWidget> {
  late AvailabilityModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AvailabilityModel());

    _model.vacationSwitchValue = false;
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
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    wrapWithModel(
                      model: _model.backIconBtnModel,
                      updateCallback: () => safeSetState(() {}),
                      child: BackIconBtnWidget(),
                    ),
                    Flexible(
                      child: Text(
                        FFLocalizations.of(context).getText(
                          '0cpujdyy' /* Availability */,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'General Sans',
                              fontSize: 20.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ].divide(SizedBox(width: 15.0)),
                ),
              ),
            ].divide(SizedBox(width: 15.0)),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
                            Text(
                              FFLocalizations.of(context).getText(
                                '61jjaond' /* Vacation Mode */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'General Sans',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Switch.adaptive(
                              value: _model.vacationSwitchValue!,
                              onChanged: (newValue) async {
                                safeSetState(() =>
                                    _model.vacationSwitchValue = newValue!);
                              },
                              activeColor: FlutterFlowTheme.of(context).info,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).success,
                              inactiveTrackColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              inactiveThumbColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ],
                        ),
                        Divider(
                          height: 1.0,
                          color: FlutterFlowTheme.of(context).alternate,
                        ),
                        Wrap(
                          spacing: 0.0,
                          runSpacing: 20.0,
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          direction: Axis.horizontal,
                          runAlignment: WrapAlignment.start,
                          verticalDirection: VerticalDirection.down,
                          clipBehavior: Clip.none,
                          children: [
                            wrapWithModel(
                              model: _model.availabilityItemModel1,
                              updateCallback: () => safeSetState(() {}),
                              child: AvailabilityItemWidget(
                                day: FFLocalizations.of(context).getText(
                                  'sxtyolab' /* Monday */,
                                ),
                              ),
                            ),
                            wrapWithModel(
                              model: _model.availabilityItemModel2,
                              updateCallback: () => safeSetState(() {}),
                              child: AvailabilityItemWidget(
                                day: FFLocalizations.of(context).getText(
                                  'h64eko37' /* Tuesday */,
                                ),
                              ),
                            ),
                            wrapWithModel(
                              model: _model.availabilityItemModel3,
                              updateCallback: () => safeSetState(() {}),
                              child: AvailabilityItemWidget(
                                day: FFLocalizations.of(context).getText(
                                  'nyv2p7ee' /* Wednesday */,
                                ),
                              ),
                            ),
                            wrapWithModel(
                              model: _model.availabilityItemModel4,
                              updateCallback: () => safeSetState(() {}),
                              child: AvailabilityItemWidget(
                                day: FFLocalizations.of(context).getText(
                                  'jqs3pt6v' /* Thursday */,
                                ),
                              ),
                            ),
                            wrapWithModel(
                              model: _model.availabilityItemModel5,
                              updateCallback: () => safeSetState(() {}),
                              child: AvailabilityItemWidget(
                                day: FFLocalizations.of(context).getText(
                                  'k8osyqty' /* Friday */,
                                ),
                              ),
                            ),
                            wrapWithModel(
                              model: _model.availabilityItemModel6,
                              updateCallback: () => safeSetState(() {}),
                              child: AvailabilityItemWidget(
                                day: FFLocalizations.of(context).getText(
                                  'ygnsrutd' /* Saturday */,
                                ),
                              ),
                            ),
                            wrapWithModel(
                              model: _model.availabilityItemModel7,
                              updateCallback: () => safeSetState(() {}),
                              child: AvailabilityItemWidget(
                                day: FFLocalizations.of(context).getText(
                                  'hhm7fxrm' /* Sunday */,
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
              Padding(
                padding: EdgeInsets.all(20.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    context.safePop();
                  },
                  text: FFLocalizations.of(context).getText(
                    '70sgwvp0' /* Save Changes */,
                  ),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
