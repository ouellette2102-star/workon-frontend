import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/offers/offer_models.dart';
import '/services/offers/offers_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// PR-02: Page displaying applications for a specific mission.
///
/// Employer can view all applicants and their details.
class MissionApplicationsWidget extends StatefulWidget {
  const MissionApplicationsWidget({
    super.key,
    required this.missionId,
    this.missionTitle,
  });

  final String missionId;
  final String? missionTitle;

  static String routeName = 'MissionApplications';
  static String routePath = '/missionApplications/:missionId';

  @override
  State<MissionApplicationsWidget> createState() =>
      _MissionApplicationsWidgetState();
}

class _MissionApplicationsWidgetState extends State<MissionApplicationsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _api = OffersApi();

  List<Offer> _applications = [];
  bool _isLoading = true;
  String? _errorMessage;

  // PR-03: Track offers being processed
  final Set<String> _processingOfferIds = {};
  // PR-03: Track if any offer has been accepted (mission assigned)
  bool _hasAcceptedOffer = false;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final applications = await _api.fetchMissionApplications(widget.missionId);

      if (!mounted) return;

      // Sort by most recent first
      applications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // PR-03: Check if any offer is already accepted
      final hasAccepted = applications.any((o) => o.status == OfferStatus.accepted);

      setState(() {
        _applications = applications;
        _isLoading = false;
        _hasAcceptedOffer = hasAccepted;
      });
    } catch (e) {
      debugPrint('[MissionApplications] Error loading applications: $e');
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = WkCopy.errorGeneric;
      });
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PR-03: Accept/Reject Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// PR-03: Accepts an offer (assigns worker to mission).
  Future<void> _acceptOffer(Offer offer) async {
    if (_processingOfferIds.contains(offer.id)) return;
    if (_hasAcceptedOffer) return; // Already assigned

    setState(() {
      _processingOfferIds.add(offer.id);
    });

    try {
      final updatedOffer = await _api.acceptOffer(offer.id);

      if (!mounted) return;

      // Update the offer in the list
      setState(() {
        _processingOfferIds.remove(offer.id);
        _hasAcceptedOffer = true;
        
        // Update the offer status in the list
        final index = _applications.indexWhere((o) => o.id == offer.id);
        if (index >= 0) {
          _applications[index] = updatedOffer;
        }
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Candidat accepté avec succès !'),
          backgroundColor: WkStatusColors.completed,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Close the drawer
      Navigator.of(context).pop();

    } catch (e) {
      debugPrint('[MissionApplications] Error accepting offer: $e');
      if (!mounted) return;

      setState(() {
        _processingOfferIds.remove(offer.id);
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e is OffersApiException 
              ? e.message 
              : 'Erreur lors de l\'acceptation'),
          backgroundColor: WkStatusColors.cancelled,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Réessayer',
            textColor: Colors.white,
            onPressed: () => _acceptOffer(offer),
          ),
        ),
      );
    }
  }

  /// PR-03: Rejects an offer.
  Future<void> _rejectOffer(Offer offer) async {
    if (_processingOfferIds.contains(offer.id)) return;

    setState(() {
      _processingOfferIds.add(offer.id);
    });

    try {
      final updatedOffer = await _api.rejectOffer(offer.id);

      if (!mounted) return;

      // Update the offer in the list
      setState(() {
        _processingOfferIds.remove(offer.id);
        
        // Update the offer status in the list
        final index = _applications.indexWhere((o) => o.id == offer.id);
        if (index >= 0) {
          _applications[index] = updatedOffer;
        }
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Candidature refusée'),
          backgroundColor: FlutterFlowTheme.of(context).secondaryText,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Close the drawer
      Navigator.of(context).pop();

    } catch (e) {
      debugPrint('[MissionApplications] Error rejecting offer: $e');
      if (!mounted) return;

      setState(() {
        _processingOfferIds.remove(offer.id);
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e is OffersApiException 
              ? e.message 
              : 'Erreur lors du refus'),
          backgroundColor: WkStatusColors.cancelled,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Réessayer',
            textColor: Colors.white,
            onPressed: () => _rejectOffer(offer),
          ),
        ),
      );
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Candidatures',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: 'General Sans',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                      ),
                ),
                if (widget.missionTitle != null)
                  Text(
                    widget.missionTitle!,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          // Refresh button
          IconButton(
            onPressed: _loadApplications,
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

    if (_applications.isEmpty) {
      return _buildEmptyState(context);
    }

    return _buildApplicationsList(context);
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
              onPressed: _loadApplications,
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
              Icons.inbox_outlined,
              size: 64,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            SizedBox(height: WkSpacing.lg),
            Text(
              'Aucune candidature',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: WkSpacing.sm),
            Text(
              'Personne n\'a encore postulé à cette mission.\nLes candidatures apparaîtront ici.',
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

  Widget _buildApplicationsList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadApplications,
      color: FlutterFlowTheme.of(context).primary,
      child: ListView.separated(
        padding: EdgeInsets.all(WkSpacing.pagePadding),
        itemCount: _applications.length,
        separatorBuilder: (_, __) => SizedBox(height: WkSpacing.md),
        itemBuilder: (context, index) {
          final application = _applications[index];
          return _buildApplicationCard(context, application);
        },
      ),
    );
  }

  Widget _buildApplicationCard(BuildContext context, Offer application) {
    final applicant = application.applicant;
    final displayName = applicant?.displayName ?? 'Candidat';
    final initials = applicant?.initials ?? '?';

    return GestureDetector(
      onTap: () => _showApplicantDetail(context, application),
      child: Container(
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
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(WkRadius.md),
              ),
              child: applicant?.avatarUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(WkRadius.md),
                      child: Image.network(
                        applicant!.avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(
                          context,
                          initials,
                        ),
                      ),
                    )
                  : _buildAvatarPlaceholder(context, initials),
            ),
            SizedBox(width: WkSpacing.md),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          displayName,
                          style:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'General Sans',
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.0,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: WkSpacing.sm),
                      _buildStatusChip(context, application.status),
                    ],
                  ),
                  SizedBox(height: WkSpacing.xs),

                  // Rating if available
                  if (applicant?.rating != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        SizedBox(width: WkSpacing.xs),
                        Text(
                          applicant!.rating!.toStringAsFixed(1),
                          style:
                              FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'General Sans',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        if (applicant.reviewCount != null) ...[
                          Text(
                            ' (${applicant.reviewCount} avis)',
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: 'General Sans',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: WkSpacing.xs),
                  ],

                  // Message preview
                  if (application.message != null &&
                      application.message!.isNotEmpty) ...[
                    Text(
                      application.message!,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'General Sans',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: WkSpacing.xs),
                  ],

                  // Date
                  Text(
                    'Postulé le ${DateFormat('dd MMM yyyy', 'fr_FR').format(application.createdAt)}',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 11,
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ),
            ),

            // Chevron
            Icon(
              Icons.chevron_right,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(BuildContext context, String initials) {
    return Center(
      child: Text(
        initials,
        style: FlutterFlowTheme.of(context).titleMedium.override(
              fontFamily: 'General Sans',
              color: FlutterFlowTheme.of(context).primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.0,
            ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, OfferStatus status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case OfferStatus.pending:
        backgroundColor = WkStatusColors.open.withOpacity(0.1);
        textColor = WkStatusColors.open;
        break;
      case OfferStatus.accepted:
        backgroundColor = WkStatusColors.completed.withOpacity(0.1);
        textColor = WkStatusColors.completed;
        break;
      case OfferStatus.rejected:
        backgroundColor = WkStatusColors.cancelled.withOpacity(0.1);
        textColor = WkStatusColors.cancelled;
        break;
      default:
        backgroundColor =
            FlutterFlowTheme.of(context).secondaryText.withOpacity(0.1);
        textColor = FlutterFlowTheme.of(context).secondaryText;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: WkSpacing.sm,
        vertical: WkSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(WkRadius.xs),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  /// PR-02: Shows applicant detail drawer/modal with action buttons.
  void _showApplicantDetail(BuildContext context, Offer application) {
    final applicant = application.applicant;
    final displayName = applicant?.displayName ?? 'Candidat';
    final initials = applicant?.initials ?? '?';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(WkRadius.lg),
              topRight: Radius.circular(WkRadius.lg),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: EdgeInsets.only(top: WkSpacing.md),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).alternate,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(WkSpacing.pagePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primary
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(WkRadius.md),
                            ),
                            child: applicant?.avatarUrl != null
                                ? ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(WkRadius.md),
                                    child: Image.network(
                                      applicant!.avatarUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _buildAvatarPlaceholder(
                                        context,
                                        initials,
                                      ),
                                    ),
                                  )
                                : _buildAvatarPlaceholder(context, initials),
                          ),
                          SizedBox(width: WkSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        fontFamily: 'General Sans',
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                SizedBox(height: WkSpacing.xs),
                                _buildStatusChip(context, application.status),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: WkSpacing.lg),

                      // Rating
                      if (applicant?.rating != null) ...[
                        _buildDetailRow(
                          context,
                          icon: Icons.star,
                          iconColor: Colors.amber,
                          label: 'Évaluation',
                          value:
                              '${applicant!.rating!.toStringAsFixed(1)} ${applicant.reviewCount != null ? "(${applicant.reviewCount} avis)" : ""}',
                        ),
                        SizedBox(height: WkSpacing.md),
                      ],

                      // Bio
                      if (applicant?.bio != null &&
                          applicant!.bio!.isNotEmpty) ...[
                        Text(
                          'À propos',
                          style:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'General Sans',
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        SizedBox(height: WkSpacing.sm),
                        Text(
                          applicant.bio!,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        SizedBox(height: WkSpacing.lg),
                      ],

                      // Message
                      if (application.message != null &&
                          application.message!.isNotEmpty) ...[
                        Text(
                          'Message de candidature',
                          style:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'General Sans',
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        SizedBox(height: WkSpacing.sm),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(WkSpacing.md),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .primaryBackground,
                            borderRadius: BorderRadius.circular(WkRadius.sm),
                          ),
                          child: Text(
                            application.message!,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'General Sans',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        SizedBox(height: WkSpacing.lg),
                      ],

                      // Applied date
                      _buildDetailRow(
                        context,
                        icon: Icons.schedule,
                        label: 'Postulé le',
                        value: DateFormat('dd MMMM yyyy à HH:mm', 'fr_FR')
                            .format(application.createdAt),
                      ),
                      SizedBox(height: WkSpacing.xl),

                      // PR-03: Action buttons (wired to API)
                      if (application.status == OfferStatus.pending && !_hasAcceptedOffer) ...[
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _processingOfferIds.contains(application.id)
                                    ? null
                                    : () => _rejectOffer(application),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: WkStatusColors.cancelled,
                                  side: BorderSide(
                                      color: WkStatusColors.cancelled),
                                  padding: EdgeInsets.symmetric(
                                      vertical: WkSpacing.md),
                                ),
                                child: _processingOfferIds.contains(application.id)
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: WkStatusColors.cancelled,
                                        ),
                                      )
                                    : const Text('Refuser'),
                              ),
                            ),
                            SizedBox(width: WkSpacing.md),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _processingOfferIds.contains(application.id)
                                    ? null
                                    : () => _acceptOffer(application),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).primary,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: WkSpacing.md),
                                ),
                                child: _processingOfferIds.contains(application.id)
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Accepter'),
                              ),
                            ),
                          ],
                        ),
                      ],

                      // PR-03: Show "already assigned" message for pending offers when mission is assigned
                      if (application.status == OfferStatus.pending && _hasAcceptedOffer) ...[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(WkSpacing.md),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryText.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(WkRadius.sm),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).secondaryText.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                              SizedBox(width: WkSpacing.sm),
                              Expanded(
                                child: Text(
                                  'Un autre candidat a été accepté pour cette mission.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'General Sans',
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Already accepted/rejected message
                      if (application.status == OfferStatus.accepted) ...[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(WkSpacing.md),
                          decoration: BoxDecoration(
                            color: WkStatusColors.completed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(WkRadius.sm),
                            border: Border.all(
                              color: WkStatusColors.completed.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: WkStatusColors.completed,
                              ),
                              SizedBox(width: WkSpacing.sm),
                              Expanded(
                                child: Text(
                                  'Ce candidat a été accepté pour cette mission.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'General Sans',
                                        color: WkStatusColors.completed,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      if (application.status == OfferStatus.rejected) ...[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(WkSpacing.md),
                          decoration: BoxDecoration(
                            color: WkStatusColors.cancelled.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(WkRadius.sm),
                            border: Border.all(
                              color: WkStatusColors.cancelled.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.cancel,
                                color: WkStatusColors.cancelled,
                              ),
                              SizedBox(width: WkSpacing.sm),
                              Expanded(
                                child: Text(
                                  'Ce candidat a été refusé.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'General Sans',
                                        color: WkStatusColors.cancelled,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    Color? iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: iconColor ?? FlutterFlowTheme.of(context).secondaryText,
        ),
        SizedBox(width: WkSpacing.sm),
        Text(
          '$label: ',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'General Sans',
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
              ),
        ),
        Expanded(
          child: Text(
            value,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'General Sans',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.0,
                ),
          ),
        ),
      ],
    );
  }
}

