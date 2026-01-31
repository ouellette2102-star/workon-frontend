/// Support tickets list page.
///
/// Shows all support tickets for the current user with status indicators.
///
/// **FL-SUPPORT:** Initial implementation.
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/support/support_models.dart';
import '/services/support/support_service.dart';
import '/services/support/support_api.dart';
import 'support_tickets_model.dart';
import 'ticket_detail_widget.dart';
import 'create_ticket_widget.dart';

export 'support_tickets_model.dart';

/// Widget showing list of support tickets.
class SupportTicketsWidget extends StatefulWidget {
  const SupportTicketsWidget({super.key});

  static String routeName = 'SupportTickets';
  static String routePath = '/supportTickets';

  @override
  State<SupportTicketsWidget> createState() => _SupportTicketsWidgetState();
}

class _SupportTicketsWidgetState extends State<SupportTicketsWidget> {
  late SupportTicketsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;
  String? _errorMessage;
  List<SupportTicket> _tickets = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SupportTicketsModel());
    _loadTickets();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadTickets() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final tickets = await SupportService.getTickets(forceRefresh: true);
      if (mounted) {
        setState(() {
          _tickets = tickets;
          _isLoading = false;
        });
      }
    } on SupportApiException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[SupportTickets] Error: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Impossible de charger les tickets';
          _isLoading = false;
        });
      }
    }
  }

  void _openTicket(SupportTicket ticket) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketDetailWidget(ticketId: ticket.id),
      ),
    ).then((_) => _loadTickets());
  }

  void _createTicket() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateTicketWidget(),
      ),
    ).then((_) => _loadTickets());
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: theme.primaryText,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Mes demandes',
            style: theme.titleMedium.override(
              fontFamily: 'General Sans',
              letterSpacing: 0,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh_rounded, color: theme.primaryText),
              onPressed: _isLoading ? null : _loadTickets,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _createTicket,
          backgroundColor: theme.primary,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: Text(
            'Nouveau',
            style: theme.bodyMedium.override(
              fontFamily: 'General Sans',
              color: Colors.white,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
            ),
          ),
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
      return _buildError(theme);
    }

    if (_tickets.isEmpty) {
      return _buildEmpty(theme);
    }

    return RefreshIndicator(
      onRefresh: _loadTickets,
      color: theme.primary,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _tickets.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildTicketCard(theme, _tickets[index]),
      ),
    );
  }

  Widget _buildError(FlutterFlowTheme theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: theme.error),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: theme.bodyLarge.override(
                fontFamily: 'General Sans',
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 24),
            FFButtonWidget(
              onPressed: _loadTickets,
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

  Widget _buildEmpty(FlutterFlowTheme theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.support_agent_rounded,
              size: 80,
              color: theme.secondaryText.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Aucune demande',
              style: theme.headlineSmall.override(
                fontFamily: 'General Sans',
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vous n\'avez pas encore créé de demande de support.',
              textAlign: TextAlign.center,
              style: theme.bodyMedium.override(
                fontFamily: 'General Sans',
                color: theme.secondaryText,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 32),
            FFButtonWidget(
              onPressed: _createTicket,
              text: 'Créer une demande',
              options: FFButtonOptions(
                width: 220,
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

  Widget _buildTicketCard(FlutterFlowTheme theme, SupportTicket ticket) {
    final dateFormat = DateFormat('d MMM', 'fr_FR');

    return InkWell(
      onTap: () => _openTicket(ticket),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    ticket.subject,
                    style: theme.bodyLarge.override(
                      fontFamily: 'General Sans',
                      letterSpacing: 0,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusChip(theme, ticket.status),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  _getCategoryIcon(ticket.category),
                  size: 16,
                  color: theme.secondaryText,
                ),
                const SizedBox(width: 4),
                Text(
                  ticket.category.displayName,
                  style: theme.bodySmall.override(
                    fontFamily: 'General Sans',
                    color: theme.secondaryText,
                    letterSpacing: 0,
                  ),
                ),
                const Spacer(),
                Text(
                  dateFormat.format(ticket.createdAt),
                  style: theme.bodySmall.override(
                    fontFamily: 'General Sans',
                    color: theme.secondaryText,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
            if (ticket.lastMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                ticket.lastMessage!.content,
                style: theme.bodySmall.override(
                  fontFamily: 'General Sans',
                  color: theme.secondaryText,
                  letterSpacing: 0,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(FlutterFlowTheme theme, TicketStatus status) {
    Color color;
    switch (status) {
      case TicketStatus.open:
        color = theme.primary;
      case TicketStatus.inProgress:
        color = theme.warning;
      case TicketStatus.waitingResponse:
        color = theme.tertiary;
      case TicketStatus.resolved:
        color = theme.success;
      case TicketStatus.closed:
        color = theme.secondaryText;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayName,
        style: theme.bodySmall.override(
          fontFamily: 'General Sans',
          color: color,
          letterSpacing: 0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
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
