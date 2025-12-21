import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/failed_widget/failed_widget_widget.dart';
import '/client_part/components_client/radio_list_item/radio_list_item_widget.dart';
import '/client_part/components_client/success_widget/success_widget_widget.dart';
import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'reschedule_booking_model.dart';
export 'reschedule_booking_model.dart';

class RescheduleBookingWidget extends StatefulWidget {
  const RescheduleBookingWidget({super.key});

  static String routeName = 'RescheduleBooking';
  static String routePath = '/rescheduleBooking';

  @override
  State<RescheduleBookingWidget> createState() =>
      _RescheduleBookingWidgetState();
}

class _RescheduleBookingWidgetState extends State<RescheduleBookingWidget> {
  late RescheduleBookingModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RescheduleBookingModel());

    _model.rescheduleMessageTextController ??= TextEditingController();
    _model.rescheduleMessageFocusNode ??= FocusNode();
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
                          'w15jwnkb' /* Reschedule Booking */,
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
              FlutterFlowIconButton(
                borderRadius: 30.0,
                buttonSize: 40.0,
                icon: Icon(
                  Icons.more_vert_sharp,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                onPressed: () {
                  print('IconButton pressed ...');
                },
              ),
            ].divide(SizedBox(width: 15.0)),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _model.pageViewController ??=
                  PageController(initialPage: 0),
              onPageChanged: (_) => safeSetState(() {}),
              scrollDirection: Axis.horizontal,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  '373ctht3' /* Select New Date & Time */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'General Sans',
                                      fontSize: 15.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10.0, 0.0, 10.0, 12.0),
                                  child: FlutterFlowCalendar(
                                    color: FlutterFlowTheme.of(context).primary,
                                    iconColor: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    weekFormat: false,
                                    weekStartsMonday: false,
                                    initialDate: getCurrentTimestamp,
                                    rowHeight: 45.0,
                                    onChange: (DateTimeRange? newSelectedDate) {
                                      safeSetState(() =>
                                          _model.calendarSelectedDay =
                                              newSelectedDate);
                                    },
                                    titleStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .override(
                                          fontFamily: 'General Sans',
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    dayOfWeekStyle: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily: 'General Sans',
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    dateStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'General Sans',
                                          letterSpacing: 0.0,
                                        ),
                                    selectedDateStyle:
                                        FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'General Sans',
                                              letterSpacing: 0.0,
                                            ),
                                    inactiveDateStyle:
                                        FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'General Sans',
                                              letterSpacing: 0.0,
                                            ),
                                    locale: FFLocalizations.of(context)
                                        .languageCode,
                                  ),
                                ),
                              ),
                              Divider(
                                height: 1.0,
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(),
                                child: FlutterFlowChoiceChips(
                                  options: [
                                    ChipData(
                                        FFLocalizations.of(context).getText(
                                      '7r3nkxya' /* 7:00 AM */,
                                    )),
                                    ChipData(
                                        FFLocalizations.of(context).getText(
                                      '2xm7sq8e' /* 8:00 AM */,
                                    )),
                                    ChipData(
                                        FFLocalizations.of(context).getText(
                                      '23bkxq90' /* 9:00 AM */,
                                    )),
                                    ChipData(
                                        FFLocalizations.of(context).getText(
                                      'io4swi3e' /* 10:00 AM */,
                                    )),
                                    ChipData(
                                        FFLocalizations.of(context).getText(
                                      '5lx0u6if' /* 11:00 AM */,
                                    )),
                                    ChipData(
                                        FFLocalizations.of(context).getText(
                                      '29vzhev2' /* 12:00 PM */,
                                    )),
                                    ChipData(
                                        FFLocalizations.of(context).getText(
                                      '82pffa6o' /* 1:00 PM */,
                                    )),
                                    ChipData(
                                        FFLocalizations.of(context).getText(
                                      'd82vc0v5' /* 2:00 PM */,
                                    )),
                                    ChipData(
                                        FFLocalizations.of(context).getText(
                                      'msvfuv9t' /* 3:00 PM */,
                                    )),
                                    ChipData(
                                        FFLocalizations.of(context).getText(
                                      'wx1mks9p' /* 4:00 PM */,
                                    )),
                                    ChipData(
                                        FFLocalizations.of(context).getText(
                                      'jv28vu7h' /* 5:00 PM */,
                                    )),
                                    ChipData(
                                        FFLocalizations.of(context).getText(
                                      '68mah6ji' /* 6:00 PM */,
                                    ))
                                  ],
                                  onChanged: (val) => safeSetState(
                                      () => _model.choiceChipsValues = val),
                                  selectedChipStyle: ChipStyle(
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'General Sans',
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    iconColor:
                                        FlutterFlowTheme.of(context).info,
                                    iconSize: 16.0,
                                    labelPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            15.0, 6.0, 15.0, 6.0),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  unselectedChipStyle: ChipStyle(
                                    backgroundColor:
                                        FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'General Sans',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    iconColor: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    iconSize: 16.0,
                                    labelPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            15.0, 7.0, 15.0, 7.0),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  chipSpacing: 10.0,
                                  rowSpacing: 10.0,
                                  multiselect: true,
                                  initialized: _model.choiceChipsValues != null,
                                  alignment: WrapAlignment.spaceBetween,
                                  controller:
                                      _model.choiceChipsValueController ??=
                                          FormFieldController<List<String>>(
                                    [],
                                  ),
                                  wrapped: true,
                                ),
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
                      padding: EdgeInsets.all(15.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          await _model.pageViewController?.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        text: FFLocalizations.of(context).getText(
                          'dnuhb1zr' /* Continue */,
                        ),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 50.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'General Sans',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ].divide(SizedBox(height: 20.0)),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  'v871fhf8' /* Let professional know why you'... */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'General Sans',
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              Wrap(
                                spacing: 0.0,
                                runSpacing: 10.0,
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                direction: Axis.horizontal,
                                runAlignment: WrapAlignment.start,
                                verticalDirection: VerticalDirection.down,
                                clipBehavior: Clip.none,
                                children: [
                                  wrapWithModel(
                                    model: _model.radioListItemModel1,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: FFLocalizations.of(context).getText(
                                        'smw8gnrr' /* I want to avoid last-minute st... */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel2,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: FFLocalizations.of(context).getText(
                                        'jphin6au' /* I need to plan my schedule bet... */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel3,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: FFLocalizations.of(context).getText(
                                        'ds9adnrx' /* I need to make sure I get the ... */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel4,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: FFLocalizations.of(context).getText(
                                        'bwdv13xo' /* I want peace of mind. */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel5,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: FFLocalizations.of(context).getText(
                                        'sq4gg8h7' /* I have a busy schedule. */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel6,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: FFLocalizations.of(context).getText(
                                        '2xe6fbpc' /* I want to prepare my home prop... */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel7,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: FFLocalizations.of(context).getText(
                                        'yb8mk2p6' /* I don't want to deal with serv... */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel8,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: FFLocalizations.of(context).getText(
                                        'okiy79ky' /* Other */,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller:
                                      _model.rescheduleMessageTextController,
                                  focusNode: _model.rescheduleMessageFocusNode,
                                  autofocus: false,
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.next,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'General Sans',
                                          letterSpacing: 0.0,
                                        ),
                                    hintText:
                                        FFLocalizations.of(context).getText(
                                      '01mrj0bv' /* Type your reschedule message..... */,
                                    ),
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'General Sans',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    filled: true,
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            15.0, 20.0, 15.0, 20.0),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'General Sans',
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  maxLines: null,
                                  minLines: 4,
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primaryText,
                                  validator: _model
                                      .rescheduleMessageTextControllerValidator
                                      .asValidator(context),
                                  inputFormatters: [
                                    if (!isAndroid && !isiOS)
                                      TextInputFormatter.withFunction(
                                          (oldValue, newValue) {
                                        return TextEditingValue(
                                          selection: newValue.selection,
                                          text: newValue.text.toCapitalization(
                                              TextCapitalization.words),
                                        );
                                      }),
                                  ],
                                ),
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
                      padding: EdgeInsets.all(15.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          await _model.pageViewController?.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        text: FFLocalizations.of(context).getText(
                          '86yynfe2' /* Confirm Booking */,
                        ),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 50.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
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
                wrapWithModel(
                  model: _model.successWidgetModel,
                  updateCallback: () => safeSetState(() {}),
                  child: SuccessWidgetWidget(
                    title: FFLocalizations.of(context).getText(
                      'g3earaf7' /* Reschedule Submitted Successfu... */,
                    ),
                    description: FFLocalizations.of(context).getText(
                      'b03a3zpk' /* Your reschedule request was su... */,
                    ),
                    btnText: FFLocalizations.of(context).getText(
                      'fzfggjue' /* OK */,
                    ),
                    btnAction: () async {
                      context.pushNamed(BookingsWidget.routeName);
                    },
                  ),
                ),
                wrapWithModel(
                  model: _model.failedWidgetModel,
                  updateCallback: () => safeSetState(() {}),
                  child: FailedWidgetWidget(
                    title: FFLocalizations.of(context).getText(
                      'aqxkjdro' /* Failed to reschedule booking! */,
                    ),
                    description: FFLocalizations.of(context).getText(
                      'jrp3z1qr' /* Sorry! Something went wrong wh... */,
                    ),
                    btnText: FFLocalizations.of(context).getText(
                      'u3bhichd' /* Try again */,
                    ),
                    btnAction: () async {
                      await _model.pageViewController?.animateToPage(
                        0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
