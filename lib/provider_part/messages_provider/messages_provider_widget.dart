import '/client_part/components_client/conversation_item/conversation_item_widget.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/provider_part/components_provider/drawer_content/drawer_content_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'messages_provider_model.dart';
export 'messages_provider_model.dart';

class MessagesProviderWidget extends StatefulWidget {
  const MessagesProviderWidget({super.key});

  static String routeName = 'Messages-Provider';
  static String routePath = '/messagesProvider';

  @override
  State<MessagesProviderWidget> createState() => _MessagesProviderWidgetState();
}

class _MessagesProviderWidgetState extends State<MessagesProviderWidget> {
  late MessagesProviderModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MessagesProviderModel());
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
              activePage: 'messages',
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
                          'xh915llb' /* Messages */,
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
                  Container(
                    width: 40.0,
                    height: 40.0,
                    child: Stack(
                      children: [
                        FlutterFlowIconButton(
                          borderRadius: 14.0,
                          buttonSize: 40.0,
                          fillColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          icon: Icon(
                            FFIcons.krefresh18,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                          onPressed: () {
                            print('IconButton pressed ...');
                          },
                        ),
                        Align(
                          alignment: AlignmentDirectional(1.0, -1.0),
                          child: Material(
                            color: Colors.transparent,
                            elevation: 4.0,
                            shape: const CircleBorder(),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 700),
                              curve: Curves.bounceOut,
                              width: 18.0,
                              height: 18.0,
                              decoration: BoxDecoration(
                                color: Color(0xFFFF9500),
                                shape: BoxShape.circle,
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  FFLocalizations.of(context).getText(
                                    'w1plugj2' /* 3 */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'General Sans',
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FlutterFlowIconButton(
                    borderRadius: 14.0,
                    buttonSize: 40.0,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FlutterFlowChoiceChips(
                    options: [
                      ChipData(FFLocalizations.of(context).getText(
                        'bdsdcxae' /* All */,
                      )),
                      ChipData(FFLocalizations.of(context).getText(
                        'thgjgydg' /* Unread */,
                      )),
                      ChipData(FFLocalizations.of(context).getText(
                        'jusjjv4e' /* Read */,
                      ))
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
                      iconSize: 16.0,
                      labelPadding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 6.0, 15.0, 6.0),
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
                      iconColor: FlutterFlowTheme.of(context).secondaryText,
                      iconSize: 16.0,
                      labelPadding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 7.0, 15.0, 7.0),
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
                    runSpacing: 10.0,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    runAlignment: WrapAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    clipBehavior: Clip.none,
                    children: [
                      wrapWithModel(
                        model: _model.conversationItemModel1,
                        updateCallback: () => safeSetState(() {}),
                        child: ConversationItemWidget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1688350808212-4e6908a03925?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cG9ydHJhaXR8ZW58MHwwfDB8fHww',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.conversationItemModel2,
                        updateCallback: () => safeSetState(() {}),
                        child: ConversationItemWidget(
                          img:
                              'https://images.unsplash.com/photo-1557862921-37829c790f19?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8cG9ydHJhaXR8ZW58MHwwfDB8fHww',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.conversationItemModel3,
                        updateCallback: () => safeSetState(() {}),
                        child: ConversationItemWidget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1683140621573-233422bfc7f1?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8cG9ydHJhaXR8ZW58MHwwfDB8fHww',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.conversationItemModel4,
                        updateCallback: () => safeSetState(() {}),
                        child: ConversationItemWidget(
                          img:
                              'https://images.unsplash.com/photo-1564564321837-a57b7070ac4f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fHBvcnRyYWl0fGVufDB8MHwwfHx8MA%3D%3D',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.conversationItemModel5,
                        updateCallback: () => safeSetState(() {}),
                        child: ConversationItemWidget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1722859288966-b00ef70df64b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fHBvcnRyYWl0fGVufDB8MHwwfHx8MA%3D%3D',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.conversationItemModel6,
                        updateCallback: () => safeSetState(() {}),
                        child: ConversationItemWidget(
                          img:
                              'https://images.unsplash.com/photo-1638727295415-286409421143?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fHBvcnRyYWl0fGVufDB8MHwwfHx8MA%3D%3D',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.conversationItemModel7,
                        updateCallback: () => safeSetState(() {}),
                        child: ConversationItemWidget(
                          img:
                              'https://images.unsplash.com/photo-1595868228899-abc8fabb3447?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzJ8fHBvcnRyYWl0fGVufDB8MHwwfHx8MA%3D%3D',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.conversationItemModel8,
                        updateCallback: () => safeSetState(() {}),
                        child: ConversationItemWidget(
                          img:
                              'https://images.unsplash.com/photo-1501196354995-cbb51c65aaea?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzV8fHBvcnRyYWl0fGVufDB8MHwwfHx8MA%3D%3D',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.conversationItemModel9,
                        updateCallback: () => safeSetState(() {}),
                        child: ConversationItemWidget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1682096475747-a744ab3f55ab?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mzd8fHBvcnRyYWl0fGVufDB8MHwwfHx8MA%3D%3D',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.conversationItemModel10,
                        updateCallback: () => safeSetState(() {}),
                        child: ConversationItemWidget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1689977807477-a579eda91fa2?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDF8fHBvcnRyYWl0fGVufDB8MHwwfHx8MA%3D%3D',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.conversationItemModel11,
                        updateCallback: () => safeSetState(() {}),
                        child: ConversationItemWidget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1682089897177-4dbc85aa672f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTN8fHBvcnRyYWl0fGVufDB8MHwwfHx8MA%3D%3D',
                        ),
                      ),
                    ],
                  ),
                ]
                    .divide(SizedBox(height: 20.0))
                    .addToStart(SizedBox(height: 10.0))
                    .addToEnd(SizedBox(height: 20.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
