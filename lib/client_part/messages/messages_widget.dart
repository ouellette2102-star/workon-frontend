import '/client_part/components_client/mig_nav_bar/mig_nav_bar_widget.dart';
import '/client_part/components_client/search_btn/search_btn_widget.dart';
import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import '/services/messages/message_models.dart';
import '/services/messages/messages_service.dart';
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

  // PR-F19: State for real conversations
  bool _isLoading = true;
  String? _error;
  List<Conversation> _conversations = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MessagesModel());
    _loadConversations();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  /// PR-F19: Load conversations from API.
  /// PR-4: getConversations returns empty list (no backend endpoint).
  /// Chat is accessible only from mission detail.
  Future<void> _loadConversations() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await MessagesService.fetchConversations();

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result.isSuccess) {
          _conversations = result.data ?? [];
          // PR-4: No error state - empty list is expected behavior
        } else {
          _error = result.errorMessage ?? WkCopy.errorConversations;
        }
      });
    }
  }

  /// PR-F19: Open chat with conversation.
  void _openChat(Conversation conversation) {
    context.pushNamed(
      ChatWidget.routeName,
      queryParameters: {
        'conversationId': conversation.id,
        'participantName': conversation.participantName,
        'participantAvatar': conversation.participantAvatar ?? '',
      },
    );
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
                child: _isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              WkCopy.loadingConversations,
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ],
                        ),
                      )
                    : _error != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: FlutterFlowTheme.of(context).error,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _error!,
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                  const SizedBox(height: 16),
                                  FFButtonWidget(
                                    onPressed: _loadConversations,
                                    text: WkCopy.retry,
                                    options: FFButtonOptions(
                                      height: 40,
                                      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                                      color: FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                            fontFamily: 'General Sans',
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                          ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : _conversations.isEmpty
                            // PR-4: Empty state is the expected behavior
                            // Chat is accessible from mission detail only
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chat_bubble_outline,
                                        size: 64,
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        WkCopy.emptyConversations,
                                        style: FlutterFlowTheme.of(context).headlineSmall,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        WkCopy.emptyConversationsHint,
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'General Sans',
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                      const SizedBox(height: 24),
                                      FFButtonWidget(
                                        onPressed: () {
                                          context.pushNamed(HomeWidget.routeName);
                                        },
                                        text: WkCopy.goToMissions,
                                        options: FFButtonOptions(
                                          height: 44,
                                          padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                                          color: FlutterFlowTheme.of(context).primary,
                                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                fontFamily: 'General Sans',
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                              ),
                                          borderRadius: BorderRadius.circular(22),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: _loadConversations,
                                color: FlutterFlowTheme.of(context).primary,
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                  itemCount: _conversations.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                                  itemBuilder: (context, index) {
                                    final conversation = _conversations[index];
                                    return _buildConversationItem(conversation);
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

  /// PR-F19: Build a single conversation item.
  Widget _buildConversationItem(Conversation conversation) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => _openChat(conversation),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Avatar
                    Container(
                      width: 55.0,
                      height: 55.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        shape: BoxShape.circle,
                      ),
                      child: conversation.participantAvatar != null &&
                              conversation.participantAvatar!.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                conversation.participantAvatar!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Center(
                                  child: Text(
                                    conversation.initials,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'General Sans',
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                conversation.initials,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'General Sans',
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                    ),
                    const SizedBox(width: 10),
                    // Name and last message
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            conversation.participantName,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'General Sans',
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          if (conversation.lastMessage != null)
                            Text(
                              conversation.lastMessage!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'General Sans',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Time and unread badge
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (conversation.unreadCount > 0)
                    Container(
                      width: 25.0,
                      height: 25.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          conversation.unreadCount > 99
                              ? '99+'
                              : conversation.unreadCount.toString(),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    conversation.formattedTime,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12.0,
                          letterSpacing: 0.0,
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
}
