import '/client_part/components_client/conversation_item/conversation_item_widget.dart';
import '/client_part/components_client/mig_nav_bar/mig_nav_bar_widget.dart';
import '/client_part/components_client/search_btn/search_btn_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'messages_model.dart';
export 'messages_model.dart';

class MessagesWidget extends StatefulWidget {
  const MessagesWidget({super.key});

  static String routeName = 'Messages';
  static String routePath = '/messages';

  @override
  State<MessagesWidget> createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {
  late MessagesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MessagesModel());
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
                          'vrp5tjvs' /* Messages */,
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
                  wrapWithModel(
                    model: _model.searchBtnModel,
                    updateCallback: () => safeSetState(() {}),
                    child: SearchBtnWidget(),
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
                ],
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
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
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
                          .addToStart(SizedBox(height: 20.0))
                          .addToEnd(SizedBox(height: 20.0)),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.migNavBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: MigNavBarWidget(
                    activePage: 'messages',
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
