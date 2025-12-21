import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/provider_part/components_provider/drawer_content/drawer_content_widget.dart';
import '/provider_part/components_provider/job_item_cancelled/job_item_cancelled_widget.dart';
import '/provider_part/components_provider/job_item_completed/job_item_completed_widget.dart';
import '/provider_part/components_provider/job_item_in_progress/job_item_in_progress_widget.dart';
import '/provider_part/components_provider/job_item_upcoming/job_item_upcoming_widget.dart';
import '/provider_part/components_provider/message_btn/message_btn_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'jobs_model.dart';
export 'jobs_model.dart';

class JobsWidget extends StatefulWidget {
  const JobsWidget({
    super.key,
    required this.initialTab,
  });

  final int? initialTab;

  static String routeName = 'Jobs';
  static String routePath = '/jobs';

  @override
  State<JobsWidget> createState() => _JobsWidgetState();
}

class _JobsWidgetState extends State<JobsWidget> with TickerProviderStateMixin {
  late JobsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => JobsModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 4,
      initialIndex: min(
          valueOrDefault<int>(
            widget!.initialTab,
            0,
          ),
          3),
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
        drawer: Drawer(
          elevation: 16.0,
          child: wrapWithModel(
            model: _model.drawerContentModel,
            updateCallback: () => safeSetState(() {}),
            child: DrawerContentWidget(
              activePage: 'my_jobs',
            ),
          ),
        ),
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
                  children: [
                    FlutterFlowIconButton(
                      borderRadius: 12.0,
                      buttonSize: 40.0,
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      icon: Icon(
                        FFIcons.kmenuFries,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        scaffoldKey.currentState!.openDrawer();
                      },
                    ),
                    Flexible(
                      child: Text(
                        FFLocalizations.of(context).getText(
                          '2vqs6c79' /* My Jobs */,
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
              wrapWithModel(
                model: _model.messageBtnModel,
                updateCallback: () => safeSetState(() {}),
                child: MessageBtnWidget(),
              ),
            ].divide(SizedBox(width: 20.0)),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Align(
                alignment: Alignment(0.0, 0),
                child: TabBar(
                  isScrollable: true,
                  labelColor: FlutterFlowTheme.of(context).primary,
                  unselectedLabelColor:
                      FlutterFlowTheme.of(context).secondaryText,
                  labelStyle: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'General Sans',
                        fontSize: 15.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                  unselectedLabelStyle:
                      FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: 'General Sans',
                            fontSize: 15.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                  indicatorColor: FlutterFlowTheme.of(context).primary,
                  tabs: [
                    Tab(
                      text: FFLocalizations.of(context).getText(
                        'r46je7zi' /* Upcoming */,
                      ),
                    ),
                    Tab(
                      text: FFLocalizations.of(context).getText(
                        'jl2sauoi' /* In Progress */,
                      ),
                    ),
                    Tab(
                      text: FFLocalizations.of(context).getText(
                        '31f9ekf2' /* Completed */,
                      ),
                    ),
                    Tab(
                      text: FFLocalizations.of(context).getText(
                        'p8r204jy' /* Canceled */,
                      ),
                    ),
                  ],
                  controller: _model.tabBarController,
                  onTap: (i) async {
                    [() async {}, () async {}, () async {}, () async {}][i]();
                  },
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _model.tabBarController,
                  children: [
                    KeepAliveWidgetWrapper(
                      builder: (context) => Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      FFLocalizations.of(context).getText(
                                        'lxcrhxgu' /* Upcoming Jobs (24) */,
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
                                  ),
                                  FlutterFlowIconButton(
                                    borderRadius: 12.0,
                                    buttonSize: 35.0,
                                    icon: Icon(
                                      FFIcons.ksort40,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 20.0,
                                    ),
                                    onPressed: () {
                                      print('IconButton pressed ...');
                                    },
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
                                    model: _model.jobItemUpcomingModel1,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobItemUpcomingWidget(
                                      img:
                                          'https://plus.unsplash.com/premium_photo-1679500354595-0feead204a28?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8S2l0Y2hlbiUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                      title:
                                          FFLocalizations.of(context).getText(
                                        'f3nz5hce' /* Kitchen Cleaning & 1 other */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobItemUpcomingModel2,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobItemUpcomingWidget(
                                      img:
                                          'https://images.unsplash.com/photo-1714647211955-95c3104dc418?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8TW92ZSUyMGluJTIwJTJGJTIwTW92ZSUyMG91dCUyMENsZWFuaW5nJ3xlbnwwfHwwfHx8MA%3D%3D',
                                      title:
                                          FFLocalizations.of(context).getText(
                                        'dnhyl7hm' /* Move-in / Move-out Cleaning */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobItemUpcomingModel3,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobItemUpcomingWidget(
                                      img:
                                          'https://plus.unsplash.com/premium_photo-1678718606857-d4820cecc9bf?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8VXBob2xzdGVyeSUyMGFuZCUyMEZ1cm5pdHVyZSUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                      title:
                                          FFLocalizations.of(context).getText(
                                        'd2i77uue' /* Upholstery and Furniture Clean... */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobItemUpcomingModel4,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobItemUpcomingWidget(
                                      img:
                                          'https://plus.unsplash.com/premium_photo-1733342467205-fa328fc2f21e?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8TGF1bmRyeSUyMFNlcnZpY2VzfGVufDB8fDB8fHww',
                                      title:
                                          FFLocalizations.of(context).getText(
                                        'tx1cbwo0' /* Laundry Services & 3 others */,
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
                    KeepAliveWidgetWrapper(
                      builder: (context) => Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      FFLocalizations.of(context).getText(
                                        'zhgg0w91' /* Jobs in Progress (4) */,
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
                                  ),
                                  FlutterFlowIconButton(
                                    borderRadius: 12.0,
                                    buttonSize: 35.0,
                                    icon: Icon(
                                      FFIcons.ksort40,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 20.0,
                                    ),
                                    onPressed: () {
                                      print('IconButton pressed ...');
                                    },
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
                                    model: _model.jobItemInProgressModel1,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobItemInProgressWidget(
                                      img:
                                          'https://plus.unsplash.com/premium_photo-1733342467205-fa328fc2f21e?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8TGF1bmRyeSUyMFNlcnZpY2VzfGVufDB8fDB8fHww',
                                      title:
                                          FFLocalizations.of(context).getText(
                                        'klilh0of' /* Laundry Services & 3 more */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobItemInProgressModel2,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobItemInProgressWidget(
                                      img:
                                          'https://plus.unsplash.com/premium_photo-1664372899446-0d43797d8223?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8QmF0aHJvb20lMjBDbGVhbmluZ3xlbnwwfHwwfHx8MA%3D%3D',
                                      title:
                                          FFLocalizations.of(context).getText(
                                        'dywtbsax' /* Bathroom Cleaning & 1 more */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobItemInProgressModel3,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobItemInProgressWidget(
                                      img:
                                          'https://images.unsplash.com/photo-1627905646269-7f034dcc5738?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8RGVlcCUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                      title:
                                          FFLocalizations.of(context).getText(
                                        '19silul4' /* Deep Cleaning */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobItemInProgressModel4,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobItemInProgressWidget(
                                      img:
                                          'https://plus.unsplash.com/premium_photo-1678718606857-d4820cecc9bf?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8VXBob2xzdGVyeSUyMGFuZCUyMEZ1cm5pdHVyZSUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                      title:
                                          FFLocalizations.of(context).getText(
                                        'tlanfiiv' /* Upholstery and Furniture Clean... */,
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
                    KeepAliveWidgetWrapper(
                      builder: (context) => Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      FFLocalizations.of(context).getText(
                                        '2fi7a00p' /* Completed Jobs (64) */,
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
                                  ),
                                  FlutterFlowIconButton(
                                    borderRadius: 12.0,
                                    buttonSize: 35.0,
                                    icon: Icon(
                                      FFIcons.ksort40,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 20.0,
                                    ),
                                    onPressed: () {
                                      print('IconButton pressed ...');
                                    },
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
                                    model: _model.jobItemCompletedModel1,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobItemCompletedWidget(
                                      img:
                                          'https://images.unsplash.com/photo-1601160458000-2b11f9fa1a0e?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjR8fGhvdXNlJTIwY2xlYW5pbmd8ZW58MHx8MHx8fDA%3D',
                                      title:
                                          FFLocalizations.of(context).getText(
                                        'w16tmvz5' /* General House Cleaning */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobItemCompletedModel2,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobItemCompletedWidget(
                                      img:
                                          'https://plus.unsplash.com/premium_photo-1679500354675-415cb777713c?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mjl8fGhvdXNlJTIwY2xlYW5pbmd8ZW58MHx8MHx8fDA%3D',
                                      title:
                                          FFLocalizations.of(context).getText(
                                        'ui8r02lu' /* General House Cleaning */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobItemCompletedModel3,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobItemCompletedWidget(
                                      img:
                                          'https://plus.unsplash.com/premium_photo-1676651425381-d737e1e1176d?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mzd8fGhvdXNlJTIwY2xlYW5pbmd8ZW58MHx8MHx8fDA%3D',
                                      title:
                                          FFLocalizations.of(context).getText(
                                        '3xcmwinf' /* General House Cleaning */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobItemCompletedModel4,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobItemCompletedWidget(
                                      img:
                                          'https://plus.unsplash.com/premium_photo-1682098236459-afdc150c80a0?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDV8fGhvdXNlJTIwY2xlYW5pbmd8ZW58MHx8MHx8fDA%3D',
                                      title:
                                          FFLocalizations.of(context).getText(
                                        '9j0vh0gc' /* General House Cleaning */,
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
                    KeepAliveWidgetWrapper(
                      builder: (context) => Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    FFLocalizations.of(context).getText(
                                      'enoy9372' /* Canceled Jobs (8) */,
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
                                  FlutterFlowIconButton(
                                    borderRadius: 12.0,
                                    buttonSize: 35.0,
                                    icon: Icon(
                                      FFIcons.ksort40,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 20.0,
                                    ),
                                    onPressed: () {
                                      print('IconButton pressed ...');
                                    },
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
                                    model: _model.jobItemCancelledModel1,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobItemCancelledWidget(
                                      img:
                                          'https://plus.unsplash.com/premium_photo-1675884215324-c3da4f3c3ba2?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8bW92aW5nJTIwaGVscHxlbnwwfHwwfHx8MA%3D%3D',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobItemCancelledModel2,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobItemCancelledWidget(
                                      img:
                                          'https://images.unsplash.com/photo-1657049199023-87fb439d47c5?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8bW92aW5nJTIwaGVscHxlbnwwfHwwfHx8MA%3D%3D',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobItemCancelledModel3,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobItemCancelledWidget(
                                      img:
                                          'https://plus.unsplash.com/premium_photo-1680300960805-e76bb338d59e?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fG1vdmluZyUyMGhlbHB8ZW58MHx8MHx8fDA%3D',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobItemCancelledModel4,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobItemCancelledWidget(
                                      img:
                                          'https://images.unsplash.com/photo-1698917414969-feade59e3343?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fG1vdmluZyUyMGhlbHB8ZW58MHx8MHx8fDA%3D',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobItemCancelledModel5,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobItemCancelledWidget(
                                      img:
                                          'https://images.unsplash.com/photo-1543234060-81df8a10fbf0?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjR8fG1vdmluZyUyMGhlbHB8ZW58MHx8MHx8fDA%3D',
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
