/// Payment receipt screen for WorkOn.
///
/// Displays payment confirmation after successful Stripe payment.
///
/// **PR-7:** Payment receipt screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/missions/mission_models.dart';

/// Payment receipt screen showing payment confirmation.
///
/// Displays:
/// - Success status
/// - Mission title
/// - Amount paid
/// - Date/time
/// - Transaction reference
class PaymentReceiptScreen extends StatelessWidget {
  const PaymentReceiptScreen({
    super.key,
    required this.mission,
    required this.amount,
    required this.currency,
    this.transactionId,
  });

  /// The paid mission.
  final Mission mission;

  /// Amount paid in cents.
  final int amount;

  /// Currency code (e.g., 'CAD').
  final String currency;

  /// Optional Stripe transaction ID.
  final String? transactionId;

  /// Route name for navigation.
  static const String routeName = 'PaymentReceipt';

  /// Route path for navigation.
  static const String routePath = '/payment-receipt';

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final now = DateTime.now();
    final dateFormat = DateFormat('d MMM yyyy', 'fr_FR');
    final timeFormat = DateFormat('HH:mm', 'fr_FR');

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: theme.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Reçu de paiement',
          style: theme.headlineSmall.override(
            fontFamily: 'General Sans',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.0,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Success icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 50,
                  color: theme.success,
                ),
              ),
              const SizedBox(height: 16),

              // Success title
              Text(
                'Paiement réussi!',
                style: theme.headlineMedium.override(
                  fontFamily: 'General Sans',
                  color: theme.success,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0,
                ),
              ),
              const SizedBox(height: 8),

              // Amount
              Text(
                _formatAmount(amount, currency),
                style: theme.displaySmall.override(
                  fontFamily: 'General Sans',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0,
                ),
              ),
              const SizedBox(height: 24),

              // Receipt card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mission title
                    _buildRow(
                      context,
                      label: 'Service',
                      value: mission.title,
                    ),
                    const Divider(height: 24),

                    // Date
                    _buildRow(
                      context,
                      label: 'Date',
                      value: dateFormat.format(now),
                    ),
                    const SizedBox(height: 12),

                    // Time
                    _buildRow(
                      context,
                      label: 'Heure',
                      value: timeFormat.format(now),
                    ),
                    const Divider(height: 24),

                    // Status
                    _buildRow(
                      context,
                      label: 'Statut',
                      value: 'Payé',
                      valueColor: theme.success,
                    ),
                    const SizedBox(height: 12),

                    // Transaction ID
                    if (transactionId != null) ...[
                      _buildRow(
                        context,
                        label: 'Référence',
                        value: _truncateId(transactionId!),
                        onTap: () => _copyToClipboard(context, transactionId!),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Info text
              Text(
                'Un reçu a été envoyé à votre adresse email.',
                textAlign: TextAlign.center,
                style: theme.bodyMedium.override(
                  fontFamily: 'General Sans',
                  color: theme.secondaryText,
                  letterSpacing: 0.0,
                ),
              ),
              const SizedBox(height: 32),

              // Done button
              SizedBox(
                width: double.infinity,
                child: FFButtonWidget(
                  onPressed: () => Navigator.of(context).pop(),
                  text: 'Terminé',
                  options: FFButtonOptions(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    color: theme.primary,
                    textStyle: theme.titleSmall.override(
                      fontFamily: 'General Sans',
                      color: Colors.white,
                      letterSpacing: 0.0,
                    ),
                    elevation: 0,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
    VoidCallback? onTap,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.bodyMedium.override(
            fontFamily: 'General Sans',
            color: theme.secondaryText,
            letterSpacing: 0.0,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: theme.bodyMedium.override(
                  fontFamily: 'General Sans',
                  color: valueColor ?? theme.primaryText,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.0,
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.copy,
                  size: 16,
                  color: theme.secondaryText,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _formatAmount(int amountCents, String currency) {
    final dollars = amountCents / 100;
    final symbol = currency.toUpperCase() == 'CAD' ? '\$' : '';
    return '$symbol${dollars.toStringAsFixed(2)} $currency';
  }

  String _truncateId(String id) {
    if (id.length <= 12) return id;
    return '${id.substring(0, 8)}...${id.substring(id.length - 4)}';
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Référence copiée'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

