import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/radio_list_item/radio_list_item_widget.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'interview_user_model.dart';
export 'interview_user_model.dart';

class InterviewUserWidget extends StatefulWidget {
  const InterviewUserWidget({super.key});

  static String routeName = 'InterviewUser';
  static String routePath = '/interviewUser';

  @override
  State<InterviewUserWidget> createState() => _InterviewUserWidgetState();
}

class _InterviewUserWidgetState extends State<InterviewUserWidget> {
  late InterviewUserModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InterviewUserModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
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
              wrapWithModel(
                model: _model.backIconBtnModel,
                updateCallback: () => safeSetState(() {}),
                child: BackIconBtnWidget(),
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
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: PageView(
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
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  '3xb9iueb' /* Choose Your City / District */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'General Sans',
                                      fontSize: 20.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                FFLocalizations.of(context).getText(
                                  'c0y7zmkq' /* Let us know where you want to ... */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'General Sans',
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: _model.textController,
                                  focusNode: _model.textFieldFocusNode,
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
                                      'y9rzqekn' /* Search City */,
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
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
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
                                    prefixIcon: Icon(
                                      FFIcons.ksearchNormal01,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 18.0,
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'General Sans',
                                        letterSpacing: 0.0,
                                      ),
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primaryText,
                                  validator: _model.textControllerValidator
                                      .asValidator(context),
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
                                      text: 'Kigali',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel2,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: 'Musanze',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel3,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: 'Rubavu',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel4,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: 'Muhanga',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel5,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: 'Rusizi',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel6,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: 'Nyamata',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel7,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: 'Santa Marta',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel8,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: 'Bucaramanga',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel9,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: 'Pereira',
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
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 20.0, 0.0, 20.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            await _model.pageViewController?.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          text: FFLocalizations.of(context).getText(
                            '09h2gs92' /* Continue */,
                          ),
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 50.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
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
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  'fqhae8vn' /* What services are you most int... */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'General Sans',
                                      fontSize: 20.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                FFLocalizations.of(context).getText(
                                  '5eabwgin' /* Choose the services you might ... */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'General Sans',
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    FFLocalizations.of(context).getText(
                                      '01mlehbh' /* Cleaning Services */,
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
                                  FlutterFlowChoiceChips(
                                    options: [
                                      ChipData(
                                          FFLocalizations.of(context).getText(
                                        'uppjguka' /* Green Cleaning */,
                                      )),
                                      ChipData(
                                          FFLocalizations.of(context).getText(
                                        't9jhhiso' /* Pet Area Cleaning */,
                                      )),
                                      ChipData(
                                          FFLocalizations.of(context).getText(
                                        'e85fnf0c' /* Laundry Services */,
                                      )),
                                      ChipData(
                                          FFLocalizations.of(context).getText(
                                        'xuw4eyma' /* Upholstery and Furniture Clean... */,
                                      )),
                                      ChipData(
                                          FFLocalizations.of(context).getText(
                                        '2e8g50e1' /* Move-in / Move-out Cleaning */,
                                      )),
                                      ChipData(
                                          FFLocalizations.of(context).getText(
                                        'h4k0s4zd' /* Deep Cleaning */,
                                      )),
                                      ChipData(
                                          FFLocalizations.of(context).getText(
                                        'a5ahjdgy' /* Bathroom Cleaning */,
                                      )),
                                      ChipData(
                                          FFLocalizations.of(context).getText(
                                        '04tk2zfu' /* Kitchen Cleaning */,
                                      )),
                                      ChipData(
                                          FFLocalizations.of(context).getText(
                                        'k78zy72z' /* Bedroom Cleaning */,
                                      )),
                                      ChipData(
                                          FFLocalizations.of(context).getText(
                                        '1d1yhy4o' /* General House Cleaning */,
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
                                            color: FlutterFlowTheme.of(context)
                                                .info,
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
                                    initialized:
                                        _model.choiceChipsValues != null,
                                    alignment: WrapAlignment.start,
                                    controller:
                                        _model.choiceChipsValueController ??=
                                            FormFieldController<List<String>>(
                                      [],
                                    ),
                                    wrapped: true,
                                  ),
                                ].divide(SizedBox(height: 15.0)),
                              ),
                            ]
                                .divide(SizedBox(height: 20.0))
                                .addToStart(SizedBox(height: 20.0))
                                .addToEnd(SizedBox(height: 20.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 20.0, 0.0, 20.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            await _model.pageViewController?.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          text: FFLocalizations.of(context).getText(
                            'nz6dqnvs' /* Continue */,
                          ),
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 50.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
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
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  'gzrh1oux' /* How soon do you plan to book a... */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'General Sans',
                                      fontSize: 20.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
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
                                    model: _model.radioListItemModel10,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: FFLocalizations.of(context).getText(
                                        'ixl10lph' /* Today */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel11,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: FFLocalizations.of(context).getText(
                                        '0s5mkdoo' /* This week */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel12,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: FFLocalizations.of(context).getText(
                                        'zdt24oda' /* This month */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel13,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: FFLocalizations.of(context).getText(
                                        '76y6b4el' /* Just exploring */,
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
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 20.0, 0.0, 20.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            await _model.pageViewController?.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          text: FFLocalizations.of(context).getText(
                            'k9y3xpe7' /* Continue */,
                          ),
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 50.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
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
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  'l4mhceer' /* How did you hear about us? */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'General Sans',
                                      fontSize: 20.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
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
                                    model: _model.radioListItemModel14,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: FFLocalizations.of(context).getText(
                                        'hrtqzosh' /* Friend or family */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel15,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: FFLocalizations.of(context).getText(
                                        '5d5cwb0i' /* Social media (Instagram, TikTo... */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel16,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: FFLocalizations.of(context).getText(
                                        '1y7uwfie' /* Google search */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel17,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: FFLocalizations.of(context).getText(
                                        'jrh30k7q' /* WhatsApp group or status */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel18,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: 'AI Recommendation',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel19,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: FFLocalizations.of(context).getText(
                                        'mweml3v5' /* Flyer or poster */,
                                      ),
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.radioListItemModel20,
                                    updateCallback: () => safeSetState(() {}),
                                    child: RadioListItemWidget(
                                      text: FFLocalizations.of(context).getText(
                                        '1ew1bc3f' /* Other */,
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
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 20.0, 0.0, 20.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            await _model.pageViewController?.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          text: FFLocalizations.of(context).getText(
                            '6zs5nqvy' /* Continue */,
                          ),
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 50.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
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
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).accent1,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Icon(
                                  FFIcons.kdiscountShape53,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 124.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                        child: Text(
                          FFLocalizations.of(context).getText(
                            '4kl9vnqq' /* Thanks for sharing! Your first... */,
                          ),
                          textAlign: TextAlign.center,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 5.0, 5.0, 5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  'cyqmrevu' /* WELCM2025 */,
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
                                borderRadius: 30.0,
                                buttonSize: 35.0,
                                fillColor:
                                    FlutterFlowTheme.of(context).alternate,
                                icon: Icon(
                                  FFIcons.kclipboardText10,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 18.0,
                                ),
                                onPressed: () {
                                  print('IconButton pressed ...');
                                },
                              ),
                            ].divide(SizedBox(width: 10.0)),
                          ),
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed(SelectServicesWidget.routeName);
                        },
                        text: FFLocalizations.of(context).getText(
                          '3ft8xm7z' /* Use My Discount */,
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
                    ].divide(SizedBox(height: 30.0)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
