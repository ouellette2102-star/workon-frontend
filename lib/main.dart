import 'dart:async';

import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import '/config/app_config.dart';
import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';
import '/services/analytics/analytics_service.dart';
import '/services/auth/auth_bootstrap.dart';
import '/services/auth/auth_service.dart';
import '/services/auth/token_refresh_interceptor.dart';
import '/services/errors/crash_reporting_service.dart';
import '/services/errors/error_handler.dart';
import '/services/legal/consent_gate.dart';
import '/services/legal/consent_store.dart';
import '/services/offers/offers_service.dart';
import '/services/push/push_service.dart';
import '/services/saved/saved_missions_store.dart';
import '/client_part/legal/legal_consent_gate.dart';

/// Global key for showing snackbars from anywhere.
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  // PR-ERROR: Initialize global error handlers
  ErrorHandler.initialize();

  // PR-G2: Validate environment configuration (safety guards)
  AppConfig.validateConfiguration();
  
  // PR-ERROR: Custom error widget for release builds (replaces red screen)
  if (!kDebugMode) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return const AppErrorWidget();
    };
  }

  await FlutterFlowTheme.initialize();

  // PR-14: Initialize localization (for locale persistence)
  await FFLocalizations.initialize();

  // PR-5: Initialize Stripe with publishable key
  if (AppConfig.hasStripeKey) {
    Stripe.publishableKey = AppConfig.stripePublishableKey;
    Stripe.merchantIdentifier = 'merchant.com.workon.app';
    debugPrint('[Stripe] Initialized with publishable key');
  } else {
    debugPrint('[Stripe] ⚠️ No publishable key configured');
  }

  // PR-F11: Initialize saved missions store
  await SavedMissionsStore.initialize();

  // PR-F15: Initialize offers service (applied missions store)
  await OffersService.initialize();

  // PR-F20: Initialize push service
  await PushService.initialize();

  // PR-V1-01: Initialize consent store
  await ConsentStore.initialize();

  // PR-F17: Set up token refresh interceptor callbacks
  TokenRefreshInterceptor.setLogoutCallback(() async {
    await AuthService.logout();
  });
  TokenRefreshInterceptor.setSessionExpiredCallback(() {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(WkCopy.sessionExpired),
        backgroundColor: WkStatusColors.cancelled,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  });

  // PR-23: Load saved attribution for analytics
  await AnalyticsService.loadAttribution();

  // PR-BOOT: Uber-grade cold-start bootstrap (before runApp)
  // - Attempts silent refresh if tokens exist
  // - Clears tokens only on auth error (401/403)
  // - Keeps tokens on network error (user can retry later)
  final bootstrapResult = await AuthBootstrap.bootstrapAuth();
  debugPrint('[main] Bootstrap result: $bootstrapResult');

  // PR-23: Track app open
  AnalyticsService.trackAppOpen();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  // PR-24: Wrap runApp in runZonedGuarded for async error catching
  _runAppWithErrorBoundary(appState);
}

/// PR-24: Runs the app with a global error zone.
///
/// Catches async errors not caught by Flutter framework.
void _runAppWithErrorBoundary(FFAppState appState) {
  // Use runZonedGuarded to catch all async errors
  runZonedGuarded(
    () {
      // PR-G2: Wrap with environment badge overlay
      runApp(EnvBadge(
        child: ChangeNotifierProvider(
          create: (context) => appState,
          child: MyApp(),
        ),
      ));
    },
    (error, stackTrace) {
      // PR-24: Handle uncaught async errors
      debugPrint('[main] Uncaught async error: $error');
      debugPrint('[main] Stack: $stackTrace');

      // Record to crash reporting (with sanitization)
      CrashReportingService.handleZoneError(error, stackTrace);
    },
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  // PR-14: Default to French, or restored from storage
  Locale? _locale;

  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  bool displaySplashImage = true;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    // PR-14: Restore persisted locale (default to French if none)
    _restoreLocale();

    // PR-F20: Set up push service navigator key after router is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PushService.setNavigatorKey(_router.routerDelegate.navigatorKey);
      
      // PR-V1-01: Register consent modal callback for API interceptor
      ConsentGate.setShowModalCallback(() async {
        final context = _router.routerDelegate.navigatorKey.currentContext;
        if (context == null) return false;
        return await LegalConsentModal.show(context);
      });
    });

    Future.delayed(Duration(milliseconds: 1000),
        () => safeSetState(() => _appStateNotifier.stopShowingSplashImage()));
  }

  // PR-14: Restore locale from storage, default to French
  void _restoreLocale() {
    final storedLocale = FFLocalizations.getStoredLocale();
    if (storedLocale != null) {
      _locale = storedLocale;
      debugPrint('[i18n] Restored locale: ${storedLocale.languageCode}');
    } else {
      // Default to French
      _locale = const Locale('fr');
      debugPrint('[i18n] Default locale: fr');
    }
  }

  // PR-14: Set and persist locale
  void setLocale(String language) {
    safeSetState(() => _locale = createLocale(language));
    // Persist for next app launch
    FFLocalizations.storeLocale(language);
    debugPrint('[i18n] Locale changed and persisted: $language');
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: rootScaffoldMessengerKey, // PR-F17
      debugShowCheckedModeBanner: false,
      title: 'WorkOn',
      localizationsDelegates: [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
        Locale('hi'),
        Locale('ar'),
        Locale('pt'),
        Locale('fr'),
        Locale('ru'),
        Locale('de'),
        Locale('ja'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}
