import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/provider_part/components_provider/drawer_content/drawer_content_widget.dart';
import '/provider_part/components_provider/message_btn/message_btn_widget.dart';
import '/services/earnings/earnings_api.dart';
import '/services/earnings/earnings_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// PR-EARNINGS: Real Earnings widget for providers.
///
/// Shows earnings summary and history from backend API.
/// NO client-side calculation - backend is source of truth.
class EarningsRealWidget extends StatefulWidget {
  const EarningsRealWidget({super.key});

  static String routeName = 'EarningsReal';
  static String routePath = '/earningsReal';

  @override
  State<EarningsRealWidget> createState() => _EarningsRealWidgetState();
}

class _EarningsRealWidgetState extends State<EarningsRealWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _api = EarningsApi();

  EarningsSummary _summary = EarningsSummary.empty();
  List<EarningTransaction> _transactions = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _nextCursor;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load summary and first page of history in parallel
      final results = await Future.wait([
        _api.fetchSummary(),
        _api.fetchHistory(limit: 20),
      ]);

      if (!mounted) return;

      final summary = results[0] as EarningsSummary;
      final historyResponse = results[1] as EarningsHistoryResponse;

      setState(() {
        _summary = summary;
        _transactions = historyResponse.transactions;
        _nextCursor = historyResponse.nextCursor;
        _hasMore = historyResponse.nextCursor != null;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('[EarningsReal] Error loading data: $e');
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e is EarningsApiException
            ? e.message
            : WkCopy.errorGeneric;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore || _nextCursor == null) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final historyResponse = await _api.fetchHistory(
        cursor: _nextCursor,
        limit: 20,
      );

      if (!mounted) return;

      setState(() {
        _transactions.addAll(historyResponse.transactions);
        _nextCursor = historyResponse.nextCursor;
        _hasMore = historyResponse.nextCursor != null;
        _isLoadingMore = false;
      });
    } catch (e) {
      debugPrint('[EarningsReal] Error loading more: $e');
      if (!mounted) return;

      setState(() {
        _isLoadingMore = false;
      });

      // Show snackbar for pagination error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement'),
            action: SnackBarAction(
              label: 'Réessayer',
              onPressed: _loadMore,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      drawer: Drawer(
        elevation: 16.0,
        child: DrawerContentWidget(activePage: 'earnings'),
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
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    icon: Icon(
                      Icons.menu,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 24.0,
                    ),
                    onPressed: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Text(
                      'Revenus',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'General Sans',
                            fontSize: 20.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _loadData,
                ),
                MessageBtnWidget(),
              ],
            ),
          ],
        ),
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: _isLoading
            ? _buildLoadingState(context)
            : _errorMessage != null
                ? _buildErrorState(context)
                : _buildContent(context),
      ),
    );
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
              onPressed: _loadData,
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

  Widget _buildContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: FlutterFlowTheme.of(context).primary,
      child: CustomScrollView(
        slivers: [
          // Summary cards
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(WkSpacing.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main balance card
                  _buildMainBalanceCard(context),
                  SizedBox(height: WkSpacing.lg),

                  // Stats row
                  _buildStatsRow(context),
                  SizedBox(height: WkSpacing.lg),

                  // Commission info
                  _buildCommissionInfo(context),
                  SizedBox(height: WkSpacing.xl),

                  // History header
                  Text(
                    'Historique des revenus',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: 'General Sans',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(height: WkSpacing.sm),
                  Text(
                    '${_summary.completedMissionsCount + _summary.paidMissionsCount} missions',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ),
            ),
          ),

          // Transactions list or empty state
          if (_transactions.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: WkSpacing.pagePadding),
                child: _buildEmptyState(context),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == _transactions.length) {
                    // Loading more indicator or load more button
                    if (_hasMore) {
                      if (_isLoadingMore) {
                        return Padding(
                          padding: EdgeInsets.all(WkSpacing.lg),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        );
                      } else {
                        // Auto-load when reaching end
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _loadMore();
                        });
                        return SizedBox(height: WkSpacing.lg);
                      }
                    }
                    return SizedBox(height: WkSpacing.xl);
                  }

                  final transaction = _transactions[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: WkSpacing.pagePadding,
                      vertical: WkSpacing.sm,
                    ),
                    child: _buildTransactionCard(context, transaction),
                  );
                },
                childCount: _transactions.length + 1, // +1 for loading/spacer
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainBalanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(WkSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).primary,
            FlutterFlowTheme.of(context).primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(WkRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total des revenus (net)',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'General Sans',
                  color: Colors.white.withOpacity(0.8),
                  letterSpacing: 0.0,
                ),
          ),
          SizedBox(height: WkSpacing.sm),
          Text(
            '\$${_summary.totalLifetimeNet.toStringAsFixed(2)}',
            style: FlutterFlowTheme.of(context).displaySmall.override(
                  fontFamily: 'General Sans',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0,
                ),
          ),
          SizedBox(height: WkSpacing.md),
          Divider(color: Colors.white.withOpacity(0.3), height: 1),
          SizedBox(height: WkSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBalanceItem(
                context,
                label: 'Disponible',
                amount: _summary.totalAvailable,
                color: Colors.white,
              ),
              _buildBalanceItem(
                context,
                label: 'En attente',
                amount: _summary.totalPending,
                color: Colors.white.withOpacity(0.8),
              ),
              _buildBalanceItem(
                context,
                label: 'Déjà payé',
                amount: _summary.totalPaid,
                color: Colors.white.withOpacity(0.7),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(
    BuildContext context, {
    required String label,
    required double amount,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodySmall.override(
                fontFamily: 'General Sans',
                color: color.withOpacity(0.8),
                letterSpacing: 0.0,
              ),
        ),
        SizedBox(height: WkSpacing.xs),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: FlutterFlowTheme.of(context).titleSmall.override(
                fontFamily: 'General Sans',
                color: color,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.0,
              ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.check_circle_outline,
            label: 'Terminées',
            value: '${_summary.completedMissionsCount}',
            color: WkStatusColors.completed,
          ),
        ),
        SizedBox(width: WkSpacing.md),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.paid_outlined,
            label: 'Payées',
            value: '${_summary.paidMissionsCount}',
            color: FlutterFlowTheme.of(context).primary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(WkSpacing.lg),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(WkRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: WkSpacing.sm),
          Text(
            value,
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: 'General Sans',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0,
                ),
          ),
          Text(
            label,
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'General Sans',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommissionInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(WkSpacing.md),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(WkRadius.sm),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 20,
          ),
          SizedBox(width: WkSpacing.sm),
          Expanded(
            child: Text(
              'Commission plateforme : ${_summary.commissionPercent}%',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(WkSpacing.xl),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(WkRadius.md),
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 48,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          SizedBox(height: WkSpacing.md),
          Text(
            'Aucun revenu',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'General Sans',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.0,
                ),
          ),
          SizedBox(height: WkSpacing.sm),
          Text(
            'Complétez des missions pour voir vos revenus ici.',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'General Sans',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, EarningTransaction transaction) {
    final statusColor = _getStatusColor(transaction.status);
    final dateFormatted = DateFormat('dd MMM yyyy', 'fr_FR').format(transaction.date);

    return Container(
      padding: EdgeInsets.all(WkSpacing.lg),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(WkRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: title + status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  transaction.missionTitle,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'General Sans',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.0,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: WkSpacing.sm),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: WkSpacing.sm,
                  vertical: WkSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(WkRadius.xs),
                ),
                child: Text(
                  transaction.status.displayName,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: WkSpacing.xs),

          // Client + Date
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 14,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
              SizedBox(width: WkSpacing.xs),
              Expanded(
                child: Text(
                  transaction.clientName,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'General Sans',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                dateFormatted,
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'General Sans',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
            ],
          ),
          SizedBox(height: WkSpacing.md),

          // Amounts row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Gross - Commission = Net
              Row(
                children: [
                  Text(
                    '\$${transaction.grossAmount.toStringAsFixed(0)}',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          decoration: TextDecoration.lineThrough,
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(width: WkSpacing.xs),
                  Text(
                    '- \$${transaction.commissionAmount.toStringAsFixed(0)}',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'General Sans',
                          color: WkStatusColors.cancelled,
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ),
              // Net amount
              Text(
                '\$${transaction.netAmount.toStringAsFixed(2)}',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'General Sans',
                      color: WkStatusColors.completed,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.0,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(EarningStatus status) {
    switch (status) {
      case EarningStatus.paid:
        return WkStatusColors.completed;
      case EarningStatus.available:
        return WkStatusColors.inProgress;
      case EarningStatus.pending:
        return WkStatusColors.assigned;
    }
  }
}
