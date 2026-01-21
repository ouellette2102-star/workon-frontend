import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/payments/payment_models.dart';
import '/services/payments/payments_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// PR-06: Transaction history screen.
///
/// Displays user's payment transactions.
class TransactionsWidget extends StatefulWidget {
  const TransactionsWidget({super.key});

  static String routeName = 'Transactions';
  static String routePath = '/transactions';

  @override
  State<TransactionsWidget> createState() => _TransactionsWidgetState();
}

class _TransactionsWidgetState extends State<TransactionsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _api = PaymentsApi();

  List<Transaction> _transactions = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final transactions = await _api.fetchTransactionHistory();

      if (!mounted) return;

      // Sort by most recent first
      transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      setState(() {
        _transactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('[Transactions] Error loading transactions: $e');
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e is PaymentsApiException 
            ? e.message 
            : WkCopy.errorGeneric;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildContent(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: WkSpacing.pagePadding,
        vertical: WkSpacing.lg,
      ),
      child: Row(
        children: [
          wrapWithModel(
            model: createModel(context, () => BackIconBtnModel()),
            updateCallback: () => setState(() {}),
            child: BackIconBtnWidget(),
          ),
          SizedBox(width: WkSpacing.md),
          Text(
            'Transactions',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: 'General Sans',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0,
                ),
          ),
          const Spacer(),
          // Refresh button
          IconButton(
            onPressed: _loadTransactions,
            icon: Icon(
              Icons.refresh,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState(context);
    }

    if (_errorMessage != null) {
      return _buildErrorState(context);
    }

    if (_transactions.isEmpty) {
      return _buildEmptyState(context);
    }

    return _buildTransactionsList(context);
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: FlutterFlowTheme.of(context).primary,
          ),
          SizedBox(height: WkSpacing.lg),
          Text(
            WkCopy.loading,
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

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(WkSpacing.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: WkStatusColors.cancelled,
            ),
            SizedBox(height: WkSpacing.lg),
            Text(
              _errorMessage ?? WkCopy.errorGeneric,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: WkSpacing.xl),
            ElevatedButton.icon(
              onPressed: _loadTransactions,
              icon: const Icon(Icons.refresh),
              label: Text(WkCopy.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(WkSpacing.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            SizedBox(height: WkSpacing.lg),
            Text(
              'Aucune transaction',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: WkSpacing.sm),
            Text(
              'Vos transactions de paiement apparaîtront ici une fois effectuées.',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
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

  Widget _buildTransactionsList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadTransactions,
      color: FlutterFlowTheme.of(context).primary,
      child: ListView.separated(
        padding: EdgeInsets.all(WkSpacing.pagePadding),
        itemCount: _transactions.length,
        separatorBuilder: (_, __) => SizedBox(height: WkSpacing.md),
        itemBuilder: (context, index) {
          final transaction = _transactions[index];
          return _buildTransactionCard(context, transaction);
        },
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, Transaction transaction) {
    return Container(
      padding: EdgeInsets.all(WkSpacing.lg),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(WkRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Status icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getStatusColor(transaction.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(WkRadius.sm),
            ),
            child: Icon(
              _getStatusIcon(transaction.status),
              color: _getStatusColor(transaction.status),
              size: 24,
            ),
          ),
          SizedBox(width: WkSpacing.md),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount
                Text(
                  transaction.formattedAmount,
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'General Sans',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                      ),
                ),
                SizedBox(height: WkSpacing.xs),

                // Mission title or description
                if (transaction.missionTitle != null) ...[
                  Text(
                    transaction.missionTitle!,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: WkSpacing.xs),
                ],

                // Date
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    SizedBox(width: WkSpacing.xs),
                    Text(
                      DateFormat('dd MMM yyyy à HH:mm', 'fr_FR')
                          .format(transaction.createdAt),
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'General Sans',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 11,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Status chip
          _buildStatusChip(context, transaction.status),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, PaymentStatus status) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: WkSpacing.sm,
        vertical: WkSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(WkRadius.xs),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _getStatusColor(status),
        ),
      ),
    );
  }

  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.succeeded:
        return WkStatusColors.completed;
      case PaymentStatus.processing:
        return WkStatusColors.inProgress;
      case PaymentStatus.pending:
        return WkStatusColors.open;
      case PaymentStatus.failed:
      case PaymentStatus.cancelled:
        return WkStatusColors.cancelled;
    }
  }

  IconData _getStatusIcon(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.succeeded:
        return Icons.check_circle_outline;
      case PaymentStatus.processing:
        return Icons.hourglass_empty;
      case PaymentStatus.pending:
        return Icons.schedule;
      case PaymentStatus.failed:
        return Icons.error_outline;
      case PaymentStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }
}

