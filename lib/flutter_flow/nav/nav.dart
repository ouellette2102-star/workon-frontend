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
import '/client_part/saved/saved_missions_page.dart';

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
        FFRoute(
          name: VideoCallWidget.routeName,
          path: VideoCallWidget.routePath,
          builder: (context, params) => VideoCallWidget(),
        ),
        FFRoute(
          name: AllReviewsWidget.routeName,
          path: AllReviewsWidget.routePath,
          builder: (context, params) => AllReviewsWidget(),
        ),
        FFRoute(
          name: ChatWidget.routeName,
          path: ChatWidget.routePath,
          builder: (context, params) => ChatWidget(),
        ),
        FFRoute(
          name: MessagesWidget.routeName,
          path: MessagesWidget.routePath,
          builder: (context, params) => MessagesWidget(),
        ),
        FFRoute(
          name: VoiceCallWidget.routeName,
          path: VoiceCallWidget.routePath,
          builder: (context, params) => VoiceCallWidget(),
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
        FFRoute(
          name: SingleCategoryWidget.routeName,
          path: SingleCategoryWidget.routePath,
          builder: (context, params) => SingleCategoryWidget(),
        ),
        FFRoute(
          name: SearchWidget.routeName,
          path: SearchWidget.routePath,
          builder: (context, params) => SearchWidget(),
        ),
        FFRoute(
          name: SearchResultsWidget.routeName,
          path: SearchResultsWidget.routePath,
          builder: (context, params) => SearchResultsWidget(),
        ),
        FFRoute(
          name: ServiceDetailsWidget.routeName,
          path: ServiceDetailsWidget.routePath,
          builder: (context, params) => ServiceDetailsWidget(),
        ),
        FFRoute(
          name: ReportServiceWidget.routeName,
          path: ReportServiceWidget.routePath,
          builder: (context, params) => ReportServiceWidget(),
        ),
        FFRoute(
          name: ProviderPublicProfileWidget.routeName,
          path: ProviderPublicProfileWidget.routePath,
          builder: (context, params) => ProviderPublicProfileWidget(),
        ),
        FFRoute(
          name: BookingsWidget.routeName,
          path: BookingsWidget.routePath,
          builder: (context, params) => BookingsWidget(),
        ),
        FFRoute(
          name: BookingDetailsWidget.routeName,
          path: BookingDetailsWidget.routePath,
          builder: (context, params) => BookingDetailsWidget(),
        ),
        FFRoute(
          name: RescheduleBookingWidget.routeName,
          path: RescheduleBookingWidget.routePath,
          builder: (context, params) => RescheduleBookingWidget(),
        ),
        FFRoute(
          name: CancelBookingWidget.routeName,
          path: CancelBookingWidget.routePath,
          builder: (context, params) => CancelBookingWidget(),
        ),
        FFRoute(
          name: LeaveReviewWidget.routeName,
          path: LeaveReviewWidget.routePath,
          builder: (context, params) => LeaveReviewWidget(),
        ),
        FFRoute(
          name: BookAgainWidget.routeName,
          path: BookAgainWidget.routePath,
          builder: (context, params) => BookAgainWidget(),
        ),
        FFRoute(
          name: BookmarksWidget.routeName,
          path: BookmarksWidget.routePath,
          builder: (context, params) => BookmarksWidget(),
        ),
        FFRoute(
          name: ReviewSummaryWidget.routeName,
          path: ReviewSummaryWidget.routePath,
          builder: (context, params) => ReviewSummaryWidget(),
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
        FFRoute(
          name: ProviderRegistrationWidget.routeName,
          path: ProviderRegistrationWidget.routePath,
          builder: (context, params) => ProviderRegistrationWidget(),
        ),
        FFRoute(
          name: HomeProviderWidget.routeName,
          path: HomeProviderWidget.routePath,
          builder: (context, params) => HomeProviderWidget(),
        ),
        FFRoute(
          name: JobRequestsWidget.routeName,
          path: JobRequestsWidget.routePath,
          builder: (context, params) => JobRequestsWidget(
            initialTab: params.getParam(
              'initialTab',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: MessagesProviderWidget.routeName,
          path: MessagesProviderWidget.routePath,
          builder: (context, params) => MessagesProviderWidget(),
        ),
        FFRoute(
          name: JobsWidget.routeName,
          path: JobsWidget.routePath,
          builder: (context, params) => JobsWidget(
            initialTab: params.getParam(
              'initialTab',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: RequestDetailsWidget.routeName,
          path: RequestDetailsWidget.routePath,
          builder: (context, params) => RequestDetailsWidget(),
        ),
        FFRoute(
          name: JobDetailsWidget.routeName,
          path: JobDetailsWidget.routePath,
          builder: (context, params) => JobDetailsWidget(),
        ),
        FFRoute(
          name: EarningsWidget.routeName,
          path: EarningsWidget.routePath,
          builder: (context, params) => EarningsWidget(),
        ),
        FFRoute(
          name: NotificationsProviderWidget.routeName,
          path: NotificationsProviderWidget.routePath,
          builder: (context, params) => NotificationsProviderWidget(),
        ),
        FFRoute(
          name: TransactionsProviderWidget.routeName,
          path: TransactionsProviderWidget.routePath,
          builder: (context, params) => TransactionsProviderWidget(),
        ),
        FFRoute(
          name: TransactionDetailsWidget.routeName,
          path: TransactionDetailsWidget.routePath,
          builder: (context, params) => TransactionDetailsWidget(),
        ),
        FFRoute(
          name: UpdatePayoutAccountWidget.routeName,
          path: UpdatePayoutAccountWidget.routePath,
          builder: (context, params) => UpdatePayoutAccountWidget(),
        ),
        FFRoute(
          name: ServicesWidget.routeName,
          path: ServicesWidget.routePath,
          builder: (context, params) => ServicesWidget(),
        ),
        FFRoute(
          name: RatingsWidget.routeName,
          path: RatingsWidget.routePath,
          builder: (context, params) => RatingsWidget(),
        ),
        FFRoute(
          name: AddNewServiceWidget.routeName,
          path: AddNewServiceWidget.routePath,
          builder: (context, params) => AddNewServiceWidget(),
        ),
        FFRoute(
          name: ProfileWidget.routeName,
          path: ProfileWidget.routePath,
          builder: (context, params) => ProfileWidget(),
        ),
        FFRoute(
          name: EditProviderProfileWidget.routeName,
          path: EditProviderProfileWidget.routePath,
          builder: (context, params) => EditProviderProfileWidget(),
        ),
        FFRoute(
          name: AvailabilityWidget.routeName,
          path: AvailabilityWidget.routePath,
          builder: (context, params) => AvailabilityWidget(),
        ),
        FFRoute(
          name: PricingPlansWidget.routeName,
          path: PricingPlansWidget.routePath,
          builder: (context, params) => PricingPlansWidget(),
        ),
        FFRoute(
          name: MySubscriptionWidget.routeName,
          path: MySubscriptionWidget.routePath,
          builder: (context, params) => MySubscriptionWidget(),
        ),
        FFRoute(
          name: NotificationSettingsProviderWidget.routeName,
          path: NotificationSettingsProviderWidget.routePath,
          builder: (context, params) => NotificationSettingsProviderWidget(),
        ),
        FFRoute(
          name: ServiceAreaWidget.routeName,
          path: ServiceAreaWidget.routePath,
          builder: (context, params) => ServiceAreaWidget(),
        ),
        FFRoute(
          name: TermsOfServiceProviderWidget.routeName,
          path: TermsOfServiceProviderWidget.routePath,
          builder: (context, params) => TermsOfServiceProviderWidget(),
        ),
        FFRoute(
          name: PrivacyPolicyProviderWidget.routeName,
          path: PrivacyPolicyProviderWidget.routePath,
          builder: (context, params) => PrivacyPolicyProviderWidget(),
        ),
        FFRoute(
          name: HelpCenterProvidersWidget.routeName,
          path: HelpCenterProvidersWidget.routePath,
          builder: (context, params) => HelpCenterProvidersWidget(),
        ),
        FFRoute(
          name: CustomerSupportProviderWidget.routeName,
          path: CustomerSupportProviderWidget.routePath,
          builder: (context, params) => CustomerSupportProviderWidget(),
        ),
        FFRoute(
          name: ShareExperienceWidget.routeName,
          path: ShareExperienceWidget.routePath,
          builder: (context, params) => ShareExperienceWidget(),
        ),
        FFRoute(
          name: ClientPublicProfileWidget.routeName,
          path: ClientPublicProfileWidget.routePath,
          builder: (context, params) => ClientPublicProfileWidget(),
        ),
        FFRoute(
          name: AddInformationWidget.routeName,
          path: AddInformationWidget.routePath,
          builder: (context, params) => AddInformationWidget(),
        ),
        FFRoute(
          name: SelectServicesWidget.routeName,
          path: SelectServicesWidget.routePath,
          builder: (context, params) => SelectServicesWidget(),
        ),
        FFRoute(
          name: SetDateAndAddressWidget.routeName,
          path: SetDateAndAddressWidget.routePath,
          builder: (context, params) => SetDateAndAddressWidget(),
        ),
        FFRoute(
          name: ChoosePaymentMethodWidget.routeName,
          path: ChoosePaymentMethodWidget.routePath,
          builder: (context, params) => ChoosePaymentMethodWidget(),
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
        // PR-F16: My applications route
        FFRoute(
          name: MyApplicationsWidget.routeName,
          path: MyApplicationsWidget.routePath,
          builder: (context, params) => MyApplicationsWidget(),
        ),
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

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
