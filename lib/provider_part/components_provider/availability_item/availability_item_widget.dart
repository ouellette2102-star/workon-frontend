import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'availability_item_model.dart';
export 'availability_item_model.dart';

class AvailabilityItemWidget extends StatefulWidget {
  const AvailabilityItemWidget({
    super.key,
    required this.day,
  });

  final String? day;

  @override
  State<AvailabilityItemWidget> createState() => _AvailabilityItemWidgetState();
}

class _AvailabilityItemWidgetState extends State<AvailabilityItemWidget> {
  late AvailabilityItemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AvailabilityItemModel());

    _model.switchValue = true;
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
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    valueOrDefault<String>(
                      widget!.day,
                      'Day Name',
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'General Sans',
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      _model.switchValue! ? 'Available' : 'Unavailable',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'General Sans',
                            letterSpacing: 0.0,
                          ),
                    ),
                    Switch.adaptive(
                      value: _model.switchValue!,
                      onChanged: (newValue) async {
                        safeSetState(() => _model.switchValue = newValue!);
                      },
                      activeColor: FlutterFlowTheme.of(context).info,
                      activeTrackColor: FlutterFlowTheme.of(context).primary,
                      inactiveTrackColor:
                          FlutterFlowTheme.of(context).alternate,
                      inactiveThumbColor:
                          FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ].divide(SizedBox(width: 5.0)),
                ),
              ].divide(SizedBox(width: 10.0)),
            ),
            if (_model.switchValue ?? true)
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Divider(
                    height: 1.0,
                    color: FlutterFlowTheme.of(context).alternate,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'yu2ph0h6' /* From */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'General Sans',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                            FlutterFlowDropDown<String>(
                              controller: _model.genderValueController1 ??=
                                  FormFieldController<String>(null),
                              options: [
                                FFLocalizations.of(context).getText(
                                  'fwr4oz6z' /* 00:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  '7gcudtgi' /* 01:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'elkww3cc' /* 02:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'gygrb0km' /* 03:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'ovcjcwg5' /* 04:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  '8sgcvq3i' /* 05:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'ylsnqlq0' /* 06:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  '0dsloj8g' /* 07:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'lx451v5a' /* 08:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  '0ainpld6' /* 09:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'qxbbgosw' /* 10:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  '0z59t4wf' /* 11:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  '1eeauylq' /* 12:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'y2arsgqp' /* 01:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  '9op245ku' /* 02:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  '24ehabw9' /* 03:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  '57g4339u' /* 04:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'vrbb9mcn' /* 05:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'tttwcxwk' /* 06:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  '770px212' /* 07:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'txrux12q' /* 08:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'oo47ha10' /* 09:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'jhq30p52' /* 10:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'k9auqp05' /* 11:00 PM */,
                                )
                              ],
                              onChanged: (val) =>
                                  safeSetState(() => _model.genderValue1 = val),
                              width: double.infinity,
                              height: 45.0,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'General Sans',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                              hintText: FFLocalizations.of(context).getText(
                                'y68aewgj' /* Select hour */,
                              ),
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
                              elevation: 2.0,
                              borderColor:
                                  FlutterFlowTheme.of(context).alternate,
                              borderWidth: 1.0,
                              borderRadius: 12.0,
                              margin: EdgeInsetsDirectional.fromSTEB(
                                  15.0, 0.0, 10.0, 0.0),
                              hidesUnderline: true,
                              isOverButton: false,
                              isSearchable: false,
                              isMultiSelect: false,
                            ),
                          ].divide(SizedBox(height: 5.0)),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                        child: Icon(
                          FFIcons.kright3,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'j932kj7k' /* To */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'General Sans',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                            FlutterFlowDropDown<String>(
                              controller: _model.genderValueController2 ??=
                                  FormFieldController<String>(null),
                              options: [
                                FFLocalizations.of(context).getText(
                                  'pzim9n5u' /* 00:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'c77u9w4z' /* 01:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'wr51v7al' /* 02:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'rp2lfkcw' /* 03:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  '1n1cgjme' /* 04:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'yobahahd' /* 05:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  '8qajd9ki' /* 06:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'wud1kjk1' /* 07:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'fml05piv' /* 08:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'vjublns1' /* 09:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  '5enggle2' /* 10:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  '77m9hz8j' /* 11:00 AM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'i1zb0mkt' /* 12:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  '7ts0nk5f' /* 01:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'jcsyi0q3' /* 02:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  '2gd42y9s' /* 03:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'bzmfh34g' /* 04:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'ezdp89zs' /* 05:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'vs6l5xg7' /* 06:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  '6a22loc8' /* 07:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  '4xilka64' /* 08:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'mecoopfz' /* 09:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'ukwekkk2' /* 10:00 PM */,
                                ),
                                FFLocalizations.of(context).getText(
                                  'x9axqfl1' /* 11:00 PM */,
                                )
                              ],
                              onChanged: (val) =>
                                  safeSetState(() => _model.genderValue2 = val),
                              width: double.infinity,
                              height: 45.0,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'General Sans',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                              hintText: FFLocalizations.of(context).getText(
                                'irqqk5pi' /* Select hour */,
                              ),
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
                              elevation: 2.0,
                              borderColor:
                                  FlutterFlowTheme.of(context).alternate,
                              borderWidth: 1.0,
                              borderRadius: 12.0,
                              margin: EdgeInsetsDirectional.fromSTEB(
                                  15.0, 0.0, 10.0, 0.0),
                              hidesUnderline: true,
                              isOverButton: false,
                              isSearchable: false,
                              isMultiSelect: false,
                            ),
                          ].divide(SizedBox(height: 5.0)),
                        ),
                      ),
                    ].divide(SizedBox(width: 20.0)),
                  ),
                ].divide(SizedBox(height: 10.0)),
              ),
          ].divide(SizedBox(height: 10.0)),
        ),
      ),
    );
  }
}
