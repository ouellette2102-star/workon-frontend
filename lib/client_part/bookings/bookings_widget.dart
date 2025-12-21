import '/client_part/components_client/booking_item_cancelled/booking_item_cancelled_widget.dart';
import '/client_part/components_client/booking_item_completed/booking_item_completed_widget.dart';
import '/client_part/components_client/booking_item_upcoming/booking_item_upcoming_widget.dart';
import '/client_part/components_client/mig_nav_bar/mig_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bookings_model.dart';
export 'bookings_model.dart';

class BookingsWidget extends StatefulWidget {
  const BookingsWidget({super.key});

  static String routeName = 'Bookings';
  static String routePath = '/bookings';

  @override
  State<BookingsWidget> createState() => _BookingsWidgetState();
}

class _BookingsWidgetState extends State<BookingsWidget>
    with TickerProviderStateMixin {
  late BookingsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BookingsModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        'assets/images/Sparkly_Logo.png',
                        width: 30.0,
                        height: 30.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        FFLocalizations.of(context).getText(
                          'shq6q3wd' /* My Bookings */,
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
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  FlutterFlowIconButton(
                    borderRadius: 14.0,
                    buttonSize: 40.0,
                    fillColor: _model.view == 'calendar'
                        ? FlutterFlowTheme.of(context).primary
                        : Colors.transparent,
                    icon: Icon(
                      FFIcons.kcalendar01,
                      color: _model.view == 'calendar'
                          ? FlutterFlowTheme.of(context).info
                          : FlutterFlowTheme.of(context).primaryText,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      if (_model.view == 'calendar') {
                        _model.view = 'bookings';
                        safeSetState(() {});
                      } else {
                        _model.view = 'calendar';
                        safeSetState(() {});
                      }
                    },
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
                ].divide(SizedBox(width: 5.0)),
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
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(),
                  child: Builder(
                    builder: (context) {
                      if (_model.view == 'calendar') {
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 0.0, 20.0, 0.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
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
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      iconColor: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      weekFormat: false,
                                      weekStartsMonday: false,
                                      initialDate: getCurrentTimestamp,
                                      rowHeight: 40.0,
                                      onChange:
                                          (DateTimeRange? newSelectedDate) {
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
                                      dayOfWeekStyle:
                                          FlutterFlowTheme.of(context)
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
                                            fontWeight: FontWeight.w500,
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
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        FFLocalizations.of(context).getText(
                                          '5a0m26cn' /* Upcoming Services */,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'General Sans',
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    FFButtonWidget(
                                      onPressed: () {
                                        print('Button pressed ...');
                                      },
                                      text: FFLocalizations.of(context).getText(
                                        'imdd26jg' /* See All */,
                                      ),
                                      options: FFButtonOptions(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5.0, 0.0, 5.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: Colors.transparent,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'General Sans',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 13.0,
                                              letterSpacing: 0.0,
                                            ),
                                        elevation: 0.0,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 20.0)),
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
                                      model: _model.bookingItemUpcomingModel1,
                                      updateCallback: () => safeSetState(() {}),
                                      child: BookingItemUpcomingWidget(
                                        img:
                                            'https://images.unsplash.com/photo-1669101602108-fa5ba89507ee?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8RGVlcCUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                        title:
                                            FFLocalizations.of(context).getText(
                                          'zolk80mg' /* Deep Cleaning */,
                                        ),
                                      ),
                                    ),
                                    wrapWithModel(
                                      model: _model.bookingItemUpcomingModel2,
                                      updateCallback: () => safeSetState(() {}),
                                      child: BookingItemUpcomingWidget(
                                        img:
                                            'https://images.unsplash.com/photo-1686479037314-88bc3732de16?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8UGV0JTIwQXJlYSUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                        title:
                                            FFLocalizations.of(context).getText(
                                          '6jxe3opx' /* Pet Area Cleaning */,
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
                        );
                      } else {
                        return Column(
                          children: [
                            Align(
                              alignment: Alignment(0.0, 0),
                              child: TabBar(
                                labelColor:
                                    FlutterFlowTheme.of(context).primary,
                                unselectedLabelColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                                labelStyle: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: 'General Sans',
                                      fontSize: 15.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                unselectedLabelStyle:
                                    FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'General Sans',
                                          fontSize: 15.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                indicatorColor:
                                    FlutterFlowTheme.of(context).primary,
                                tabs: [
                                  Tab(
                                    text: FFLocalizations.of(context).getText(
                                      'a8hot99o' /* Upcoming */,
                                    ),
                                  ),
                                  Tab(
                                    text: FFLocalizations.of(context).getText(
                                      'c5xk597w' /* Completed */,
                                    ),
                                  ),
                                  Tab(
                                    text: FFLocalizations.of(context).getText(
                                      '0vfdnlif' /* Cancelled */,
                                    ),
                                  ),
                                ],
                                controller: _model.tabBarController,
                                onTap: (i) async {
                                  [() async {}, () async {}, () async {}][i]();
                                },
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _model.tabBarController,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20.0, 0.0, 20.0, 0.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Wrap(
                                            spacing: 0.0,
                                            runSpacing: 20.0,
                                            alignment: WrapAlignment.start,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.start,
                                            direction: Axis.horizontal,
                                            runAlignment: WrapAlignment.start,
                                            verticalDirection:
                                                VerticalDirection.down,
                                            clipBehavior: Clip.none,
                                            children: [
                                              wrapWithModel(
                                                model: _model
                                                    .bookingItemUpcomingModel3,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child:
                                                    BookingItemUpcomingWidget(
                                                  img:
                                                      'https://images.unsplash.com/photo-1669101602108-fa5ba89507ee?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8RGVlcCUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                                  title: FFLocalizations.of(
                                                          context)
                                                      .getText(
                                                    '4dcjmzl1' /* Deep Cleaning */,
                                                  ),
                                                ),
                                              ),
                                              wrapWithModel(
                                                model: _model
                                                    .bookingItemUpcomingModel4,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child:
                                                    BookingItemUpcomingWidget(
                                                  img:
                                                      'https://images.unsplash.com/photo-1714647211955-95c3104dc418?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8TW92ZSUyMGluJTIwJTJGJTIwTW92ZSUyMG91dCUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                                  title: FFLocalizations.of(
                                                          context)
                                                      .getText(
                                                    'nzmrj3wp' /* Move-in / Move-out Cleaning */,
                                                  ),
                                                ),
                                              ),
                                              wrapWithModel(
                                                model: _model
                                                    .bookingItemUpcomingModel5,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child:
                                                    BookingItemUpcomingWidget(
                                                  img:
                                                      'https://images.unsplash.com/photo-1686479037314-88bc3732de16?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8UGV0JTIwQXJlYSUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                                  title: FFLocalizations.of(
                                                          context)
                                                      .getText(
                                                    'cpzzefek' /* Pet Area Cleaning */,
                                                  ),
                                                ),
                                              ),
                                              wrapWithModel(
                                                model: _model
                                                    .bookingItemUpcomingModel6,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child:
                                                    BookingItemUpcomingWidget(
                                                  img:
                                                      'https://plus.unsplash.com/premium_photo-1684407616444-d52caf1a828f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8R3JlZW4lMjBDbGVhbmluZ3xlbnwwfHwwfHx8MA%3D%3D',
                                                  title: FFLocalizations.of(
                                                          context)
                                                      .getText(
                                                    '3oxwu2ps' /* Green Cleaning */,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]
                                            .addToStart(SizedBox(height: 20.0))
                                            .addToEnd(SizedBox(height: 20.0)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20.0, 0.0, 20.0, 0.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Wrap(
                                            spacing: 0.0,
                                            runSpacing: 20.0,
                                            alignment: WrapAlignment.start,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.start,
                                            direction: Axis.horizontal,
                                            runAlignment: WrapAlignment.start,
                                            verticalDirection:
                                                VerticalDirection.down,
                                            clipBehavior: Clip.none,
                                            children: [
                                              wrapWithModel(
                                                model: _model
                                                    .bookingItemCompletedModel1,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child:
                                                    BookingItemCompletedWidget(
                                                  img:
                                                      'https://plus.unsplash.com/premium_photo-1679775634754-f7ca432b85d2?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8RnVybml0dXJlJTIwQ2xlYW5pbmd8ZW58MHx8MHx8fDA%3D',
                                                  title: FFLocalizations.of(
                                                          context)
                                                      .getText(
                                                    '3ylzybzv' /* Furniture Cleaning */,
                                                  ),
                                                ),
                                              ),
                                              wrapWithModel(
                                                model: _model
                                                    .bookingItemCompletedModel2,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child:
                                                    BookingItemCompletedWidget(
                                                  img:
                                                      'https://plus.unsplash.com/premium_photo-1664015821142-32f429a6608f?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8QmVkcm9vbSUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                                  title: FFLocalizations.of(
                                                          context)
                                                      .getText(
                                                    'pi4d4fxt' /* Bedroom Cleaning */,
                                                  ),
                                                ),
                                              ),
                                              wrapWithModel(
                                                model: _model
                                                    .bookingItemCompletedModel3,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child:
                                                    BookingItemCompletedWidget(
                                                  img:
                                                      'https://plus.unsplash.com/premium_photo-1679500354245-ce715b79a606?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8R2VuZXJhbCUyMEhvdXNlJTIwQ2xlYW5pbmd8ZW58MHx8MHx8fDA%3D',
                                                  title: FFLocalizations.of(
                                                          context)
                                                      .getText(
                                                    '6s8wopq3' /* General House Cleaning */,
                                                  ),
                                                ),
                                              ),
                                              wrapWithModel(
                                                model: _model
                                                    .bookingItemCompletedModel4,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child:
                                                    BookingItemCompletedWidget(
                                                  img:
                                                      'https://plus.unsplash.com/premium_photo-1679500354595-0feead204a28?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8S2l0Y2hlbiUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                                  title: FFLocalizations.of(
                                                          context)
                                                      .getText(
                                                    'szcilq7p' /* Kitchen Cleaning */,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]
                                            .addToStart(SizedBox(height: 20.0))
                                            .addToEnd(SizedBox(height: 20.0)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20.0, 0.0, 20.0, 0.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Wrap(
                                            spacing: 0.0,
                                            runSpacing: 20.0,
                                            alignment: WrapAlignment.start,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.start,
                                            direction: Axis.horizontal,
                                            runAlignment: WrapAlignment.start,
                                            verticalDirection:
                                                VerticalDirection.down,
                                            clipBehavior: Clip.none,
                                            children: [
                                              wrapWithModel(
                                                model: _model
                                                    .bookingItemCancelledModel1,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child:
                                                    BookingItemCancelledWidget(
                                                  img:
                                                      'https://plus.unsplash.com/premium_photo-1664372899197-8e299938226f?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8QmF0aHJvb20lMjBDbGVhbmluZ3xlbnwwfHwwfHx8MA%3D%3D',
                                                  title: FFLocalizations.of(
                                                          context)
                                                      .getText(
                                                    'bgford2i' /* Bathroom Cleaning */,
                                                  ),
                                                ),
                                              ),
                                              wrapWithModel(
                                                model: _model
                                                    .bookingItemCancelledModel2,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child:
                                                    BookingItemCancelledWidget(
                                                  img:
                                                      'https://images.unsplash.com/photo-1669101602108-fa5ba89507ee?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8RGVlcCUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                                  title: FFLocalizations.of(
                                                          context)
                                                      .getText(
                                                    'y7zshyzz' /* Deep Cleaning */,
                                                  ),
                                                ),
                                              ),
                                              wrapWithModel(
                                                model: _model
                                                    .bookingItemCancelledModel3,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child:
                                                    BookingItemCancelledWidget(
                                                  img:
                                                      'https://images.unsplash.com/photo-1690996260304-0535a42afb31?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8TW92ZSUyMGluJTIwJTJGJTIwTW92ZSUyMG91dCUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                                  title: FFLocalizations.of(
                                                          context)
                                                      .getText(
                                                    '0pr6drwn' /* Move-in / Move-out Cleaning */,
                                                  ),
                                                ),
                                              ),
                                              wrapWithModel(
                                                model: _model
                                                    .bookingItemCancelledModel4,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child:
                                                    BookingItemCancelledWidget(
                                                  img:
                                                      'https://plus.unsplash.com/premium_photo-1678718606857-d4820cecc9bf?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8VXBob2xzdGVyeSUyMGFuZCUyMEZ1cm5pdHVyZSUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                                  title: FFLocalizations.of(
                                                          context)
                                                      .getText(
                                                    '6r6opa4g' /* Upholstery and Furniture Clean... */,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]
                                            .addToStart(SizedBox(height: 20.0))
                                            .addToEnd(SizedBox(height: 20.0)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.migNavBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: MigNavBarWidget(
                    activePage: 'bookings',
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
