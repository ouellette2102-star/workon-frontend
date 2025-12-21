import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/provider_part/components_provider/drawer_content/drawer_content_widget.dart';
import '/provider_part/components_provider/job_request_item/job_request_item_widget.dart';
import '/provider_part/components_provider/message_btn/message_btn_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'job_requests_model.dart';
export 'job_requests_model.dart';

class JobRequestsWidget extends StatefulWidget {
  const JobRequestsWidget({
    super.key,
    required this.initialTab,
  });

  final int? initialTab;

  static String routeName = 'JobRequests';
  static String routePath = '/jobRequests';

  @override
  State<JobRequestsWidget> createState() => _JobRequestsWidgetState();
}

class _JobRequestsWidgetState extends State<JobRequestsWidget>
    with TickerProviderStateMixin {
  late JobRequestsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => JobRequestsModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: min(
          valueOrDefault<int>(
            widget!.initialTab,
            0,
          ),
          1),
    )..addListener(() => safeSetState(() {}));

    _model.searchJobRequestTextController ??= TextEditingController();
    _model.searchJobRequestFocusNode ??= FocusNode();
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
              activePage: 'job_requests',
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
                          '53au0kvn' /* Job Requests */,
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
                        'j3k543pq' /* General Requests */,
                      ),
                    ),
                    Tab(
                      text: FFLocalizations.of(context).getText(
                        'p229oxl3' /* Pro Requests */,
                      ),
                    ),
                  ],
                  controller: _model.tabBarController,
                  onTap: (i) async {
                    [() async {}, () async {}][i]();
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
                              FlutterFlowChoiceChips(
                                options: [
                                  ChipData(FFLocalizations.of(context).getText(
                                    'quaor7f5' /* All */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    '3a1g948y' /* New */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'wumwpeug' /* High Priority */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'kc2j5x78' /* Nearby */,
                                  ))
                                ],
                                onChanged: (val) => safeSetState(() =>
                                    _model.choiceChipsValue = val?.firstOrNull),
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
                                  iconColor: FlutterFlowTheme.of(context).info,
                                  iconSize: 16.0,
                                  labelPadding: EdgeInsetsDirectional.fromSTEB(
                                      15.0, 6.0, 15.0, 6.0),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                unselectedChipStyle: ChipStyle(
                                  backgroundColor: FlutterFlowTheme.of(context)
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
                                  labelPadding: EdgeInsetsDirectional.fromSTEB(
                                      15.0, 7.0, 15.0, 7.0),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                chipSpacing: 10.0,
                                rowSpacing: 10.0,
                                multiselect: false,
                                initialized: _model.choiceChipsValue != null,
                                alignment: WrapAlignment.start,
                                controller:
                                    _model.choiceChipsValueController ??=
                                        FormFieldController<List<String>>(
                                  [
                                    FFLocalizations.of(context).getText(
                                      'fgl3tvhk' /* All */,
                                    )
                                  ],
                                ),
                                wrapped: false,
                              ),
                              Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller:
                                      _model.searchJobRequestTextController,
                                  focusNode: _model.searchJobRequestFocusNode,
                                  autofocus: false,
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
                                      '279dp2gj' /* Search service, place, etc... */,
                                    ),
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'General Sans',
                                          fontSize: 13.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    filled: true,
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            15.0, 18.0, 53.0, 18.0),
                                    prefixIcon: Icon(
                                      FFIcons.ksearchNormal01,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 16.0,
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'General Sans',
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primaryText,
                                  validator: _model
                                      .searchJobRequestTextControllerValidator
                                      .asValidator(context),
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
                                        'yy3mkuh5' /* Available Now (354) */,
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
                                    model: _model.jobRequestItemModel1,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobRequestItemWidget(
                                      img:
                                          'https://images.unsplash.com/photo-1686479037314-88bc3732de16?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8UGV0JTIwQXJlYSUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                      title:
                                          FFLocalizations.of(context).getText(
                                        'xz1s3huq' /* Pet Area Cleaning & 2 others */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobRequestItemModel2,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobRequestItemWidget(
                                      img:
                                          'https://plus.unsplash.com/premium_photo-1684407616444-d52caf1a828f?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8R3JlZW4lMjBDbGVhbmluZ3xlbnwwfHwwfHx8MA%3D%3D',
                                      title:
                                          FFLocalizations.of(context).getText(
                                        '7mgarq3m' /* Green Cleaning */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobRequestItemModel3,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobRequestItemWidget(
                                      img:
                                          'https://plus.unsplash.com/premium_photo-1679500354595-0feead204a28?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8S2l0Y2hlbiUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                      title: 'Kitchen Cleaning & 1 other',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobRequestItemModel4,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobRequestItemWidget(
                                      img:
                                          'https://plus.unsplash.com/premium_photo-1664372899354-99e6d9f50f58?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fEJhdGhyb29tJTIwQ2xlYW5pbmd8ZW58MHx8MHx8fDA%3D',
                                      title: 'Bathroom Cleaning',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobRequestItemModel5,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobRequestItemWidget(
                                      img:
                                          'https://images.unsplash.com/photo-1714647211955-95c3104dc418?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8TW92ZSUyMGluJTIwJTJGJTIwTW92ZSUyMG91dCUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                      title: 'Move-in / Move-out Cleaning',
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
                            15.0, 0.0, 15.0, 0.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
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
                                    model: _model.jobRequestItemModel6,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobRequestItemWidget(
                                      img:
                                          'https://images.unsplash.com/photo-1686479037314-88bc3732de16?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8UGV0JTIwQXJlYSUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                      title:
                                          FFLocalizations.of(context).getText(
                                        'qulm0i09' /* Pet Area Cleaning & 2 others */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobRequestItemModel7,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobRequestItemWidget(
                                      img:
                                          'https://plus.unsplash.com/premium_photo-1684407616444-d52caf1a828f?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8R3JlZW4lMjBDbGVhbmluZ3xlbnwwfHwwfHx8MA%3D%3D',
                                      title:
                                          FFLocalizations.of(context).getText(
                                        '78qxcov7' /* Green Cleaning */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobRequestItemModel8,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobRequestItemWidget(
                                      img:
                                          'https://plus.unsplash.com/premium_photo-1679500354595-0feead204a28?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8S2l0Y2hlbiUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                      title: 'Kitchen Cleaning & 1 other',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobRequestItemModel9,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobRequestItemWidget(
                                      img:
                                          'https://plus.unsplash.com/premium_photo-1664372899354-99e6d9f50f58?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fEJhdGhyb29tJTIwQ2xlYW5pbmd8ZW58MHx8MHx8fDA%3D',
                                      title: 'Bathroom Cleaning',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.jobRequestItemModel10,
                                    updateCallback: () => safeSetState(() {}),
                                    child: JobRequestItemWidget(
                                      img:
                                          'https://images.unsplash.com/photo-1714647211955-95c3104dc418?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8TW92ZSUyMGluJTIwJTJGJTIwTW92ZSUyMG91dCUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                      title: 'Move-in / Move-out Cleaning',
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
