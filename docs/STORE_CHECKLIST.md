# WorkOn - App Store / Play Store Release Checklist

> **PR-F8** - Checklist de release pour les stores.

## 📱 Statut Global: ✅ RELEASE-READY (v1.1.0)

---

## 1. Assets & Branding

| Item | Android | iOS | Status |
|------|---------|-----|--------|
| App Icon | mipmap-*dpi | AppIcon.appiconset | ✅ |
| Splash Screen | drawable/launch_background | LaunchScreen | ✅ |
| App Name | "WorkOn" | "WorkOn" | ✅ |
| Package/Bundle ID | com.workon.workon | com.workon.workon | ✅ |

---

## 2. Versioning

| Item | Valeur | Status |
|------|--------|--------|
| Version | 1.1.0 | ✅ |
| Build Number | 2 | ✅ |
| Min SDK Android | API 21 | ✅ |
| Min iOS | iOS 12+ | ✅ |

---

## 3. Permissions Déclarées

### Android (AndroidManifest.xml)
- [x] INTERNET
- [x] CAMERA
- [x] ACCESS_FINE_LOCATION
- [x] ACCESS_COARSE_LOCATION
- [x] READ_EXTERNAL_STORAGE (maxSdkVersion=32)
- [x] WRITE_EXTERNAL_STORAGE (maxSdkVersion=32)

### iOS (Info.plist)
- [x] NSCameraUsageDescription ✅
- [x] NSPhotoLibraryUsageDescription ✅
- [x] NSLocationWhenInUseUsageDescription ✅ (FR)

---

## 4. Configuration Production

| Item | Valeur | Status |
|------|--------|--------|
| API URL Prod | workon-backend-production.up.railway.app | ✅ |
| Stripe Key | Configurable via --dart-define | ✅ |
| Google Maps | Configurable via --dart-define | ✅ |
| Firebase/FCM | google-services.json via CI secret | ✅ |

---

## 5. Features de Release

| Feature | Status | Notes |
|---------|--------|-------|
| Maintenance Mode | ✅ | Kill-switch via remote config |
| Forced Update | ✅ | Version check + store redirect |
| Auth Disable | ✅ | Kill-switch |
| Payments Disable | ✅ | Kill-switch |
| Crash Reporting | ✅ | CrashReportingService ready |
| Error Boundaries | ✅ | AppErrorWidget + ErrorBoundary |

---

## 6. Legal & Compliance

| Item | Status | Notes |
|------|--------|-------|
| Terms of Service | ✅ | Backend versions + consent tracking |
| Privacy Policy | ✅ | Backend versions + consent tracking |
| Consent Gate | ✅ | ConsentStore + sync backend |
| GDPR Consent | ✅ | Via compliance API |

---

## 7. Build Commands

### Debug
```bash
flutter run
```

### Release APK
```bash
flutter build apk --release \
  --dart-define=APP_ENV=prod \
  --dart-define=STRIPE_PUBLISHABLE_KEY=pk_live_xxx \
  --dart-define=GOOGLE_MAPS_API_KEY=xxx
```

### Release AAB (Play Store)
```bash
flutter build appbundle --release \
  --dart-define=APP_ENV=prod \
  --dart-define=STRIPE_PUBLISHABLE_KEY=pk_live_xxx \
  --dart-define=GOOGLE_MAPS_API_KEY=xxx
```

### iOS Release
```bash
flutter build ios --release \
  --dart-define=APP_ENV=prod \
  --dart-define=STRIPE_PUBLISHABLE_KEY=pk_live_xxx \
  --dart-define=GOOGLE_MAPS_API_KEY=xxx
```

---

## 8. Pre-Release Checklist

### Code
- [x] CI verte (Flutter analyze + build)
- [x] Tests passent (widget_test.dart)
- [x] Pas d'erreurs bloquantes
- [x] Version incrémentée

### Backend
- [x] Backend déployé sur Railway
- [x] Variables d'environnement configurées
- [x] Base de données migrée
- [x] SSL/HTTPS actif

### Stores
- [ ] Screenshots (6.5" + 5.5" pour iOS)
- [ ] Description app (FR)
- [ ] Privacy Policy URL
- [ ] Terms of Service URL
- [ ] App Icon haute résolution (512x512)
- [ ] Feature graphic (Play Store)

---

## 9. Post-Release

- [ ] Monitoring crash reports
- [ ] Vérifier analytics
- [ ] Cleanup tech debt (voir TECH_DEBT.md)
- [ ] Tester forced update
- [ ] Tester maintenance mode

---

## 10. Contacts & Credentials

| Service | Status |
|---------|--------|
| Google Play Console | À configurer |
| App Store Connect | À configurer |
| Firebase Console | ✅ workonv1 |
| Railway | ✅ workon-backend-production |
| Stripe | ✅ Test mode |

---

*Dernière mise à jour: 2026-01-18*
*Version: 1.1.0+2*

