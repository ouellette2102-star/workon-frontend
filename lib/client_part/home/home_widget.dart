import '/client_part/components_client/banner/banner_widget.dart';
import '/client_part/components_client/filter_options/filter_options_widget.dart';
import '/client_part/components_client/mig_nav_bar/mig_nav_bar_widget.dart';
import '/client_part/components_client/service_item/service_item_widget.dart';
import '/client_part/mission_detail/mission_detail_widget.dart';
import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/missions/mission_models.dart';
import '/services/missions/missions_service.dart';
import 'dart:ui';
import '/index.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_model.dart';
export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  static String routeName = 'Home';
  static String routePath = '/home';

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late HomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());

    _model.searchTextController ??= TextEditingController();
    _model.searchFocusNode ??= FocusNode();

    // PR-F05: Load missions on init
    _loadMissions();
  }

  /// PR-F05: Load nearby missions from backend.
  Future<void> _loadMissions() async {
    if (_model.missionsInitialized) return;
    _model.missionsInitialized = true;

    // Default location: Montreal (could be replaced with user's location)
    const defaultLat = 45.5017;
    const defaultLng = -73.5673;
    const defaultRadius = 25.0;

    // Subscribe to state changes
    MissionsService.stateListenable.addListener(_onMissionsStateChanged);

    // Load missions
    await MissionsService.loadNearby(
      latitude: defaultLat,
      longitude: defaultLng,
      radiusKm: defaultRadius,
    );
  }

  /// PR-F05: Handle missions state changes.
  void _onMissionsStateChanged() {
    if (mounted) {
      safeSetState(() {
        _model.missionsState = MissionsService.state;
      });
    }
  }

  @override
  void dispose() {
    // PR-F05: Remove listener
    MissionsService.stateListenable.removeListener(_onMissionsStateChanged);
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
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).alternate,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/images/workonlogo2.jpg',
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/nomworkon.jpg',
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ].divide(SizedBox(width: 10.0)),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    alignment: AlignmentDirectional(1.0, -1.0),
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 12.0, 0.0),
                        child: Container(
                          width: 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).error,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ],
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
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 210.0,
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 25.0),
                            child: PageView(
                              controller: _model.pageViewController ??=
                                  PageController(initialPage: 0),
                              onPageChanged: (_) => safeSetState(() {}),
                              scrollDirection: Axis.horizontal,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 0.0, 20.0, 0.0),
                                  child: wrapWithModel(
                                    model: _model.bannerModel1,
                                    updateCallback: () => safeSetState(() {}),
                                    child: BannerWidget(),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 0.0, 20.0, 0.0),
                                  child: wrapWithModel(
                                    model: _model.bannerModel2,
                                    updateCallback: () => safeSetState(() {}),
                                    child: BannerWidget(),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 0.0, 20.0, 0.0),
                                  child: wrapWithModel(
                                    model: _model.bannerModel3,
                                    updateCallback: () => safeSetState(() {}),
                                    child: BannerWidget(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, 1.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 10.0),
                              child: smooth_page_indicator.SmoothPageIndicator(
                                controller: _model.pageViewController ??=
                                    PageController(initialPage: 0),
                                count: 3,
                                axisDirection: Axis.horizontal,
                                onDotClicked: (i) async {
                                  await _model.pageViewController!
                                      .animateToPage(
                                    i,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
                                  safeSetState(() {});
                                },
                                effect:
                                    smooth_page_indicator.ExpandingDotsEffect(
                                  expansionFactor: 4.0,
                                  spacing: 8.0,
                                  radius: 8.0,
                                  dotWidth: 6.0,
                                  dotHeight: 6.0,
                                  dotColor:
                                      FlutterFlowTheme.of(context).alternate,
                                  activeDotColor:
                                      FlutterFlowTheme.of(context).primary,
                                  paintStyle: PaintingStyle.fill,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                      child: Stack(
                        alignment: AlignmentDirectional(1.0, 0.0),
                        children: [
                          Container(
                            width: double.infinity,
                            child: TextFormField(
                              controller: _model.searchTextController,
                              focusNode: _model.searchFocusNode,
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
                                hintText: FFLocalizations.of(context).getText(
                                  'dsrubcm1' /* Try bedroom, kitchen cleaning,... */,
                                ),
                                hintStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'General Sans',
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    15.0, 20.0, 53.0, 20.0),
                                prefixIcon: Icon(
                                  FFIcons.ksearchNormal01,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 20.0,
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
                              validator: _model.searchTextControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 5.0, 0.0),
                            child: FlutterFlowIconButton(
                              borderRadius: 12.0,
                              buttonSize: 40.0,
                              fillColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              icon: Icon(
                                FFIcons.kfilter5,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 20.0,
                              ),
                              onPressed: () async {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  useSafeArea: true,
                                  context: context,
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      child: Padding(
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
                                        child: FilterOptionsWidget(),
                                      ),
                                    );
                                  },
                                ).then((value) => safeSetState(() {}));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
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
                                    'z2969tt7' /* Popular Services 🔥 */,
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
                                onPressed: () async {
                                  context.pushNamed(
                                      SingleCategoryWidget.routeName);
                                },
                                text: FFLocalizations.of(context).getText(
                                  'qqnjj6w1' /* See All */,
                                ),
                                options: FFButtonOptions(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5.0, 0.0, 5.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: Colors.transparent,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'General Sans',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 13.0,
                                        letterSpacing: 0.0,
                                      ),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ].divide(SizedBox(width: 20.0)),
                          ),
                          GridView(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 0.7,
                            ),
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              wrapWithModel(
                                model: _model.serviceItemModel1,
                                updateCallback: () => safeSetState(() {}),
                                child: ServiceItemWidget(
                                  img:
                                      'https://plus.unsplash.com/premium_photo-1664301014580-9d9941d1fb51?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8R2VuZXJhbCUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                  title: FFLocalizations.of(context).getText(
                                    '99wxhs3w' /* General Cleaning */,
                                  ),
                                ),
                              ),
                              wrapWithModel(
                                model: _model.serviceItemModel2,
                                updateCallback: () => safeSetState(() {}),
                                child: ServiceItemWidget(
                                  img:
                                      'https://plus.unsplash.com/premium_photo-1677683510057-cc85159ee770?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fEJlZHJvb20lMjBDbGVhbmluZ3xlbnwwfHwwfHx8MA%3D%3D',
                                  title: FFLocalizations.of(context).getText(
                                    'txpj1wdj' /* Bedroom Cleaning */,
                                  ),
                                ),
                              ),
                              wrapWithModel(
                                model: _model.serviceItemModel3,
                                updateCallback: () => safeSetState(() {}),
                                child: ServiceItemWidget(
                                  img:
                                      'https://plus.unsplash.com/premium_photo-1679500354595-0feead204a28?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8S2l0Y2hlbiUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                  title: FFLocalizations.of(context).getText(
                                    'ymc95k9l' /* Kitchen Cleaning */,
                                  ),
                                ),
                              ),
                              wrapWithModel(
                                model: _model.serviceItemModel4,
                                updateCallback: () => safeSetState(() {}),
                                child: ServiceItemWidget(
                                  img:
                                      'https://plus.unsplash.com/premium_photo-1664372899354-99e6d9f50f58?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fEJhdGhyb29tJTIwQ2xlYW5pbmd8ZW58MHx8MHx8fDA%3D',
                                  title: FFLocalizations.of(context).getText(
                                    'vlkvwy6o' /* Bathroom Cleaning */,
                                  ),
                                ),
                              ),
                              wrapWithModel(
                                model: _model.serviceItemModel5,
                                updateCallback: () => safeSetState(() {}),
                                child: ServiceItemWidget(
                                  img:
                                      'https://plus.unsplash.com/premium_photo-1679500355493-2a1ce67cb938?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8RGVlcCUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                  title: FFLocalizations.of(context).getText(
                                    'fzjc8dwo' /* Deep Cleaning */,
                                  ),
                                ),
                              ),
                              wrapWithModel(
                                model: _model.serviceItemModel6,
                                updateCallback: () => safeSetState(() {}),
                                child: ServiceItemWidget(
                                  img:
                                      'https://images.unsplash.com/photo-1714647211955-95c3104dc418?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8TW92ZSUyMGluJTIwJTJGJTIwTW92ZSUyMG91dCUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                                  title: FFLocalizations.of(context).getText(
                                    '3yotou48' /* Move-in / Move-out Cleaning */,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ].divide(SizedBox(height: 20.0)),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 0.0, 20.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  FFLocalizations.of(context).getText(
                                    '8p11c0kw' /* Just for you */,
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
                            ].divide(SizedBox(width: 20.0)),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      FlutterFlowTheme.of(context).primary,
                                      FlutterFlowTheme.of(context).secondary
                                    ],
                                    stops: [0.0, 1.0],
                                    begin: AlignmentDirectional(-1.0, 0.0),
                                    end: AlignmentDirectional(1.0, 0),
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Container(
                                    width: 130.0,
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            color: Color(0x3CFFFFFF),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Icon(
                                              Icons.auto_awesome_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              size: 30.0,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            'hkup8bi7' /* Painting Service */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'General Sans',
                                                color: Color(0xC4FFFFFF),
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            'ho868kcb' /* Save 30% */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'General Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                fontSize: 18.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        FFButtonWidget(
                                          onPressed: () {
                                            print('Button pressed ...');
                                          },
                                          text: FFLocalizations.of(context)
                                              .getText(
                                            '2h9k6qn2' /* Order Now */,
                                          ),
                                          options: FFButtonOptions(
                                            width: double.infinity,
                                            height: 35.0,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 0.0, 16.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: Color(0x49FFFFFF),
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily:
                                                          'General Sans',
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                      letterSpacing: 0.0,
                                                    ),
                                            elevation: 0.0,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ].divide(SizedBox(height: 10.0)),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF20D08F),
                                      Color(0xFF129E6C)
                                    ],
                                    stops: [0.0, 1.0],
                                    begin: AlignmentDirectional(-1.0, 0.0),
                                    end: AlignmentDirectional(1.0, 0),
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Container(
                                    width: 130.0,
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            color: Color(0x3CFFFFFF),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Icon(
                                              Icons.auto_awesome_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              size: 30.0,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            '9kffbm6o' /* Cleaning Service */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'General Sans',
                                                color: Color(0xC4FFFFFF),
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            'qzj56nsr' /* Save 56% */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'General Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                fontSize: 18.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        FFButtonWidget(
                                          onPressed: () {
                                            print('Button pressed ...');
                                          },
                                          text: FFLocalizations.of(context)
                                              .getText(
                                            'xdckgwqz' /* Order Now */,
                                          ),
                                          options: FFButtonOptions(
                                            width: double.infinity,
                                            height: 35.0,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 0.0, 16.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: Color(0x49FFFFFF),
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily:
                                                          'General Sans',
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                      letterSpacing: 0.0,
                                                    ),
                                            elevation: 0.0,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ].divide(SizedBox(height: 10.0)),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFF124E1),
                                      Color(0xFFA6119C)
                                    ],
                                    stops: [0.0, 1.0],
                                    begin: AlignmentDirectional(-1.0, 0.0),
                                    end: AlignmentDirectional(1.0, 0),
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Container(
                                    width: 130.0,
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            color: Color(0x3CFFFFFF),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Icon(
                                              Icons.auto_awesome_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              size: 30.0,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            'ddkjpw4y' /* Plumbing Service */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'General Sans',
                                                color: Color(0xC4FFFFFF),
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            'jo75l1nq' /* Save 24% */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'General Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                fontSize: 18.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        FFButtonWidget(
                                          onPressed: () {
                                            print('Button pressed ...');
                                          },
                                          text: FFLocalizations.of(context)
                                              .getText(
                                            'iid7wdad' /* Order Now */,
                                          ),
                                          options: FFButtonOptions(
                                            width: double.infinity,
                                            height: 35.0,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 0.0, 16.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: Color(0x49FFFFFF),
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily:
                                                          'General Sans',
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                      letterSpacing: 0.0,
                                                    ),
                                            elevation: 0.0,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ].divide(SizedBox(height: 10.0)),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFF9A00),
                                      Color(0xFFE68E07)
                                    ],
                                    stops: [0.0, 1.0],
                                    begin: AlignmentDirectional(-1.0, 0.0),
                                    end: AlignmentDirectional(1.0, 0),
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Container(
                                    width: 130.0,
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            color: Color(0x3CFFFFFF),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Icon(
                                              Icons.auto_awesome_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              size: 30.0,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            '3h8bf835' /* Painting Service */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'General Sans',
                                                color: Color(0xC4FFFFFF),
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            'v4hhwn9s' /* Save 30% */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'General Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                fontSize: 18.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        FFButtonWidget(
                                          onPressed: () {
                                            print('Button pressed ...');
                                          },
                                          text: FFLocalizations.of(context)
                                              .getText(
                                            '72ew3ucl' /* Order Now */,
                                          ),
                                          options: FFButtonOptions(
                                            width: double.infinity,
                                            height: 35.0,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 0.0, 16.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: Color(0x49FFFFFF),
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily:
                                                          'General Sans',
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                      letterSpacing: 0.0,
                                                    ),
                                            elevation: 0.0,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ].divide(SizedBox(height: 10.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ]
                                .divide(SizedBox(width: 10.0))
                                .addToStart(SizedBox(width: 20.0))
                                .addToEnd(SizedBox(width: 20.0)),
                          ),
                        ),
                      ].divide(SizedBox(height: 20.0)),
                    ),
                    // PR-F05: Missions Feed Section
                    _buildMissionsSection(context),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                      child: GridView(
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 0.7,
                        ),
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: [
                          wrapWithModel(
                            model: _model.serviceItemModel7,
                            updateCallback: () => safeSetState(() {}),
                            child: ServiceItemWidget(
                              img:
                                  'https://plus.unsplash.com/premium_photo-1678718606857-d4820cecc9bf?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8VXBob2xzdGVyeSUyMGFuZCUyMEZ1cm5pdHVyZSUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                              title: FFLocalizations.of(context).getText(
                                '5o23lg1z' /* Upholstery and Furniture Clean... */,
                              ),
                            ),
                          ),
                          wrapWithModel(
                            model: _model.serviceItemModel8,
                            updateCallback: () => safeSetState(() {}),
                            child: ServiceItemWidget(
                              img:
                                  'https://plus.unsplash.com/premium_photo-1664910117544-5a3eed7c6413?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mjl8fExhdW5kcnklMjBTZXJ2aWNlc3xlbnwwfHwwfHx8MA%3D%3D',
                              title: FFLocalizations.of(context).getText(
                                '08y70p4h' /* Laundry Services */,
                              ),
                            ),
                          ),
                          wrapWithModel(
                            model: _model.serviceItemModel9,
                            updateCallback: () => safeSetState(() {}),
                            child: ServiceItemWidget(
                              img:
                                  'https://images.unsplash.com/photo-1686479037314-88bc3732de16?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8UGV0JTIwQXJlYSUyMENsZWFuaW5nfGVufDB8fDB8fHww',
                              title: FFLocalizations.of(context).getText(
                                '6dl7lpm6' /* Pet Area Cleaning */,
                              ),
                            ),
                          ),
                          wrapWithModel(
                            model: _model.serviceItemModel10,
                            updateCallback: () => safeSetState(() {}),
                            child: ServiceItemWidget(
                              img:
                                  'https://plus.unsplash.com/premium_photo-1684407616444-d52caf1a828f?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8R3JlZW4lMjBDbGVhbmluZ3xlbnwwfHwwfHx8MA%3D%3D',
                              title: FFLocalizations.of(context).getText(
                                '3remengj' /* Green Cleaning */,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                      .divide(SizedBox(height: 20.0))
                      .addToStart(SizedBox(height: 20.0))
                      .addToEnd(SizedBox(height: 100.0)),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.migNavBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: MigNavBarWidget(
                    activePage: 'home',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PR-F05: Missions Feed Section
  // ─────────────────────────────────────────────────────────────────────────

  /// Builds the missions feed section with loading/error/empty/list states.
  Widget _buildMissionsSection(BuildContext context) {
    final state = _model.missionsState;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  WkCopy.missionsNearby,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'General Sans',
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              // PR-F05b: View mode toggle + refresh
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.hasMissions)
                    _buildViewToggle(context),
                  if (state.hasMissions)
                    SizedBox(width: 8),
                  if (state.hasMissions)
                    InkWell(
                      onTap: () async {
                        await MissionsService.refresh();
                      },
                      child: Icon(
                        Icons.refresh,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15.0),
          // Content based on state and view mode
          _buildMissionsContent(context, state),
        ],
      ),
    );
  }

  /// Builds missions content based on current state.
  Widget _buildMissionsContent(BuildContext context, MissionsState state) {
    // Loading state
    if (state.isLoading) {
      return Container(
        height: 120,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: FlutterFlowTheme.of(context).primary,
              ),
              SizedBox(height: WkSpacing.sm),
              Text(
                WkCopy.loading,
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'General Sans',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    // Error state
    if (state.hasError) {
      return Container(
        padding: EdgeInsets.all(WkSpacing.xl),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(WkRadius.card),
        ),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: FlutterFlowTheme.of(context).error,
              size: WkIconSize.xxl,
            ),
            SizedBox(height: WkSpacing.sm),
            Text(
              WkCopy.errorMissions,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: WkSpacing.lg),
            FFButtonWidget(
              onPressed: () async {
                await MissionsService.loadNearby(
                  latitude: 45.5017,
                  longitude: -73.5673,
                  radiusKm: 25,
                );
              },
              text: WkCopy.retry,
              options: FFButtonOptions(
                padding: EdgeInsetsDirectional.fromSTEB(
                    WkSpacing.xl, WkSpacing.sm, WkSpacing.xl, WkSpacing.sm),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      color: FlutterFlowTheme.of(context).info,
                      letterSpacing: 0.0,
                    ),
                borderRadius: BorderRadius.circular(WkRadius.button),
              ),
            ),
          ],
        ),
      );
    }

    // Empty state
    if (state.isEmpty) {
      return Container(
        padding: EdgeInsets.all(WkSpacing.xl),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(WkRadius.card),
        ),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: WkIconSize.xxl,
            ),
            SizedBox(height: WkSpacing.sm),
            Text(
              WkCopy.emptyMissions,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      );
    }

    // Initial state (before first load)
    if (state.status == MissionsStatus.initial) {
      return SizedBox.shrink();
    }

    // PR-F05b: List or Cards view based on mode
    if (_model.missionsViewMode == 'cards') {
      return _buildHorizontalCards(context, state.missions);
    }

    // List of missions (default)
    return Column(
      children: state.missions.take(5).map((mission) {
        return _buildMissionCard(context, mission);
      }).toList(),
    );
  }

  /// PR-F05b + PR-F08: Builds view toggle buttons (List/Cards).
  Widget _buildViewToggle(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(WkSpacing.xs),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(WkRadius.button),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            context,
            icon: Icons.list,
            isActive: _model.missionsViewMode == 'list',
            onTap: () => safeSetState(() => _model.missionsViewMode = 'list'),
          ),
          SizedBox(width: WkSpacing.xs),
          _buildToggleButton(
            context,
            icon: Icons.view_carousel,
            isActive: _model.missionsViewMode == 'cards',
            onTap: () => safeSetState(() => _model.missionsViewMode = 'cards'),
          ),
        ],
      ),
    );
  }

  /// PR-F08: Single toggle button widget for consistent styling.
  Widget _buildToggleButton(
    BuildContext context, {
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(WkRadius.xs),
      child: AnimatedContainer(
        duration: WkDuration.fast,
        padding: EdgeInsets.symmetric(horizontal: WkSpacing.sm, vertical: WkSpacing.xs),
        decoration: BoxDecoration(
          color: isActive
              ? FlutterFlowTheme.of(context).primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(WkRadius.xs),
        ),
        child: Icon(
          icon,
          size: WkIconSize.sm,
          color: isActive
              ? Colors.white
              : FlutterFlowTheme.of(context).secondaryText,
        ),
      ),
    );
  }

  /// PR-F05b: Builds horizontal scrollable cards.
  Widget _buildHorizontalCards(BuildContext context, List<Mission> missions) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: missions.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final mission = missions[index];
          return _buildHorizontalMissionCard(context, mission, index);
        },
      ),
    );
  }

  /// PR-F05b: Builds a horizontal mission card.
  Widget _buildHorizontalMissionCard(
      BuildContext context, Mission mission, int index) {
    return Padding(
      padding: EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            MissionDetailWidget.routeName,
            queryParameters: {
              'missionId': mission.id,
            }.withoutNulls,
            extra: <String, dynamic>{
              'mission': mission,
            },
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 280,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _getCardGradient(index),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  mission.status.displayName,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'General Sans',
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
              SizedBox(height: 12),

              // Title
              Text(
                mission.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'General Sans',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.0,
                    ),
              ),
              Spacer(),

              // Location and distance
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.white70, size: 14),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      mission.city,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'General Sans',
                            color: Colors.white70,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  if (mission.distanceKm != null) ...[
                    SizedBox(width: 8),
                    Text(
                      mission.formattedDistance ?? '',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'General Sans',
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 8),

              // Price
              Text(
                mission.formattedPrice,
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: 'General Sans',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.0,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// PR-F05b + PR-F08: Returns gradient colors for card at given index.
  List<Color> _getCardGradient(int index) {
    return WkGradients.getCardGradient(index);
  }

  /// Builds a single mission card.
  Widget _buildMissionCard(BuildContext context, Mission mission) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          // PR-F05b: Navigate to mission detail
          context.pushNamed(
            MissionDetailWidget.routeName,
            queryParameters: {
              'missionId': mission.id,
            }.withoutNulls,
            extra: <String, dynamic>{
              'mission': mission,
            },
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Category icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    _getCategoryIcon(mission.category),
                    color: FlutterFlowTheme.of(context).primary,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(width: 12),
              // Mission info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'General Sans',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.0,
                          ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        SizedBox(width: 4),
                        Text(
                          mission.city,
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'General Sans',
                                color: FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                              ),
                        ),
                        if (mission.distanceKm != null) ...[
                          SizedBox(width: 8),
                          Text(
                            mission.formattedDistance ?? '',
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'General Sans',
                                  color: FlutterFlowTheme.of(context).primary,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    mission.formattedPrice,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'General Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor(mission.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      mission.status.displayName,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'General Sans',
                            color: _getStatusColor(mission.status),
                            fontSize: 11,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns icon for mission category.
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'snow_removal':
      case 'deneigement':
        return Icons.ac_unit;
      case 'cleaning':
      case 'menage':
        return Icons.cleaning_services;
      case 'plumbing':
      case 'plomberie':
        return Icons.plumbing;
      case 'painting':
      case 'peinture':
        return Icons.format_paint;
      case 'gardening':
      case 'jardinage':
        return Icons.grass;
      case 'moving':
      case 'demenagement':
        return Icons.local_shipping;
      case 'handyman':
      case 'bricolage':
        return Icons.build;
      default:
        return Icons.work_outline;
    }
  }

  /// PR-F08: Returns color for mission status using centralized tokens.
  Color _getStatusColor(MissionStatus status) {
    switch (status) {
      case MissionStatus.open:
        return WkStatusColors.open;
      case MissionStatus.assigned:
        return WkStatusColors.assigned;
      case MissionStatus.inProgress:
        return WkStatusColors.inProgress;
      case MissionStatus.completed:
        return WkStatusColors.completed;
      case MissionStatus.cancelled:
        return WkStatusColors.cancelled;
      case MissionStatus.unknown:
        return WkStatusColors.unknown;
    }
  }
}
