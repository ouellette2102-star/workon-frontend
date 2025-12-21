import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/language_item/language_item_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'language_settings_model.dart';
export 'language_settings_model.dart';

class LanguageSettingsWidget extends StatefulWidget {
  const LanguageSettingsWidget({super.key});

  static String routeName = 'LanguageSettings';
  static String routePath = '/languageSettings';

  @override
  State<LanguageSettingsWidget> createState() => _LanguageSettingsWidgetState();
}

class _LanguageSettingsWidgetState extends State<LanguageSettingsWidget> {
  late LanguageSettingsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LanguageSettingsModel());
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
                          'jzyn9xst' /* App Language */,
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
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    FFLocalizations.of(context).getText(
                      'yxv8nu3c' /* Suggested */,
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'General Sans',
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Wrap(
                    spacing: 0.0,
                    runSpacing: 15.0,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    runAlignment: WrapAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    clipBehavior: Clip.none,
                    children: [
                      wrapWithModel(
                        model: _model.languageItemModel1,
                        updateCallback: () => safeSetState(() {}),
                        child: LanguageItemWidget(
                          flagImg: 'https://i.postimg.cc/76vhtQ1x/US_3x.png',
                          name: FFLocalizations.of(context).getText(
                            'fna8yxjr' /* English (US) */,
                          ),
                          languageCode: 'en',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.languageItemModel2,
                        updateCallback: () => safeSetState(() {}),
                        child: LanguageItemWidget(
                          flagImg: 'https://i.postimg.cc/BbD8QBmS/ES_3x.png',
                          name: FFLocalizations.of(context).getText(
                            'i7mn6dv5' /* Spanish */,
                          ),
                          languageCode: 'es',
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 1.0,
                    color: FlutterFlowTheme.of(context).alternate,
                  ),
                  Text(
                    FFLocalizations.of(context).getText(
                      'p3ef5124' /* Languages */,
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'General Sans',
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Wrap(
                    spacing: 0.0,
                    runSpacing: 15.0,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    runAlignment: WrapAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    clipBehavior: Clip.none,
                    children: [
                      wrapWithModel(
                        model: _model.languageItemModel3,
                        updateCallback: () => safeSetState(() {}),
                        child: LanguageItemWidget(
                          flagImg: 'https://i.postimg.cc/43hWGrpj/CN_3x.png',
                          name: FFLocalizations.of(context).getText(
                            'nbrn1mr1' /* Chinese (Simplified) */,
                          ),
                          languageCode: 'zh',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.languageItemModel4,
                        updateCallback: () => safeSetState(() {}),
                        child: LanguageItemWidget(
                          flagImg: 'https://i.postimg.cc/4yt5kttt/IN_3x.png',
                          name: FFLocalizations.of(context).getText(
                            'o5rfxtfe' /* Hindi */,
                          ),
                          languageCode: 'hi',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.languageItemModel5,
                        updateCallback: () => safeSetState(() {}),
                        child: LanguageItemWidget(
                          flagImg: 'https://i.postimg.cc/k5Vx8K4S/AR-3x.png',
                          name: FFLocalizations.of(context).getText(
                            'cw7l5isn' /* Arabic */,
                          ),
                          languageCode: 'ar',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.languageItemModel6,
                        updateCallback: () => safeSetState(() {}),
                        child: LanguageItemWidget(
                          flagImg: 'https://i.postimg.cc/TPsdBWTT/PT_3x.png',
                          name: FFLocalizations.of(context).getText(
                            '6nig8ch3' /* Portuguese */,
                          ),
                          languageCode: 'pt',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.languageItemModel7,
                        updateCallback: () => safeSetState(() {}),
                        child: LanguageItemWidget(
                          flagImg: 'https://i.postimg.cc/Sxtm3zGD/FR_3x.png',
                          name: FFLocalizations.of(context).getText(
                            '6q7k60tj' /* French */,
                          ),
                          languageCode: 'fr',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.languageItemModel8,
                        updateCallback: () => safeSetState(() {}),
                        child: LanguageItemWidget(
                          flagImg: 'https://i.postimg.cc/7Z6yDYsh/RU_3x.png',
                          name: FFLocalizations.of(context).getText(
                            'kanu1lzb' /* Russian */,
                          ),
                          languageCode: 'ru',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.languageItemModel9,
                        updateCallback: () => safeSetState(() {}),
                        child: LanguageItemWidget(
                          flagImg: 'https://i.postimg.cc/J0gyRdNd/DE_3x.png',
                          name: FFLocalizations.of(context).getText(
                            'ey024x42' /* German */,
                          ),
                          languageCode: 'de',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.languageItemModel10,
                        updateCallback: () => safeSetState(() {}),
                        child: LanguageItemWidget(
                          flagImg: 'https://i.postimg.cc/wjbs2MRd/JP_3x.png',
                          name: FFLocalizations.of(context).getText(
                            'y50bdg10' /* Japanese */,
                          ),
                          languageCode: 'ja',
                        ),
                      ),
                    ],
                  ),
                ]
                    .divide(SizedBox(height: 25.0))
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
