import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '/backend/schema/structs/index.dart';

import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';

import '/index.dart';
import '/app/auth_gate.dart';
import '/services/missions/mission_models.dart';
import '/client_part/my_applications/my_applications_widget.dart';
import '/client_part/worker_assignments/worker_assignments_widget.dart';
import '/client_part/employer_missions/employer_missions_widget.dart';
import '/client_part/employer_missions/mission_applications_widget.dart';
import '/client_part/payments/transactions_widget.dart';
import '/provider_part/jobs/jobs_real_widget.dart';
import '/provider_part/earnings/earnings_real_widget.dart';
import '/client_part/profile_pages/notification_settings/notification_settings_real_widget.dart';
import '/client_part/search_results/search_results_real_widget.dart';
import '/client_part/saved/saved_missions_page.dart';
import '/client_part/deep_link_handler/deep_link_handler_widget.dart';
import '/client_part/deep_link_error/deep_link_error_widget.dart';
import '/services/deep_linking/deep_link_service.dart';
// PR-DISCOVERY: Discovery feature imports
import '/client_part/discovery/swipe_discovery_page.dart';
import '/client_part/discovery/map_discovery_page.dart';
// PR-V1-01: Legal consent
import '/client_part/legal/legal_consent_widget.dart';
// PR-FIX-02: Coming Soon screen for unimplemented routes
import '/components/coming_soon_screen.dart';
// PR-FIX-03: User public profile
import '/client_part/user_profile/user_public_profile_widget.dart';
// FL-SPRINT2-3: New features
import '/client_part/support_tickets/support_tickets_widget.dart';
import '/client_part/notification_settings/notification_settings_widget.dart' as notif_settings;
import '/provider_part/provider_profile_pages/stripe_connect/stripe_connect_widget.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) => appStateNotifier.showSplashImage
          ? Builder(
              builder: (context) => Container(
                color: Colors.transparent,
                child: Image.asset(
                  'assets/images/Sparkly_Splash_Screen_V1.0.0.png',
                  fit: BoxFit.cover,
                ),
              ),
            )
          : const AuthGate(), // PR#9: Route through AuthGate for auth state
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.showSplashImage
              ? Builder(
                  builder: (context) => Container(
                    color: Colors.transparent,
                    child: Image.asset(
                      'assets/images/Sparkly_Splash_Screen_V1.0.0.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : const AuthGate(), // PR#9: Route through AuthGate for auth state
        ),
        FFRoute(
          name: HomeWidget.routeName,
          path: HomeWidget.routePath,
          builder: (context, params) => HomeWidget(),
        ),
        // PR-V1-01: Legal consent route
        FFRoute(
          name: LegalConsentWidget.routeName,
          path: LegalConsentWidget.routePath,
          builder: (context, params) => const LegalConsentWidget(),
        ),
        FFRoute(
          name: SignUpWidget.routeName,
          path: SignUpWidget.routePath,
          builder: (context, params) => SignUpWidget(),
        ),
        FFRoute(
          name: SignInWidget.routeName,
          path: SignInWidget.routePath,
          builder: (context, params) => SignInWidget(),
        ),
        FFRoute(
          name: ResetPasswordWidget.routeName,
          path: ResetPasswordWidget.routePath,
          builder: (context, params) => ResetPasswordWidget(),
        ),
        FFRoute(
          name: NotificationsWidget.routeName,
          path: NotificationsWidget.routePath,
          builder: (context, params) => NotificationsWidget(),
        ),
        FFRoute(
          name: AccountWidget.routeName,
          path: AccountWidget.routePath,
          builder: (context, params) => AccountWidget(),
        ),
        FFRoute(
          name: EditProfileWidget.routeName,
          path: EditProfileWidget.routePath,
          builder: (context, params) => EditProfileWidget(),
        ),
        FFRoute(
          name: SettingsWidget.routeName,
          path: SettingsWidget.routePath,
          builder: (context, params) => SettingsWidget(),
        ),
        FFRoute(
          name: NotificationSettingsWidget.routeName,
          path: NotificationSettingsWidget.routePath,
          builder: (context, params) => NotificationSettingsWidget(),
        ),
        FFRoute(
          name: LanguageSettingsWidget.routeName,
          path: LanguageSettingsWidget.routePath,
          builder: (context, params) => LanguageSettingsWidget(),
        ),
        FFRoute(
          name: DeleteAccountWidget.routeName,
          path: DeleteAccountWidget.routePath,
          builder: (context, params) => DeleteAccountWidget(),
        ),
        FFRoute(
          name: ChangeEmailWidget.routeName,
          path: ChangeEmailWidget.routePath,
          builder: (context, params) => ChangeEmailWidget(),
        ),
        FFRoute(
          name: HelpCenterWidget.routeName,
          path: HelpCenterWidget.routePath,
          builder: (context, params) => HelpCenterWidget(),
        ),
        FFRoute(
          name: CustomerSupportWidget.routeName,
          path: CustomerSupportWidget.routePath,
          builder: (context, params) => CustomerSupportWidget(),
        ),
        FFRoute(
          name: TermsOfServiceWidget.routeName,
          path: TermsOfServiceWidget.routePath,
          builder: (context, params) => TermsOfServiceWidget(),
        ),
        FFRoute(
          name: AboutWidget.routeName,
          path: AboutWidget.routePath,
          builder: (context, params) => AboutWidget(),
        ),
        FFRoute(
          name: InviteFriendsWidget.routeName,
          path: InviteFriendsWidget.routePath,
          builder: (context, params) => InviteFriendsWidget(),
        ),
        FFRoute(
          name: PaymentMethodsWidget.routeName,
          path: PaymentMethodsWidget.routePath,
          builder: (context, params) => PaymentMethodsWidget(),
        ),
        FFRoute(
          name: AddNewCardWidget.routeName,
          path: AddNewCardWidget.routePath,
          builder: (context, params) => AddNewCardWidget(),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: VideoCallWidget.routeName,
          path: VideoCallWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Appels vidéo'),
        ),
        // PR-F21: All reviews with optional userId
        FFRoute(
          name: AllReviewsWidget.routeName,
          path: AllReviewsWidget.routePath,
          builder: (context, params) => AllReviewsWidget(
            userId: params.getParam('userId', ParamType.String),
          ),
        ),
        FFRoute(
          name: ChatWidget.routeName,
          path: ChatWidget.routePath,
          builder: (context, params) => ChatWidget(
            conversationId: params.getParam('conversationId', ParamType.String),
            participantName: params.getParam('participantName', ParamType.String),
            participantAvatar: params.getParam('participantAvatar', ParamType.String),
          ),
        ),
        FFRoute(
          name: MessagesWidget.routeName,
          path: MessagesWidget.routePath,
          builder: (context, params) => MessagesWidget(),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: VoiceCallWidget.routeName,
          path: VoiceCallWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Appels vocaux'),
        ),
        FFRoute(
          name: OnboardingWidget.routeName,
          path: OnboardingWidget.routePath,
          builder: (context, params) => OnboardingWidget(),
        ),
        FFRoute(
          name: PrivacyPolicyWidget.routeName,
          path: PrivacyPolicyWidget.routePath,
          builder: (context, params) => PrivacyPolicyWidget(),
        ),
        FFRoute(
          name: CompleteProfleWidget.routeName,
          path: CompleteProfleWidget.routePath,
          builder: (context, params) => CompleteProfleWidget(),
        ),
        FFRoute(
          name: InterviewUserWidget.routeName,
          path: InterviewUserWidget.routePath,
          builder: (context, params) => InterviewUserWidget(),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: SingleCategoryWidget.routeName,
          path: SingleCategoryWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Catégorie'),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: SearchWidget.routeName,
          path: SearchWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Recherche avancée'),
        ),
        // PR-2: Redirect to real search results
        FFRoute(
          name: SearchResultsWidget.routeName,
          path: SearchResultsWidget.routePath,
          builder: (context, params) => SearchResultsRealWidget(),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: ServiceDetailsWidget.routeName,
          path: ServiceDetailsWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Détails du service'),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: ReportServiceWidget.routeName,
          path: ReportServiceWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Signalement'),
        ),
        // PR-FIX-03: Provider public profile -> real user profile
        FFRoute(
          name: ProviderPublicProfileWidget.routeName,
          path: ProviderPublicProfileWidget.routePath,
          builder: (context, params) => UserPublicProfileWidget(
            userId: params.getParam('userId', ParamType.String) ?? '',
          ),
        ),
        // PR-BOOKING: Redirect legacy /bookings to functional /employerMissions
        FFRoute(
          name: BookingsWidget.routeName,
          path: BookingsWidget.routePath,
          builder: (context, params) => EmployerMissionsWidget(),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: BookingDetailsWidget.routeName,
          path: BookingDetailsWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Détails réservation'),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: RescheduleBookingWidget.routeName,
          path: RescheduleBookingWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Replanification'),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: CancelBookingWidget.routeName,
          path: CancelBookingWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Annulation'),
        ),
        // PR-FIX-02: Redirect to Coming Soon (use LeaveReviewSimple for real reviews)
        FFRoute(
          name: LeaveReviewWidget.routeName,
          path: LeaveReviewWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Avis détaillé'),
        ),
        // PR-F21: Leave review with real API
        FFRoute(
          name: LeaveReviewSimpleWidget.routeName,
          path: LeaveReviewSimpleWidget.routePath,
          builder: (context, params) => LeaveReviewSimpleWidget(
            toUserId: params.getParam('toUserId', ParamType.String) ?? '',
            toUserName: params.getParam('toUserName', ParamType.String),
            toUserAvatar: params.getParam('toUserAvatar', ParamType.String),
            missionId: params.getParam('missionId', ParamType.String),
            missionTitle: params.getParam('missionTitle', ParamType.String),
          ),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: BookAgainWidget.routeName,
          path: BookAgainWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Réserver à nouveau'),
        ),
        // PR-2: Redirect to real saved missions page
        FFRoute(
          name: BookmarksWidget.routeName,
          path: BookmarksWidget.routePath,
          builder: (context, params) => SavedMissionsPage(),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: ReviewSummaryWidget.routeName,
          path: ReviewSummaryWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Récapitulatif'),
        ),
        FFRoute(
          name: MyAddressWidget.routeName,
          path: MyAddressWidget.routePath,
          builder: (context, params) => MyAddressWidget(),
        ),
        FFRoute(
          name: AddNewAddressWidget.routeName,
          path: AddNewAddressWidget.routePath,
          builder: (context, params) => AddNewAddressWidget(),
        ),
        FFRoute(
          name: ChooseAddressWidget.routeName,
          path: ChooseAddressWidget.routePath,
          builder: (context, params) => ChooseAddressWidget(),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: ProviderRegistrationWidget.routeName,
          path: ProviderRegistrationWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Inscription prestataire'),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: HomeProviderWidget.routeName,
          path: HomeProviderWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Espace prestataire'),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: JobRequestsWidget.routeName,
          path: JobRequestsWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Demandes d\'emploi'),
        ),
        // PR-2: Redirect to real messages widget
        FFRoute(
          name: MessagesProviderWidget.routeName,
          path: MessagesProviderWidget.routePath,
          builder: (context, params) => MessagesWidget(),
        ),
        // PR-2: Redirect to real jobs widget
        FFRoute(
          name: JobsWidget.routeName,
          path: JobsWidget.routePath,
          builder: (context, params) => JobsRealWidget(
            initialTab: params.getParam(
              'initialTab',
              ParamType.int,
            ) ?? 0,
          ),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: RequestDetailsWidget.routeName,
          path: RequestDetailsWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Détails de la demande'),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: JobDetailsWidget.routeName,
          path: JobDetailsWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Détails du travail'),
        ),
        // PR-2: Redirect to real earnings widget
        FFRoute(
          name: EarningsWidget.routeName,
          path: EarningsWidget.routePath,
          builder: (context, params) => EarningsRealWidget(),
        ),
        // PR-2: Redirect to client notifications widget
        FFRoute(
          name: NotificationsProviderWidget.routeName,
          path: NotificationsProviderWidget.routePath,
          builder: (context, params) => NotificationsWidget(),
        ),
        // PR-2: Redirect to real transactions widget
        FFRoute(
          name: TransactionsProviderWidget.routeName,
          path: TransactionsProviderWidget.routePath,
          builder: (context, params) => TransactionsWidget(),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: TransactionDetailsWidget.routeName,
          path: TransactionDetailsWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Détails transaction'),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: UpdatePayoutAccountWidget.routeName,
          path: UpdatePayoutAccountWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Compte de versement'),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: ServicesWidget.routeName,
          path: ServicesWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Services'),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: RatingsWidget.routeName,
          path: RatingsWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Évaluations'),
        ),
        // PR-FIX-02: Redirect template route to Coming Soon
        FFRoute(
          name: AddNewServiceWidget.routeName,
          path: AddNewServiceWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Ajouter un service'),
        ),
        // PR-2: Redirect to client account widget
        FFRoute(
          name: ProfileWidget.routeName,
          path: ProfileWidget.routePath,
          builder: (context, params) => AccountWidget(),
        ),
        // PR-2: Redirect to client edit profile widget
        FFRoute(
          name: EditProviderProfileWidget.routeName,
          path: EditProviderProfileWidget.routePath,
          builder: (context, params) => EditProfileWidget(),
        ),
        // PR-FIX-02: ComingSoon for template routes
        FFRoute(
          name: AvailabilityWidget.routeName,
          path: AvailabilityWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Disponibilités'),
        ),
        FFRoute(
          name: PricingPlansWidget.routeName,
          path: PricingPlansWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Plans tarifaires'),
        ),
        FFRoute(
          name: MySubscriptionWidget.routeName,
          path: MySubscriptionWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Mon abonnement'),
        ),
        // PR-2: Redirect to real notification settings widget
        FFRoute(
          name: NotificationSettingsProviderWidget.routeName,
          path: NotificationSettingsProviderWidget.routePath,
          builder: (context, params) => NotificationSettingsRealWidget(),
        ),
        // PR-FIX-02: ComingSoon for template route
        FFRoute(
          name: ServiceAreaWidget.routeName,
          path: ServiceAreaWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Zone de service'),
        ),
        // PR-2: Redirect to client terms of service widget
        FFRoute(
          name: TermsOfServiceProviderWidget.routeName,
          path: TermsOfServiceProviderWidget.routePath,
          builder: (context, params) => TermsOfServiceWidget(),
        ),
        // PR-2: Redirect to client privacy policy widget
        FFRoute(
          name: PrivacyPolicyProviderWidget.routeName,
          path: PrivacyPolicyProviderWidget.routePath,
          builder: (context, params) => PrivacyPolicyWidget(),
        ),
        // PR-2: Redirect to client help center widget
        FFRoute(
          name: HelpCenterProvidersWidget.routeName,
          path: HelpCenterProvidersWidget.routePath,
          builder: (context, params) => HelpCenterWidget(),
        ),
        // PR-2: Redirect to client customer support widget
        FFRoute(
          name: CustomerSupportProviderWidget.routeName,
          path: CustomerSupportProviderWidget.routePath,
          builder: (context, params) => CustomerSupportWidget(),
        ),
        // PR-FIX-02: ComingSoon for template routes
        FFRoute(
          name: ShareExperienceWidget.routeName,
          path: ShareExperienceWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Partager l\'expérience'),
        ),
        // PR-FIX-03: Client public profile -> real user profile
        FFRoute(
          name: ClientPublicProfileWidget.routeName,
          path: ClientPublicProfileWidget.routePath,
          builder: (context, params) => UserPublicProfileWidget(
            userId: params.getParam('userId', ParamType.String) ?? '',
          ),
        ),
        FFRoute(
          name: AddInformationWidget.routeName,
          path: AddInformationWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Ajouter des informations'),
        ),
        FFRoute(
          name: SelectServicesWidget.routeName,
          path: SelectServicesWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Sélectionner des services'),
        ),
        FFRoute(
          name: SetDateAndAddressWidget.routeName,
          path: SetDateAndAddressWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Date et adresse'),
        ),
        FFRoute(
          name: ChoosePaymentMethodWidget.routeName,
          path: ChoosePaymentMethodWidget.routePath,
          builder: (context, params) => const ComingSoonScreen(featureName: 'Mode de paiement'),
        ),
        // PR-F05b: Mission detail route
        FFRoute(
          name: MissionDetailWidget.routeName,
          path: MissionDetailWidget.routePath,
          builder: (context, params) {
            // Try to get mission from extra, fallback to fetching by ID
            final extra = params.state.extra as Map<String, dynamic>?;
            final mission = extra?['mission'];
            return MissionDetailWidget(
              missionId: params.getParam(
                'missionId',
                ParamType.String,
              ) ?? '',
              mission: mission,
            );
          },
        ),
        // PR-F11: Saved missions route
        FFRoute(
          name: SavedMissionsPage.routeName,
          path: SavedMissionsPage.routePath,
          builder: (context, params) => SavedMissionsPage(),
        ),
        // PR-DISCOVERY: Swipe discovery route
        FFRoute(
          name: SwipeDiscoveryPage.routeName,
          path: SwipeDiscoveryPage.routePath,
          builder: (context, params) => const SwipeDiscoveryPage(),
        ),
        // PR-DISCOVERY: Map discovery route
        FFRoute(
          name: MapDiscoveryPage.routeName,
          path: MapDiscoveryPage.routePath,
          builder: (context, params) => const MapDiscoveryPage(),
        ),
        // PR-F16: My applications route
        FFRoute(
          name: MyApplicationsWidget.routeName,
          path: MyApplicationsWidget.routePath,
          builder: (context, params) => MyApplicationsWidget(),
        ),
        // PR-BOOKING: Worker assignments route ("My Bookings" for workers)
        FFRoute(
          name: WorkerAssignmentsWidget.routeName,
          path: WorkerAssignmentsWidget.routePath,
          builder: (context, params) => WorkerAssignmentsWidget(),
        ),
        // PR-01: Employer missions route
        FFRoute(
          name: EmployerMissionsWidget.routeName,
          path: EmployerMissionsWidget.routePath,
          builder: (context, params) => EmployerMissionsWidget(),
        ),
        // PR-02: Mission applications route
        FFRoute(
          name: MissionApplicationsWidget.routeName,
          path: MissionApplicationsWidget.routePath,
          builder: (context, params) {
            final missionId = params.getParam('missionId', ParamType.String) ?? '';
            final extra = params.state.extraMap;
            final missionTitle = extra['missionTitle'] as String?;
            return MissionApplicationsWidget(
              missionId: missionId,
              missionTitle: missionTitle,
            );
          },
        ),
        // PR-06: Transactions history route
        FFRoute(
          name: TransactionsWidget.routeName,
          path: TransactionsWidget.routePath,
          builder: (context, params) => TransactionsWidget(),
        ),
        // PR-07: Provider Jobs (real data)
        FFRoute(
          name: JobsRealWidget.routeName,
          path: JobsRealWidget.routePath,
          builder: (context, params) {
            final initialTab = params.getParam('initialTab', ParamType.int) ?? 0;
            return JobsRealWidget(initialTab: initialTab);
          },
        ),
        // PR-07: Provider Earnings (real data)
        FFRoute(
          name: EarningsRealWidget.routeName,
          path: EarningsRealWidget.routePath,
          builder: (context, params) => EarningsRealWidget(),
        ),
        // PR-08: Notification settings with persistence
        FFRoute(
          name: NotificationSettingsRealWidget.routeName,
          path: NotificationSettingsRealWidget.routePath,
          builder: (context, params) => NotificationSettingsRealWidget(),
        ),
        // PR-09: Search results with backend query + filters
        FFRoute(
          name: SearchResultsRealWidget.routeName,
          path: SearchResultsRealWidget.routePath,
          builder: (context, params) {
            final initialQuery = params.getParam('query', ParamType.String);
            final category = params.getParam('category', ParamType.String);
            return SearchResultsRealWidget(
              initialQuery: initialQuery,
              category: category,
            );
          },
        ),
        // ─────────────────────────────────────────────────────────────────────
        // PR-21: Deep Link Routes
        // ─────────────────────────────────────────────────────────────────────
        
        // Deep link: workon://mission/{missionId}
        FFRoute(
          name: MissionDeepLinkHandler.routeName,
          path: MissionDeepLinkHandler.routePath,
          builder: (context, params) {
            final missionId = params.getParam('missionId', ParamType.String) ?? '';
            // Save any attribution params
            _saveAttributionFromParams(params);
            return MissionDeepLinkHandler(missionId: missionId);
          },
        ),
        // Deep link: workon://profile/{userId}
        FFRoute(
          name: ProfileDeepLinkHandler.routeName,
          path: ProfileDeepLinkHandler.routePath,
          builder: (context, params) {
            final userId = params.getParam('userId', ParamType.String) ?? '';
            // Save any attribution params
            _saveAttributionFromParams(params);
            return ProfileDeepLinkHandler(userId: userId);
          },
        ),
        // Deep link: workon://invite?ref=...&utm_source=...
        FFRoute(
          name: InviteDeepLinkHandler.routeName,
          path: InviteDeepLinkHandler.routePath,
          builder: (context, params) {
            return InviteDeepLinkHandler(
              referralCode: params.getParam('ref', ParamType.String),
              utmSource: params.getParam('utm_source', ParamType.String),
              utmCampaign: params.getParam('utm_campaign', ParamType.String),
              utmMedium: params.getParam('utm_medium', ParamType.String),
            );
          },
        ),
        // PR-FIX-03: User public profile (direct route)
        FFRoute(
          name: UserPublicProfileWidget.routeName,
          path: UserPublicProfileWidget.routePath,
          builder: (context, params) => UserPublicProfileWidget(
            userId: params.getParam('userId', ParamType.String) ?? '',
            userName: params.getParam('userName', ParamType.String),
            userAvatar: params.getParam('userAvatar', ParamType.String),
          ),
        ),
        // Deep link error page
        FFRoute(
          name: DeepLinkErrorWidget.routeName,
          path: DeepLinkErrorWidget.routePath,
          builder: (context, params) => const DeepLinkErrorWidget(),
        ),
        // ─────────────────────────────────────────────────────────────────────
        // FL-SPRINT2-3: New Features Routes
        // ─────────────────────────────────────────────────────────────────────
        
        // Support Tickets
        FFRoute(
          name: SupportTicketsWidget.routeName,
          path: SupportTicketsWidget.routePath,
          builder: (context, params) => const SupportTicketsWidget(),
        ),
        // Notification Settings (API-connected)
        FFRoute(
          name: 'NotificationSettingsAPI',
          path: '/notificationSettingsAPI',
          builder: (context, params) => const notif_settings.NotificationSettingsWidget(),
        ),
        // Stripe Connect (Worker onboarding)
        FFRoute(
          name: StripeConnectWidget.routeName,
          path: StripeConnectWidget.routePath,
          builder: (context, params) => const StripeConnectWidget(),
        ),
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

/// PR-21: Helper to save attribution from route params.
void _saveAttributionFromParams(FFParameters params) {
  final utmSource = params.getParam('utm_source', ParamType.String);
  final utmMedium = params.getParam('utm_medium', ParamType.String);
  final utmCampaign = params.getParam('utm_campaign', ParamType.String);
  final ref = params.getParam('ref', ParamType.String);
  
  if (utmSource != null || utmCampaign != null || ref != null) {
    DeepLinkService.saveAttribution(Attribution(
      utmSource: utmSource,
      utmMedium: utmMedium,
      utmCampaign: utmCampaign,
      referralCode: ref,
      timestamp: DateTime.now(),
    ));
  }
}

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
