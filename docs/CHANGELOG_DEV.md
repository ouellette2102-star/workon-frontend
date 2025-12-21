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
