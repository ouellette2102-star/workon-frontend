/// Ticket detail page with conversation.
///
/// Shows ticket messages and allows adding new messages.
///
/// **FL-SUPPORT:** Initial implementation.
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/support/support_models.dart';
import '/services/support/support_service.dart';
import '/services/support/support_api.dart';

/// Widget showing ticket conversation.
class TicketDetailWidget extends StatefulWidget {
  const TicketDetailWidget({
    super.key,
    required this.ticketId,
  });

  final String ticketId;

  @override
  State<TicketDetailWidget> createState() => _TicketDetailWidgetState();
}

class _TicketDetailWidgetState extends State<TicketDetailWidget> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  bool _isLoading = true;
  bool _isSending = false;
  String? _errorMessage;
  SupportTicket? _ticket;

  @override
  void initState() {
    super.initState();
    _loadTicket();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadTicket() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final ticket = await SupportService.getTicket(
        widget.ticketId,
        forceRefresh: true,
      );
      if (mounted) {
        setState(() {
          _ticket = ticket;
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } on SupportApiException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[TicketDetail] Error: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Impossible de charger le ticket';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    setState(() => _isSending = true);

    try {
      final ticket = await SupportService.addMessage(
        ticketId: widget.ticketId,
        content: content,
      );

      if (mounted) {
        _messageController.clear();
        setState(() {
          _ticket = ticket;
          _isSending = false;
        });
        _scrollToBottom();
      }
    } on SupportApiException catch (e) {
      if (mounted) {
        setState(() => _isSending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erreur lors de l\'envoi'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }

  Future<void> _closeTicket() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fermer le ticket?'),
        content: const Text(
          'Une fois fermé, vous ne pourrez plus ajouter de messages.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final ticket = await SupportService.closeTicket(widget.ticketId);
      if (mounted) {
        setState(() => _ticket = ticket);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ticket fermé')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erreur lors de la fermeture'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: theme.primaryText),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            _ticket?.subject ?? 'Ticket',
            style: theme.titleMedium.override(
              fontFamily: 'General Sans',
              letterSpacing: 0,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          centerTitle: true,
          actions: [
            if (_ticket != null && _ticket!.canAddMessage)
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: theme.primaryText),
                onSelected: (value) {
                  if (value == 'close') _closeTicket();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'close',
                    child: Text('Fermer le ticket'),
                  ),
                ],
              ),
          ],
        ),
        body: SafeArea(
          child: _buildBody(theme),
        ),
      ),
    );
  }

  Widget _buildBody(FlutterFlowTheme theme) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: theme.primary),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 64, color: theme.error),
              const SizedBox(height: 16),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FFButtonWidget(
                onPressed: _loadTicket,
                text: 'Réessayer',
                options: FFButtonOptions(
                  width: 200,
                  height: 50,
                  color: theme.primary,
                  textStyle: theme.titleSmall.override(
                    fontFamily: 'General Sans',
                    color: Colors.white,
                    letterSpacing: 0,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_ticket == null) {
      return const Center(child: Text('Ticket introuvable'));
    }

    return Column(
      children: [
        // Status bar
        _buildStatusBar(theme),

        // Messages
        Expanded(
          child: _ticket!.messages.isEmpty
              ? Center(
                  child: Text(
                    'Aucun message',
                    style: theme.bodyMedium.override(
                      fontFamily: 'General Sans',
                      color: theme.secondaryText,
                      letterSpacing: 0,
                    ),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _ticket!.messages.length,
                  itemBuilder: (context, index) => _buildMessage(
                    theme,
                    _ticket!.messages[index],
                  ),
                ),
        ),

        // Input
        if (_ticket!.canAddMessage) _buildInput(theme),
      ],
    );
  }

  Widget _buildStatusBar(FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: theme.secondaryBackground,
      child: Row(
        children: [
          Icon(
            _getCategoryIcon(_ticket!.category),
            size: 16,
            color: theme.secondaryText,
          ),
          const SizedBox(width: 4),
          Text(
            _ticket!.category.displayName,
            style: theme.bodySmall.override(
              fontFamily: 'General Sans',
              color: theme.secondaryText,
              letterSpacing: 0,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(theme, _ticket!.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _ticket!.status.displayName,
              style: theme.bodySmall.override(
                fontFamily: 'General Sans',
                color: _getStatusColor(theme, _ticket!.status),
                letterSpacing: 0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(FlutterFlowTheme theme, TicketMessage message) {
    final isFromMe = !message.isFromSupport;
    final timeFormat = DateFormat('HH:mm');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: isFromMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isFromMe ? theme.primary : theme.secondaryBackground,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isFromMe
                  ? const Radius.circular(16)
                  : const Radius.circular(4),
              bottomRight: isFromMe
                  ? const Radius.circular(4)
                  : const Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (message.isFromSupport && message.senderName != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    message.senderName!,
                    style: theme.bodySmall.override(
                      fontFamily: 'General Sans',
                      color: theme.primary,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              Text(
                message.content,
                style: theme.bodyMedium.override(
                  fontFamily: 'General Sans',
                  color: isFromMe ? Colors.white : theme.primaryText,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                timeFormat.format(message.createdAt),
                style: theme.bodySmall.override(
                  fontFamily: 'General Sans',
                  color: isFromMe
                      ? Colors.white.withOpacity(0.7)
                      : theme.secondaryText,
                  fontSize: 10,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        border: Border(
          top: BorderSide(color: theme.alternate, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Votre message...',
                hintStyle: theme.bodyMedium.override(
                  fontFamily: 'General Sans',
                  color: theme.secondaryText,
                  letterSpacing: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.primaryBackground,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              style: theme.bodyMedium.override(
                fontFamily: 'General Sans',
                letterSpacing: 0,
              ),
              maxLines: 4,
              minLines: 1,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _isSending ? null : _sendMessage,
            icon: _isSending
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.primary,
                    ),
                  )
                : Icon(Icons.send_rounded, color: theme.primary),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(FlutterFlowTheme theme, TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return theme.primary;
      case TicketStatus.inProgress:
        return theme.warning;
      case TicketStatus.waitingResponse:
        return theme.tertiary;
      case TicketStatus.resolved:
        return theme.success;
      case TicketStatus.closed:
        return theme.secondaryText;
    }
  }

  IconData _getCategoryIcon(TicketCategory category) {
    switch (category) {
      case TicketCategory.general:
        return Icons.help_outline_rounded;
      case TicketCategory.payment:
        return Icons.payment_rounded;
      case TicketCategory.mission:
        return Icons.work_outline_rounded;
      case TicketCategory.account:
        return Icons.person_outline_rounded;
      case TicketCategory.technical:
        return Icons.build_outlined;
      case TicketCategory.safety:
        return Icons.shield_outlined;
      case TicketCategory.other:
        return Icons.more_horiz_rounded;
    }
  }
}
