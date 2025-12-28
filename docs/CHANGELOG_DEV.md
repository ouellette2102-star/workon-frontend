# Development Changelog — WorkOn Frontend

Running log of all PRs and changes for audit and rollback purposes.

---

## Format

```
## [PR#X] Title — YYYY-MM-DD
**Risk Level:** 🟢 Auto-safe | 🟡 Semi-safe | 🔴 High
**Files Changed:**
- path/to/file.dart (created|updated|deleted)
**Summary:** Brief description of change
**Rollback:** Command or steps to undo
```

---

## Changelog

---

## [PR-F05b] Map + Cards + Mission Detail — 2024-12-28

**Risk Level:** 🟢 Auto-safe (LOW)

**Files Changed:**
- `lib/client_part/mission_detail/mission_detail_model.dart` (created)
- `lib/client_part/mission_detail/mission_detail_widget.dart` (created)
- `lib/client_part/home/home_model.dart` (updated)
- `lib/client_part/home/home_widget.dart` (updated)
- `lib/flutter_flow/nav/nav.dart` (updated)
- `lib/index.dart` (updated)
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Added read-only MissionDetail page and horizontal cards view for missions. Users can now toggle between List and Cards view in the missions feed section. Tapping a mission navigates to a detailed view showing title, description, location, price, and status.

**Key Features:**
- **MissionDetailWidget**: Read-only detail page with header card, description, location info
- **List/Cards Toggle**: Switch between vertical list and horizontal swipable cards
- **Navigation**: `context.pushNamed(MissionDetailWidget.routeName, ...)` with mission data
- **Colorful Cards**: Gradient backgrounds cycling through indigo/emerald/amber/pink/blue

**Manual Test Flow:**
1. Login → Home → see "Missions à proximité" section
2. Toggle between List (📋) and Cards (🃏) views
3. Tap any mission → opens MissionDetail page
4. Verify mission info displays correctly
5. Press back → returns to Home

**Rollback:**
```bash
git rm -r lib/client_part/mission_detail/
git checkout HEAD~1 -- lib/client_part/home/home_model.dart lib/client_part/home/home_widget.dart lib/flutter_flow/nav/nav.dart lib/index.dart docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR-F05b"
```

---

## [PR-F04] Token Persistence (SecureStorage) — 2024-12-26

**Risk Level:** 🟢 Auto-safe (LOW)

**Files Changed:**
- `lib/services/auth/token_storage.dart` (created)
- `lib/services/auth/auth_service.dart` (updated)
- `lib/services/auth/auth_bootstrap.dart` (updated)
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Added token persistence using SharedPreferences. Tokens now survive app restarts. Created `TokenStorage` service with `getToken()`, `setToken()`, `clearToken()`, `saveTokens()` methods. Added `tryRestoreSession()` to `AuthService` for automatic session restore at startup. Updated `AuthBootstrap` to call `tryRestoreSession()`. Updated login/register to persist tokens. Updated logout/reset to clear tokens.

**Key Features:**
- **Token persistence**: AccessToken, RefreshToken, and Expiry stored in SharedPreferences
- **In-memory cache**: Fast sync access to tokens after initialization
- **Auto-restore**: `AuthBootstrap.initialize()` now restores session from storage
- **Backend validation**: Restored tokens are validated with `/auth/me` before use
- **Graceful fallback**: Invalid/expired stored tokens are cleared automatically

**API:**
```dart
// Initialize at startup (done by AuthBootstrap)
await TokenStorage.initialize();

// Save tokens (done automatically by AuthService.login/register)
await TokenStorage.saveTokens(accessToken: 'jwt', refreshToken: '...', expiresAt: DateTime);

// Get token (sync, uses cache)
final token = TokenStorage.getToken();

// Clear tokens (done automatically by AuthService.logout)
await TokenStorage.clearToken();
```

**Manual Test Flow:**
1. Login with valid credentials → tokens persisted
2. Close app completely (kill process)
3. Reopen app → session restored, user lands in Home
4. Logout → tokens cleared
5. Reopen app → user lands in Login (no session)

**Rollback:**
```bash
git rm lib/services/auth/token_storage.dart
git checkout HEAD~1 -- lib/services/auth/auth_service.dart lib/services/auth/auth_bootstrap.dart docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR-F04 token persistence"
```

---

## [PR#14] Minimal Auth UI Wiring — 2025-12-21

**Risk Level:** 🟡 Semi-safe (MEDIUM)

**Files Changed:**
- `lib/client_part/sign_in/sign_in_widget.dart` (updated)
- `lib/client_part/sign_in/sign_in_model.dart` (updated)
- `lib/client_part/sign_up/sign_up_widget.dart` (updated)
- `lib/client_part/sign_up/sign_up_model.dart` (updated)
- `lib/client_part/profile_pages/settings/settings_widget.dart` (updated)
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Wired existing Login and Register UI screens to real AuthService methods. Added loading states, error handling with SnackBar messages (French), and graceful fallbacks. Added logout button to Settings screen. On success, AuthGate automatically redirects authenticated users to Home. App still boots if backend is unreachable (shows friendly error on submit).

**UI Changes:**
- **Login (SignIn)**: Calls `AuthService.login()`, shows loading state, displays error messages
- **Register (SignUp)**: Calls `AuthService.register()`, shows loading state, displays error messages
- **Settings**: Added "Déconnexion" button that calls `AuthService.logout()`

**Error Messages (French):**
- 401/Invalid credentials → "Identifiants invalides"
- Email already in use → "Cet email est déjà utilisé"
- Network/timeout → "Connexion impossible. Réessaie."
- Other errors → "Erreur de connexion" / "Erreur lors de l'inscription"

**Manual Test Flow:**
1. Launch app → unauthenticated → onboarding/login screen
2. Login with invalid creds → error SnackBar shown
3. Login with valid creds → user lands in Home via AuthGate
4. Navigate to Settings → tap "Déconnexion" → returns to unauthenticated flow
5. Backend down → app launches, friendly error on submit

**Rollback:**
```bash
git checkout HEAD~1 -- lib/client_part/sign_in/sign_in_widget.dart lib/client_part/sign_in/sign_in_model.dart lib/client_part/sign_up/sign_up_widget.dart lib/client_part/sign_up/sign_up_model.dart lib/client_part/profile_pages/settings/settings_widget.dart docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR#14 auth UI wiring"
```

---

## [PR#13] Real Auth Integration — 2025-12-21

**Risk Level:** 🟢 Auto-safe (LOW)

**Files Changed:**
- `lib/services/auth/real_auth_repository.dart` (updated)
- `lib/services/user/user_api.dart` (updated)
- `lib/services/user/user_service.dart` (updated)
- `docs/ADR_AUTH_SERVICE.md` (updated)
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Improved real authentication integration with comprehensive error handling and logging. Added `debugPrint` logging to `RealAuthRepository`, `UserApi`, and `UserService` for error tracing. Enhanced error handling with proper `TimeoutException` catches, 401/403/500 status code handling, and graceful fallbacks. App boots even if backend is unreachable. MockAuthRepository still works. No UI changes. No SecureStorage.

**Endpoints Used:**
- `POST /api/v1/auth/login`
- `POST /api/v1/auth/register`
- `GET /api/v1/auth/me`
- `POST /api/v1/auth/logout`

**Error Handling:**
- 401/403 → Unauthorized (do NOT throw to UI)
- 500+ → Server error (graceful fallback)
- Timeout → Network exception (logged, graceful fallback)
- All errors logged via `debugPrint`

**Rollback:**
```bash
git checkout HEAD~1 -- lib/services/auth/real_auth_repository.dart lib/services/user/user_api.dart lib/services/user/user_service.dart docs/ADR_AUTH_SERVICE.md docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR#13 real auth integration"
```

---

## [PR#12] Role Resolution via Backend — 2025-12-21

**Risk Level:** 🟢 Auto-safe (LOW)

**Files Changed:**
- `lib/services/user/user_api.dart` (created)
- `lib/services/user/user_service.dart` (updated)
- `lib/services/auth/auth_service.dart` (updated)
- `docs/ADR_AUTH_SERVICE.md` (updated)
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Added backend role resolution. Created `UserApi` client for `GET /auth/me` endpoint. Added `refreshFromBackendIfPossible()` to `UserService` that fetches profile and extracts role. Wired into `AuthService`: after login/register, role is enriched asynchronously (fire-and-forget). Falls back to default role (worker) on any error. MockAuthRepository compatible. No UI changes. No SecureStorage.

**Rollback:**
```bash
git rm lib/services/user/user_api.dart
git checkout HEAD~1 -- lib/services/user/user_service.dart lib/services/auth/auth_service.dart docs/ADR_AUTH_SERVICE.md docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR#12 role resolution"
```

---

## [PR#11] Session Access Layer — 2025-12-21

**Risk Level:** 🟢 Auto-safe (LOW)

**Files Changed:**
- `lib/services/auth/app_session.dart` (created)
- `lib/services/auth/auth_service.dart` (updated)
- `docs/ADR_AUTH_SERVICE.md` (updated)
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Added minimal session access layer. Created `AppSession` model with `hasSession` flag and optional `token`. Added `ValueNotifier<AppSession>` to `AuthService` with `sessionListenable` and `hasSession` getters. Wired into auth lifecycle: login/register sets session with token, logout/reset clears session. MockAuthRepository remains compatible. No UI changes. No SecureStorage.

**Rollback:**
```bash
git rm lib/services/auth/app_session.dart
git checkout HEAD~1 -- lib/services/auth/auth_service.dart docs/ADR_AUTH_SERVICE.md docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR#11 session access layer"
```

---

## [PR#10] User Context & Role Resolution — 2025-12-21

**Risk Level:** 🟢 Auto-safe (LOW)

**Files Changed:**
- `lib/services/user/user_context.dart` (created)
- `lib/services/user/user_service.dart` (created)
- `lib/services/auth/auth_service.dart` (updated)
- `docs/ADR_AUTH_SERVICE.md` (updated)
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Added centralized user context with role resolution. Created `UserContext` model with `UserRole` enum (worker, employer, residential) and `UserContextStatus` enum (unknown, loading, ready). Created `UserService` to manage user context via `ValueNotifier`. Wired into `AuthService`: login/register sets context, logout/reset clears it. Role defaults to `worker` (safe placeholder, no new API calls). MockAuthRepository remains compatible. No UI changes.

**Rollback:**
```bash
git rm -r lib/services/user/
git checkout HEAD~1 -- lib/services/auth/auth_service.dart docs/ADR_AUTH_SERVICE.md docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR#10 user context"
```

---

## [PR#9] UI Auth Gate — 2025-12-21

**Risk Level:** 🟡 Semi-safe (MEDIUM)

**Files Changed:**
- `lib/app/auth_gate.dart` (created)
- `lib/flutter_flow/nav/nav.dart` (updated)
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Wired UI to AppBootState for startup routing. Created `AuthGate` widget that listens to `AppStartupController` and conditionally renders: loading screen (spinner), `OnboardingWidget` (leads to login) when unauthenticated, or `HomeWidget` when authenticated. Modified initial route "/" to use `AuthGate` after splash. No auth logic changes. MockAuthRepository still works.

**Behavior:**
- App shows splash screen (1s)
- Then AuthGate shows loading while checking session
- If authenticated → Home
- If not → Onboarding (login flow)

**Rollback:**
```bash
git rm lib/app/auth_gate.dart
git checkout HEAD~1 -- lib/flutter_flow/nav/nav.dart docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR#9 UI auth gate"
```

---

## [PR#8] App Startup State Orchestration — 2025-12-21

**Risk Level:** 🟢 Auto-safe (LOW)

**Files Changed:**
- `lib/services/auth/app_boot_state.dart` (created)
- `lib/services/auth/app_startup_controller.dart` (created)
- `docs/ADR_AUTH_SERVICE.md` (updated)
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Added app startup orchestration layer. Created `AppBootState` model with `AppBootStatus` enum (loading, authenticated, unauthenticated). Created `AppStartupController` class that coordinates boot process and listens to `AuthService.stateListenable`. Provides single source of truth for app boot status. No UI changes. MockAuthRepository remains compatible.

**Rollback:**
```bash
git rm lib/services/auth/app_boot_state.dart lib/services/auth/app_startup_controller.dart
git checkout HEAD~1 -- docs/ADR_AUTH_SERVICE.md docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR#8 app startup state"
```

---

## [PR#7] Auth State Exposure — 2025-12-21

**Risk Level:** 🟢 Auto-safe (LOW)

**Files Changed:**
- `lib/services/auth/auth_state.dart` (created)
- `lib/services/auth/auth_service.dart` (updated)
- `lib/services/auth/auth_bootstrap.dart` (updated)
- `docs/ADR_AUTH_SERVICE.md` (updated)
- `docs/CHANGELOG_DEV.md` (updated)
- `docs/DELEGATION_RULES.md` (updated)

**Summary:**  
Added centralized auth state management. Created `AuthState` model with `AuthStatus` enum (unknown, authenticated, unauthenticated). Added `ValueNotifier<AuthState>` to `AuthService` with reactive `stateListenable`. State updates automatically on login/register/logout. Added `refreshAuthState()` method. Updated `AuthBootstrap` to sync state. No UI changes. MockAuthRepository remains compatible.

**Rollback:**
```bash
git rm lib/services/auth/auth_state.dart
git checkout HEAD~1 -- lib/services/auth/auth_service.dart lib/services/auth/auth_bootstrap.dart docs/ADR_AUTH_SERVICE.md docs/CHANGELOG_DEV.md docs/DELEGATION_RULES.md
git commit -m "Rollback: PR#7 auth state exposure"
```

---

## [PR#6] Auth Bootstrap & Session Check — 2025-12-21

**Risk Level:** 🟢 Auto-safe (LOW)

**Files Changed:**
- `lib/services/auth/auth_bootstrap.dart` (created)
- `lib/services/auth/auth_service.dart` (updated)
- `docs/ADR_AUTH_SERVICE.md` (updated)
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Added lightweight auth bootstrap for app startup. Created `AuthBootstrap.checkSession()` to validate sessions with backend. Added `AuthService.hasValidSession()` helper method. All errors return `false` - no exceptions bubble up. MockAuthRepository remains compatible. No UI changes.

**Rollback:**
```bash
git rm lib/services/auth/auth_bootstrap.dart
git checkout HEAD~1 -- lib/services/auth/auth_service.dart docs/ADR_AUTH_SERVICE.md docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR#6 auth bootstrap"
```

---

## [PR#5] Real Auth API Integration — 2025-12-21

**Risk Level:** 🟡 Semi-safe (MEDIUM)

**Files Changed:**
- `lib/services/auth/real_auth_repository.dart` (created)
- `lib/services/auth/auth_service.dart` (updated)
- `docs/ADR_AUTH_SERVICE.md` (updated)
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Implemented real authentication API calls to Railway backend. Created `RealAuthRepository` with login, register, me, and logout endpoints. Switched `AuthService` default from mock to real repository. Added `useMockRepository()` for testing. Tokens remain in-memory only (no persistence). No UI changes.

**Endpoints Used:**
- `POST /auth/login`
- `POST /auth/register`
- `GET /auth/me`
- `POST /auth/logout`

**Rollback:**
```bash
git rm lib/services/auth/real_auth_repository.dart
git checkout HEAD~1 -- lib/services/auth/auth_service.dart docs/ADR_AUTH_SERVICE.md docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR#5 real auth API"
```

---

## [PR#4] Auth Wiring (Repository Pattern) — 2025-12-21

**Risk Level:** 🟢 Auto-safe (LOW)

**Files Changed:**
- `lib/services/auth/auth_repository.dart` (created)
- `lib/services/auth/auth_service.dart` (updated)
- `docs/ADR_AUTH_SERVICE.md` (updated)

**Summary:**  
Introduced repository pattern for authentication layer. Created `AuthRepository` interface and `MockAuthRepository` implementation. Refactored `AuthService` to delegate to repository with dependency injection support. Added `currentTokens` getter and `restoreSession()` method. No network calls made - still mock only. ApiClient wired but not called (reserved for PR#5).

**Rollback:**
```bash
git rm lib/services/auth/auth_repository.dart
git checkout HEAD~1 -- lib/services/auth/auth_service.dart docs/ADR_AUTH_SERVICE.md
git commit -m "Rollback: PR#4 auth wiring"
```

---

## [PR#3] Auth Service (Mock Implementation) — 2025-12-19

**Risk Level:** 🟢 Auto-safe (LOW)

**Files Changed:**
- `lib/services/auth/auth_service.dart` (created)
- `lib/services/auth/auth_models.dart` (created)
- `lib/services/auth/auth_errors.dart` (created)
- `docs/ADR_AUTH_SERVICE.md` (created)

**Summary:**  
Created authentication service layer with typed models and exceptions. Implements login, register, me, and logout methods with deterministic mock data. No real API calls made. TODO markers included for PR#4 API integration. Safe to merge regardless of backend status.

**Rollback:**
```bash
git rm lib/services/auth/auth_service.dart lib/services/auth/auth_models.dart lib/services/auth/auth_errors.dart docs/ADR_AUTH_SERVICE.md
git commit -m "Rollback: PR#3 auth service"
```

---

## [PR#2] API Client + Delegation Framework — 2025-12-19

**Risk Level:** 🟢 Auto-safe (LOW)

**Files Changed:**
- `lib/services/api/api_client.dart` (created)
- `docs/DELEGATION_RULES.md` (created)
- `docs/PR_CHECKLIST.md` (created)
- `docs/CHANGELOG_DEV.md` (created)

**Summary:**  
Created minimal API client structure using the existing `http` package. Configured with `AppConfig.activeApiUrl` as base URL, timeout settings, and prepared headers structure. Also established delegation framework with guardrails for safe Cursor AI changes.

**Rollback:**
```bash
git rm lib/services/api/api_client.dart docs/DELEGATION_RULES.md docs/PR_CHECKLIST.md
git commit -m "Rollback: PR#2 API client and delegation framework"
```

---

## [PR#1] Configuration Setup — 2025-12-19

**Risk Level:** 🟢 Auto-safe

**Files Changed:**
- `lib/config/app_config.dart` (created)
- `docs/config_decision.md` (created)

**Summary:**  
Created centralized configuration file with Railway backend URLs (production + development). Added ADR documenting the configuration architecture decision.

**Rollback:**
```bash
git rm lib/config/app_config.dart docs/config_decision.md
git commit -m "Rollback: PR#1 configuration setup"
```

---

<!-- Add new entries above this line -->
