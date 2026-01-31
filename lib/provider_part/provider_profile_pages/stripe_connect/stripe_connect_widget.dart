/// Stripe Connect onboarding page.
///
/// Displays Stripe Connect status and allows Workers to start onboarding
/// to receive payments for completed missions.
///
/// **FL-STRIPE-CONNECT:** Initial implementation.
library;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/payments/stripe_connect_api.dart';
import '/services/payments/stripe_connect_service.dart';
import 'stripe_connect_model.dart';

export 'stripe_connect_model.dart';

/// Widget for managing Stripe Connect account.
///
/// Shows current status and allows Workers to:
/// - Start onboarding if no account
/// - Complete pending requirements
/// - View account status
class StripeConnectWidget extends StatefulWidget {
  const StripeConnectWidget({super.key});

  static String routeName = 'StripeConnect';
  static String routePath = '/stripeConnect';

  @override
  State<StripeConnectWidget> createState() => _StripeConnectWidgetState();
}

class _StripeConnectWidgetState extends State<StripeConnectWidget> {
  late StripeConnectModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // State
  bool _isLoading = true;
  bool _isActionLoading = false;
  String? _errorMessage;
  StripeConnectStatus _status = const StripeConnectStatus.empty();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StripeConnectModel());
    _loadStatus();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadStatus() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final status = await StripeConnectService.getStatus(forceRefresh: true);
      if (mounted) {
        setState(() {
          _status = status;
          _isLoading = false;
        });
      }
    } on StripeConnectException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[StripeConnect] Error loading status: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Impossible de charger le statut';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _startOnboarding() async {
    setState(() {
      _isActionLoading = true;
      _errorMessage = null;
    });

    try {
      final url = await StripeConnectService.getOnboardingUrl();

      // Open in external browser
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw const StripeConnectException("Impossible d'ouvrir le lien");
      }

      if (mounted) {
        setState(() => _isActionLoading = false);

        // Show message to refresh after completing
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Complétez la vérification puis revenez ici pour rafraîchir',
            ),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      }
    } on StripeConnectException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isActionLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[StripeConnect] Error starting onboarding: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Une erreur est survenue';
          _isActionLoading = false;
        });
      }
    }
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
            'Recevoir des paiements',
            style: theme.titleMedium.override(
              fontFamily: 'General Sans',
              letterSpacing: 0,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.refresh_rounded,
                color: theme.primaryText,
              ),
              onPressed: _isLoading ? null : _loadStatus,
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
        child: CircularProgressIndicator(
          color: theme.primary,
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildError(theme);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header illustration
          _buildHeader(theme),
          const SizedBox(height: 24),

          // Status card
          _buildStatusCard(theme),
          const SizedBox(height: 24),

          // Benefits
          _buildBenefits(theme),
          const SizedBox(height: 24),

          // Action button
          _buildActionButton(theme),
          const SizedBox(height: 16),

          // Info text
          _buildInfoText(theme),
        ],
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
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: theme.error,
            ),
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
              onPressed: _loadStatus,
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

  Widget _buildHeader(FlutterFlowTheme theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primary.withOpacity(0.1),
            theme.secondary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            _status.isFullyEnabled
                ? Icons.check_circle_rounded
                : Icons.account_balance_wallet_rounded,
            size: 64,
            color: _status.isFullyEnabled ? theme.success : theme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            _status.isFullyEnabled
                ? 'Compte actif!'
                : 'Configurez vos paiements',
            style: theme.headlineSmall.override(
              fontFamily: 'General Sans',
              letterSpacing: 0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _status.isFullyEnabled
                ? 'Vous pouvez recevoir des paiements pour vos missions'
                : 'Complétez la vérification pour recevoir vos gains',
            style: theme.bodyMedium.override(
              fontFamily: 'General Sans',
              color: theme.secondaryText,
              letterSpacing: 0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(FlutterFlowTheme theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: theme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Statut du compte',
                style: theme.titleSmall.override(
                  fontFamily: 'General Sans',
                  letterSpacing: 0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatusRow(
            theme,
            'Compte créé',
            _status.hasAccount,
          ),
          const SizedBox(height: 12),
          _buildStatusRow(
            theme,
            'Vérification complétée',
            _status.detailsSubmitted,
          ),
          const SizedBox(height: 12),
          _buildStatusRow(
            theme,
            'Paiements activés',
            _status.chargesEnabled,
          ),
          const SizedBox(height: 12),
          _buildStatusRow(
            theme,
            'Virements activés',
            _status.payoutsEnabled,
          ),
          if (_status.requirementsNeeded.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: theme.warning,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Documents supplémentaires requis',
                      style: theme.bodySmall.override(
                        fontFamily: 'General Sans',
                        color: theme.warning,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusRow(FlutterFlowTheme theme, String label, bool isComplete) {
    return Row(
      children: [
        Icon(
          isComplete ? Icons.check_circle_rounded : Icons.circle_outlined,
          color: isComplete ? theme.success : theme.secondaryText,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.bodyMedium.override(
              fontFamily: 'General Sans',
              letterSpacing: 0,
            ),
          ),
        ),
        Text(
          isComplete ? 'Complété' : 'En attente',
          style: theme.bodySmall.override(
            fontFamily: 'General Sans',
            color: isComplete ? theme.success : theme.secondaryText,
            letterSpacing: 0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBenefits(FlutterFlowTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Avantages',
          style: theme.titleSmall.override(
            fontFamily: 'General Sans',
            letterSpacing: 0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _buildBenefitItem(
          theme,
          Icons.flash_on_rounded,
          'Paiements rapides',
          'Recevez vos gains directement sur votre compte',
        ),
        const SizedBox(height: 12),
        _buildBenefitItem(
          theme,
          Icons.security_rounded,
          'Sécurisé par Stripe',
          'Vos données financières sont protégées',
        ),
        const SizedBox(height: 12),
        _buildBenefitItem(
          theme,
          Icons.attach_money_rounded,
          'Sans frais cachés',
          'Commission transparente de 12% par mission',
        ),
      ],
    );
  }

  Widget _buildBenefitItem(
    FlutterFlowTheme theme,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: theme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: theme.primary,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.bodyMedium.override(
                  fontFamily: 'General Sans',
                  letterSpacing: 0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: theme.bodySmall.override(
                  fontFamily: 'General Sans',
                  color: theme.secondaryText,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(FlutterFlowTheme theme) {
    String buttonText;
    Color buttonColor;
    bool enabled = !_isActionLoading;

    if (_status.isFullyEnabled) {
      buttonText = 'Voir le tableau de bord Stripe';
      buttonColor = theme.secondary;
    } else if (_status.hasAccount && !_status.detailsSubmitted) {
      buttonText = 'Continuer la vérification';
      buttonColor = theme.primary;
    } else if (_status.hasAccount && _status.requirementsNeeded.isNotEmpty) {
      buttonText = 'Compléter les documents';
      buttonColor = theme.warning;
    } else if (_status.hasAccount) {
      buttonText = 'Vérification en cours...';
      buttonColor = theme.secondaryText;
      enabled = false;
    } else {
      buttonText = 'Commencer la configuration';
      buttonColor = theme.primary;
    }

    return FFButtonWidget(
      onPressed: enabled ? _startOnboarding : null,
      text: _isActionLoading ? 'Chargement...' : buttonText,
      options: FFButtonOptions(
        width: double.infinity,
        height: 55,
        color: enabled ? buttonColor : theme.secondaryText.withOpacity(0.3),
        textStyle: theme.titleSmall.override(
          fontFamily: 'General Sans',
          color: Colors.white,
          letterSpacing: 0,
        ),
        elevation: 0,
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  Widget _buildInfoText(FlutterFlowTheme theme) {
    return Text(
      'La vérification est effectuée par Stripe, notre partenaire de paiement sécurisé. '
      'Vos informations personnelles sont protégées et ne sont jamais partagées.',
      style: theme.bodySmall.override(
        fontFamily: 'General Sans',
        color: theme.secondaryText,
        letterSpacing: 0,
      ),
      textAlign: TextAlign.center,
    );
  }
}
