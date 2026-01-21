/// Legal consent screen for WorkOn.
///
/// Shown on first launch and when legal documents are updated.
/// Requires user to accept Terms of Service and Privacy Policy
/// before proceeding to the app.
///
/// **PR-V1-01:** Store-ready legal consent screen.
library;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import '/services/legal/consent_store.dart';

/// Legal consent screen widget.
///
/// Displays Terms of Service and Privacy Policy acceptance checkboxes
/// with links to view the full documents.
///
/// ## Usage
///
/// Shown automatically by [LegalConsentGate] when consent is required.
/// Can also be navigated to directly for re-acceptance.
class LegalConsentWidget extends StatefulWidget {
  const LegalConsentWidget({
    super.key,
    this.onConsentAccepted,
    this.isModal = false,
  });

  /// Callback when consent is successfully accepted.
  /// If null, navigates to HomeWidget automatically.
  final VoidCallback? onConsentAccepted;

  /// Whether this is shown as a modal (cannot be dismissed).
  final bool isModal;

  static String routeName = 'LegalConsent';
  static String routePath = '/legalConsent';

  @override
  State<LegalConsentWidget> createState() => _LegalConsentWidgetState();
}

class _LegalConsentWidgetState extends State<LegalConsentWidget> {
  bool _termsAccepted = false;
  bool _privacyAccepted = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get _canAccept => _termsAccepted && _privacyAccepted && !_isLoading;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Prevent back navigation if modal mode
      canPop: !widget.isModal,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(WkSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  _buildHeader(context),
                  
                  const SizedBox(height: WkSpacing.xxl),
                  
                  // Welcome text
                  _buildWelcomeText(context),
                  
                  const SizedBox(height: WkSpacing.xxxl),
                  
                  // Checkboxes
                  _buildTermsCheckbox(context),
                  const SizedBox(height: WkSpacing.lg),
                  _buildPrivacyCheckbox(context),
                  
                  // Error message
                  if (_errorMessage != null) ...[
                    const SizedBox(height: WkSpacing.lg),
                    _buildErrorMessage(context),
                  ],
                  
                  const Spacer(),
                  
                  // Legal disclaimer
                  _buildDisclaimer(context),
                  
                  const SizedBox(height: WkSpacing.xl),
                  
                  // Accept button
                  _buildAcceptButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(WkRadius.sm),
          child: Image.asset(
            'assets/images/Sparkly_Logo.png',
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: WkSpacing.md),
        Text(
          'WorkOn',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'General Sans',
                fontWeight: FontWeight.bold,
                letterSpacing: 0.0,
              ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          FFLocalizations.of(context).getVariableText(
            frText: 'Bienvenue sur WorkOn',
            enText: 'Welcome to WorkOn',
          ),
          style: FlutterFlowTheme.of(context).headlineLarge.override(
                fontFamily: 'General Sans',
                fontWeight: FontWeight.bold,
                letterSpacing: 0.0,
              ),
        ),
        const SizedBox(height: WkSpacing.md),
        Text(
          FFLocalizations.of(context).getVariableText(
            frText: 'Pour continuer, veuillez accepter nos conditions d\'utilisation et notre politique de confidentialité.',
            enText: 'To continue, please accept our terms of service and privacy policy.',
          ),
          style: FlutterFlowTheme.of(context).bodyLarge.override(
                fontFamily: 'General Sans',
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
                lineHeight: 1.5,
              ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox(BuildContext context) {
    return _ConsentCheckbox(
      value: _termsAccepted,
      onChanged: (value) => setState(() => _termsAccepted = value ?? false),
      label: FFLocalizations.of(context).getVariableText(
        frText: 'J\'accepte les ',
        enText: 'I accept the ',
      ),
      linkText: FFLocalizations.of(context).getVariableText(
        frText: 'Conditions d\'utilisation',
        enText: 'Terms of Service',
      ),
      onLinkTap: () => context.pushNamed(TermsOfServiceWidget.routeName),
    );
  }

  Widget _buildPrivacyCheckbox(BuildContext context) {
    return _ConsentCheckbox(
      value: _privacyAccepted,
      onChanged: (value) => setState(() => _privacyAccepted = value ?? false),
      label: FFLocalizations.of(context).getVariableText(
        frText: 'J\'accepte la ',
        enText: 'I accept the ',
      ),
      linkText: FFLocalizations.of(context).getVariableText(
        frText: 'Politique de confidentialité',
        enText: 'Privacy Policy',
      ),
      onLinkTap: () => context.pushNamed(PrivacyPolicyWidget.routeName),
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(WkSpacing.md),
      decoration: BoxDecoration(
        color: WkStatusColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(WkRadius.sm),
        border: Border.all(color: WkStatusColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: WkStatusColors.error,
            size: WkIconSize.md,
          ),
          const SizedBox(width: WkSpacing.sm),
          Expanded(
            child: Text(
              _errorMessage!,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'General Sans',
                    color: WkStatusColors.error,
                    letterSpacing: 0.0,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(WkSpacing.md),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(WkRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: WkIconSize.md,
          ),
          const SizedBox(width: WkSpacing.sm),
          Expanded(
            child: Text(
              FFLocalizations.of(context).getVariableText(
                frText: 'WorkOn est une plateforme de mise en relation entre travailleurs autonomes et clients. '
                    'Aucun lien d\'emploi n\'est créé entre les parties.',
                enText: 'WorkOn is a platform connecting freelancers with clients. '
                    'No employment relationship is created between parties.',
              ),
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                    lineHeight: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptButton(BuildContext context) {
    return FFButtonWidget(
      onPressed: _canAccept ? _onAccept : null,
      text: _isLoading
          ? FFLocalizations.of(context).getVariableText(
              frText: 'Enregistrement...',
              enText: 'Saving...',
            )
          : FFLocalizations.of(context).getVariableText(
              frText: 'Accepter et continuer',
              enText: 'Accept and continue',
            ),
      options: FFButtonOptions(
        width: double.infinity,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: WkSpacing.lg),
        iconPadding: EdgeInsets.zero,
        color: _canAccept
            ? FlutterFlowTheme.of(context).primary
            : FlutterFlowTheme.of(context).secondaryBackground,
        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
              fontFamily: 'General Sans',
              color: _canAccept
                  ? Colors.white
                  : FlutterFlowTheme.of(context).secondaryText,
              fontSize: 16,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
            ),
        elevation: _canAccept ? 2 : 0,
        borderRadius: BorderRadius.circular(WkRadius.button),
      ),
    );
  }

  Future<void> _onAccept() async {
    if (!_canAccept) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Initialize consent store if needed
      await ConsentStore.initialize();
      
      // Accept all legal documents via backend
      await ConsentStore.acceptAll();

      debugPrint('[LegalConsent] Consent accepted successfully');

      if (!mounted) return;

      // Call callback or navigate to home
      if (widget.onConsentAccepted != null) {
        widget.onConsentAccepted!();
      } else {
        // Navigate to home and clear stack
        context.goNamed(HomeWidget.routeName);
      }
    } catch (e) {
      debugPrint('[LegalConsent] Error accepting consent: $e');
      
      if (!mounted) return;
      
      setState(() {
        _errorMessage = FFLocalizations.of(context).getVariableText(
          frText: 'Une erreur est survenue. Veuillez réessayer.',
          enText: 'An error occurred. Please try again.',
        );
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

/// Consent checkbox widget with link to view document.
class _ConsentCheckbox extends StatelessWidget {
  const _ConsentCheckbox({
    required this.value,
    required this.onChanged,
    required this.label,
    required this.linkText,
    required this.onLinkTap,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;
  final String linkText;
  final VoidCallback onLinkTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(WkRadius.md),
      child: Container(
        padding: const EdgeInsets.all(WkSpacing.md),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(WkRadius.md),
          border: Border.all(
            color: value
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            width: value ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Checkbox
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: value
                    ? FlutterFlowTheme.of(context).primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: value
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).secondaryText,
                  width: 2,
                ),
              ),
              child: value
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: WkSpacing.md),
            
            // Text with link
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'General Sans',
                        letterSpacing: 0.0,
                      ),
                  children: [
                    TextSpan(text: label),
                    TextSpan(
                      text: linkText,
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = onLinkTap,
                    ),
                  ],
                ),
              ),
            ),
            
            // Arrow icon
            Icon(
              Icons.chevron_right,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: WkIconSize.lg,
            ),
          ],
        ),
      ),
    );
  }
}

