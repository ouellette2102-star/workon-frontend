import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/components/coming_soon_screen.dart';
import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/auth/auth_service.dart';
import '/services/messages/message_models.dart';
import '/services/messages/messages_service.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'chat_model.dart';
export 'chat_model.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    super.key,
    this.conversationId,
    this.participantName,
    this.participantAvatar,
  });

  final String? conversationId;
  final String? participantName;
  final String? participantAvatar;

  static String routeName = 'Chat';
  static String routePath = '/chat';

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late ChatModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  // PR-F19: State for real messages
  bool _isLoading = true;
  String? _error;
  List<Message> _messages = [];
  bool _isSending = false;

  // Current user ID for determining message alignment
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    _currentUserId = AuthService.currentUserId;

    // Load messages if conversation ID provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMessages();
    });
  }

  @override
  void dispose() {
    MessagesService.stopPolling();
    MessagesService.closeConversation();
    _scrollController.dispose();
    _model.dispose();
    super.dispose();
  }

  /// PR-F19: Load messages from API.
  Future<void> _loadMessages() async {
    final conversationId = widget.conversationId ??
        GoRouterState.of(context).uri.queryParameters['conversationId'];

    if (conversationId == null || conversationId.isEmpty) {
      setState(() {
        _isLoading = false;
        _error = 'Conversation non trouvée';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await MessagesService.openConversation(conversationId);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result.isSuccess) {
          _messages = result.data ?? [];
          // Start polling for new messages
          MessagesService.startPolling();
          // Listen for message updates
          MessagesService.messagesListenable.addListener(_onMessagesUpdated);
          // Scroll to bottom
          _scrollToBottom();
        } else {
          _error = result.errorMessage ?? WkCopy.errorMessages;
        }
      });
    }
  }

  /// PR-F19: Handle message updates from polling.
  void _onMessagesUpdated() {
    if (mounted) {
      setState(() {
        _messages = MessagesService.messages;
      });
      _scrollToBottom();
    }
  }

  /// PR-F19: Send a message.
  Future<void> _sendMessage() async {
    final text = _model.textController?.text.trim() ?? '';
    if (text.isEmpty || _isSending) return;

    setState(() {
      _isSending = true;
    });

    // Clear input immediately
    _model.textController?.clear();

    final result = await MessagesService.sendMessage(text);

    if (mounted) {
      setState(() {
        _isSending = false;
        _messages = MessagesService.messages;
      });

      if (!result.isSuccess) {
        _showSnackBar(result.errorMessage ?? WkCopy.errorSendMessage, isError: true);
      }

      _scrollToBottom();
    }
  }

  /// PR-F19: Scroll to bottom of messages.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// PR-F19: Show snackbar.
  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// PR-F19: Get participant name from params.
  String get _participantName {
    return widget.participantName ??
        GoRouterState.of(context).uri.queryParameters['participantName'] ??
        'Conversation';
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
                        _participantName,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'General Sans',
                              fontSize: 20.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ].divide(SizedBox(width: 15.0)),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // PR-15: VoiceCall is template-only, show coming soon
                  FlutterFlowIconButton(
                    borderRadius: 30.0,
                    buttonSize: 40.0,
                    icon: Icon(
                      FFIcons.kcall,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      showComingSoon(context, 'Appels vocaux');
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
              // PR-F19: Messages list
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: FlutterFlowTheme.of(context).primary,
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
                                    onPressed: _loadMessages,
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
                        : _messages.isEmpty
                            ? Center(
                                child: Text(
                                  'Commencez la conversation !',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'General Sans',
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: () async {
                                  await MessagesService.refreshMessages();
                                  setState(() {
                                    _messages = MessagesService.messages;
                                  });
                                },
                                color: FlutterFlowTheme.of(context).primary,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                  itemCount: _messages.length,
                                  itemBuilder: (context, index) {
                                    final message = _messages[index];
                                    final isMe = message.senderId == _currentUserId;
                                    return _buildMessageBubble(message, isMe);
                                  },
                                ),
                              ),
              ),
              // PR-F19: Message input
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _model.textController,
                          focusNode: _model.textFieldFocusNode,
                          autofocus: false,
                          obscureText: false,
                          textInputAction: TextInputAction.send,
                          onFieldSubmitted: (_) => _sendMessage(),
                          decoration: InputDecoration(
                            isDense: true,
                            labelStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: 'General Sans',
                                  letterSpacing: 0.0,
                                ),
                            hintText: WkCopy.typeMessage,
                            hintStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: 'General Sans',
                                  letterSpacing: 0.0,
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
                                20.0, 21.0, 20.0, 21.0),
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
                    ),
                    const SizedBox(width: 10),
                    FlutterFlowIconButton(
                      borderRadius: 50.0,
                      buttonSize: 50.0,
                      fillColor: _isSending
                          ? FlutterFlowTheme.of(context).primary.withOpacity(0.6)
                          : FlutterFlowTheme.of(context).primary,
                      icon: _isSending
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              Icons.send_rounded,
                              color: FlutterFlowTheme.of(context).info,
                              size: 24.0,
                            ),
                      onPressed: _isSending ? null : _sendMessage,
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

  /// PR-F19: Build a message bubble.
  Widget _buildMessageBubble(Message message, bool isMe) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isMe
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMe ? 16 : 5),
              bottomRight: Radius.circular(isMe ? 5 : 16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.text,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'General Sans',
                        color: isMe
                            ? Colors.white
                            : FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        lineHeight: 1.4,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.formattedTime,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'General Sans',
                            color: isMe
                                ? Colors.white70
                                : FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 11,
                            letterSpacing: 0.0,
                          ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      if (message.isSending)
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: Colors.white70,
                          ),
                        )
                      else if (message.sendFailed)
                        Icon(
                          Icons.error_outline,
                          size: 14,
                          color: Colors.red.shade300,
                        )
                      else
                        Icon(
                          message.isRead ? Icons.done_all : Icons.done,
                          size: 14,
                          color: Colors.white70,
                        ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
