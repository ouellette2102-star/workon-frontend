import '/client_part/components_client/ratings_summary/ratings_summary_widget.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/provider_part/components_provider/drawer_content/drawer_content_widget.dart';
import '/provider_part/components_provider/message_btn/message_btn_widget.dart';
import '/provider_part/components_provider/review_item_provider/review_item_provider_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'ratings_model.dart';
export 'ratings_model.dart';

class RatingsWidget extends StatefulWidget {
  const RatingsWidget({super.key});

  static String routeName = 'Ratings';
  static String routePath = '/ratings';

  @override
  State<RatingsWidget> createState() => _RatingsWidgetState();
}

class _RatingsWidgetState extends State<RatingsWidget> {
  late RatingsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RatingsModel());
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
              activePage: 'ratings',
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
                          'yb9c94wx' /* Ratings & Reviews */,
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
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  wrapWithModel(
                    model: _model.ratingsSummaryModel,
                    updateCallback: () => safeSetState(() {}),
                    child: RatingsSummaryWidget(),
                  ),
                  Divider(
                    height: 1.0,
                    color: FlutterFlowTheme.of(context).alternate,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'aa9qlnfc' /* Your Reviews (986) */,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
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
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 20.0,
                        ),
                        onPressed: () {
                          print('IconButton pressed ...');
                        },
                      ),
                    ].divide(SizedBox(width: 20.0)),
                  ),
                  FlutterFlowChoiceChips(
                    options: [
                      ChipData(
                          FFLocalizations.of(context).getText(
                            '961ps0u4' /* All */,
                          ),
                          Icons.star_rounded),
                      ChipData(
                          FFLocalizations.of(context).getText(
                            '8mppcjp2' /* 5 */,
                          ),
                          Icons.star_rounded),
                      ChipData(
                          FFLocalizations.of(context).getText(
                            '8sad0lig' /* 4 */,
                          ),
                          Icons.star_rounded),
                      ChipData(
                          FFLocalizations.of(context).getText(
                            'dt6rj2v8' /* 3 */,
                          ),
                          Icons.star_rounded),
                      ChipData(
                          FFLocalizations.of(context).getText(
                            '6nt4or7n' /* 2 */,
                          ),
                          Icons.star_rounded),
                      ChipData(
                          FFLocalizations.of(context).getText(
                            'rnhrodeg' /* 1 */,
                          ),
                          Icons.star_rounded)
                    ],
                    onChanged: (val) =>
                        safeSetState(() => _model.choiceChipsValues = val),
                    selectedChipStyle: ChipStyle(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'General Sans',
                                color: FlutterFlowTheme.of(context).info,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                      iconColor: FlutterFlowTheme.of(context).info,
                      iconSize: 18.0,
                      labelPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 15.0, 6.0),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    unselectedChipStyle: ChipStyle(
                      backgroundColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      textStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'General Sans',
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                      iconColor: FlutterFlowTheme.of(context).tertiary,
                      iconSize: 18.0,
                      labelPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 7.0, 15.0, 7.0),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    chipSpacing: 10.0,
                    rowSpacing: 10.0,
                    multiselect: true,
                    initialized: _model.choiceChipsValues != null,
                    alignment: WrapAlignment.start,
                    controller: _model.choiceChipsValueController ??=
                        FormFieldController<List<String>>(
                      [],
                    ),
                    wrapped: false,
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
                        model: _model.reviewItemProviderModel1,
                        updateCallback: () => safeSetState(() {}),
                        child: ReviewItemProviderWidget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aGVhZHNob3R8ZW58MHx8MHx8fDA%3D',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.reviewItemProviderModel2,
                        updateCallback: () => safeSetState(() {}),
                        child: ReviewItemProviderWidget(
                          img:
                              'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8aGVhZHNob3R8ZW58MHx8MHx8fDA%3D',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.reviewItemProviderModel3,
                        updateCallback: () => safeSetState(() {}),
                        child: ReviewItemProviderWidget(
                          img:
                              'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGhlYWRzaG90fGVufDB8fDB8fHww',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.reviewItemProviderModel4,
                        updateCallback: () => safeSetState(() {}),
                        child: ReviewItemProviderWidget(
                          img:
                              'https://images.unsplash.com/photo-1625504615927-c14f4f309b63?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGhlYWRzaG90fGVufDB8fDB8fHww',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.reviewItemProviderModel5,
                        updateCallback: () => safeSetState(() {}),
                        child: ReviewItemProviderWidget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1690587673708-d6ba8a1579a5?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fGhlYWRzaG90fGVufDB8fDB8fHww',
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
      ),
    );
  }
}
