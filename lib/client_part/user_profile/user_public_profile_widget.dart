/// User public profile screen.
///
/// **PR-FIX-03:** Displays public profile of a worker or client.
/// Replaces the template ClientPublicProfileWidget and ProviderPublicProfileWidget.
library;

import 'package:flutter/material.dart';

import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/ratings/ratings_models.dart';
import '/services/ratings/ratings_service.dart';
import '/services/users/users_service.dart';
import '/client_part/all_reviews/all_reviews_widget.dart';

/// Public profile page for any user (worker or client).
///
/// Usage in routes:
/// ```dart
/// FFRoute(
///   name: UserPublicProfileWidget.routeName,
///   path: UserPublicProfileWidget.routePath,
///   builder: (context, params) => UserPublicProfileWidget(
///     userId: params.getParam('userId', ParamType.String) ?? '',
///   ),
/// )
/// ```
class UserPublicProfileWidget extends StatefulWidget {
  const UserPublicProfileWidget({
    super.key,
    required this.userId,
    this.userName,
    this.userAvatar,
  });

  /// User ID to display.
  final String userId;

  /// Optional name (passed from navigation, faster display).
  final String? userName;

  /// Optional avatar URL (passed from navigation, faster display).
  final String? userAvatar;

  static const String routeName = 'UserPublicProfile';
  static const String routePath = '/user/:userId';

  @override
  State<UserPublicProfileWidget> createState() => _UserPublicProfileWidgetState();
}

class _UserPublicProfileWidgetState extends State<UserPublicProfileWidget> {
  bool _isLoading = true;
  String? _errorMessage;
  UserInfo? _user;
  RatingSummary? _ratingSummary;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (widget.userId.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'ID utilisateur manquant';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load user info
      final user = await UsersService.getUserById(widget.userId);
      if (user == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Utilisateur introuvable';
        });
        return;
      }

      // Load rating summary
      final ratingsResult = await RatingsService.fetchSummary(widget.userId);

      if (mounted) {
        setState(() {
          _user = user;
          _ratingSummary = ratingsResult.isSuccess ? ratingsResult.data : null;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[UserPublicProfile] Error loading profile: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Impossible de charger le profil';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
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
          'Profil',
          style: theme.titleMedium.override(
            fontFamily: 'General Sans',
            letterSpacing: 0,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(context, theme),
    );
  }

  Widget _buildBody(BuildContext context, FlutterFlowTheme theme) {
    // Loading state
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: theme.primary,
            ),
            const SizedBox(height: WkSpacing.md),
            Text(
              WkCopy.loading,
              style: theme.bodyMedium.override(
                fontFamily: 'General Sans',
                color: theme.secondaryText,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      );
    }

    // Error state
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(WkSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_off_outlined,
                size: WkIconSize.xxxl,
                color: theme.secondaryText,
              ),
              const SizedBox(height: WkSpacing.lg),
              Text(
                _errorMessage!,
                style: theme.bodyLarge.override(
                  fontFamily: 'General Sans',
                  color: theme.secondaryText,
                  letterSpacing: 0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: WkSpacing.xxl),
              ElevatedButton.icon(
                onPressed: _loadProfile,
                icon: const Icon(Icons.refresh),
                label: Text(WkCopy.retry),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: WkSpacing.xxl,
                    vertical: WkSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(WkRadius.button),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Profile loaded
    return RefreshIndicator(
      onRefresh: _loadProfile,
      color: theme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(WkSpacing.xl),
        child: Column(
          children: [
            // Avatar
            _buildAvatar(theme),
            const SizedBox(height: WkSpacing.lg),

            // Name
            Text(
              _user?.displayName ?? widget.userName ?? 'Utilisateur',
              style: theme.headlineSmall.override(
                fontFamily: 'General Sans',
                fontWeight: FontWeight.bold,
                letterSpacing: 0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: WkSpacing.sm),

            // Role badge
            _buildRoleBadge(theme),
            const SizedBox(height: WkSpacing.xxl),

            // Rating section
            if (_ratingSummary != null) ...[
              _buildRatingSection(theme),
              const SizedBox(height: WkSpacing.xxl),
            ],

            // Reviews button
            _buildReviewsButton(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(FlutterFlowTheme theme) {
    final avatarUrl = _user?.photoUrl ?? widget.userAvatar;
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.primary.withOpacity(0.1),
        border: Border.all(
          color: theme.primary.withOpacity(0.3),
          width: 3,
        ),
      ),
      child: ClipOval(
        child: hasAvatar
            ? Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(theme),
              )
            : _buildAvatarPlaceholder(theme),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(FlutterFlowTheme theme) {
    return Center(
      child: Icon(
        Icons.person,
        size: WkIconSize.xxxl,
        color: theme.primary,
      ),
    );
  }

  Widget _buildRoleBadge(FlutterFlowTheme theme) {
    final role = _user?.userType?.toLowerCase() ?? 'user';
    final (label, color) = switch (role) {
      'worker' || 'provider' => ('Prestataire', WkStatusColors.open),
      'employer' || 'client' => ('Client', WkStatusColors.assigned),
      'residential' => ('Résidentiel', WkStatusColors.inProgress),
      _ => ('Membre', theme.secondaryText),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: WkSpacing.md,
        vertical: WkSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(WkRadius.xxl),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: theme.bodySmall.override(
          fontFamily: 'General Sans',
          color: color,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
      ),
    );
  }

  Widget _buildRatingSection(FlutterFlowTheme theme) {
    final summary = _ratingSummary!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(WkSpacing.xl),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(WkRadius.card),
      ),
      child: Column(
        children: [
          // Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starValue = index + 1;
              final isFilled = starValue <= summary.average.round();
              final isHalf = !isFilled && 
                  starValue - 0.5 <= summary.average && 
                  starValue > summary.average;

              return Icon(
                isHalf ? Icons.star_half : Icons.star,
                size: 32,
                color: isFilled || isHalf
                    ? const Color(0xFFFBBF24) // Amber
                    : theme.alternate,
              );
            }),
          ),
          const SizedBox(height: WkSpacing.md),

          // Rating text
          Text(
            summary.average.toStringAsFixed(1),
            style: theme.headlineMedium.override(
              fontFamily: 'General Sans',
              fontWeight: FontWeight.bold,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: WkSpacing.xs),

          // Reviews count
          Text(
            summary.count == 0
                ? WkCopy.noReviews
                : summary.count == 1
                    ? WkCopy.oneReview
                    : '${summary.count} ${WkCopy.reviewsCount}',
            style: theme.bodyMedium.override(
              fontFamily: 'General Sans',
              color: theme.secondaryText,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsButton(BuildContext context, FlutterFlowTheme theme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          context.pushNamed(
            AllReviewsWidget.routeName,
            queryParameters: {
              'userId': widget.userId,
            },
          );
        },
        icon: const Icon(Icons.reviews_outlined),
        label: Text(WkCopy.seeAllReviews),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.primary,
          side: BorderSide(color: theme.primary),
          padding: const EdgeInsets.symmetric(
            vertical: WkSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WkRadius.button),
          ),
        ),
      ),
    );
  }
}

