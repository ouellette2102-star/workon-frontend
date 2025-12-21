# Delegation Rules — WorkOn Frontend

This document defines guardrails for safe, incremental changes via Cursor AI or manual PRs.

---

## Change Categories

### 🟢 Auto-safe (No human review required)

Changes that cannot break the app if implemented correctly.

| Area | Examples |
|------|----------|
| **Documentation** | `docs/*.md`, `README.md`, inline comments |
| **Configuration files** | `lib/config/*.dart` (new constants, URLs) |
| **New standalone utilities** | `lib/utils/*.dart` (pure functions, no side effects) |
| **Asset additions** | `assets/images/*`, `assets/fonts/*` (add only) |
| **Linting/formatting** | `.editorconfig`, `analysis_options.yaml` tweaks |

**Criteria:**
- No import changes in existing widgets
- No runtime behavior change
- No dependency additions
- Easily reversible (delete file = rollback)

---

### 🟡 Semi-safe (Quick human review recommended)

Changes that are low-risk but touch existing code.

| Area | Examples |
|------|----------|
| **API service layer** | `lib/services/api_service.dart` (new methods) |
| **State additions** | New fields in `lib/app_state.dart` |
| **Theme extensions** | New colors/styles in `flutter_flow_theme.dart` |
| **Model additions** | `lib/backend/schema/structs/*.dart` (new structs) |
| **Localization** | New keys in `internationalization.dart` |

**Criteria:**
- Additive changes only (no deletions/renames)
- Must pass `flutter analyze` with 0 errors
- Requires manual test on one screen

---

### 🔴 Not Allowed (Requires explicit human request)

Changes that can break UI, navigation, or user experience.

| Area | Why restricted |
|------|----------------|
| **Widgets** | `lib/**/widget.dart` — UI regressions |
| **Routes/Navigation** | `lib/flutter_flow/nav/*.dart` — Broken flows |
| **Models** | `lib/**/*_model.dart` — State corruption |
| **pubspec.yaml** | Dependency conflicts, build failures |
| **Platform configs** | `android/`, `ios/`, `web/` — Build breaks |
| **main.dart** | App initialization issues |

**Exception:** Only allowed if the user explicitly requests the change with the specific file path.

---

## Scope Lock per PR

Each PR must declare its scope. Only files in the declared scope may be modified.

### PR#1 — Configuration Setup
```
ALLOWED:
  - lib/config/app_config.dart (create)
  - docs/config_decision.md (create)
```

### PR#2 — API Client + Delegation Framework
```
ALLOWED:
  - lib/services/api/api_client.dart (create)
  - docs/DELEGATION_RULES.md (create)
  - docs/PR_CHECKLIST.md (create)
  - docs/CHANGELOG_DEV.md (create)
```

### PR#3 — Auth Service (Mock Implementation)
```
ALLOWED:
  - lib/services/auth/auth_service.dart (create)
  - lib/services/auth/auth_models.dart (create)
  - lib/services/auth/auth_errors.dart (create)
  - docs/ADR_AUTH_SERVICE.md (create)
```

### PR#4 — Auth Wiring (Repository Pattern)
```
ALLOWED:
  - lib/services/auth/auth_repository.dart (create)
  - lib/services/auth/auth_service.dart (update)
  - docs/ADR_AUTH_SERVICE.md (update)
  - docs/CHANGELOG_DEV.md (update)
```

### PR#5 — Real Auth API Integration
```
ALLOWED:
  - lib/services/auth/real_auth_repository.dart (create)
  - lib/services/auth/auth_service.dart (update)
  - docs/ADR_AUTH_SERVICE.md (update)
  - docs/CHANGELOG_DEV.md (update)
  - docs/DELEGATION_RULES.md (update)
```

### PR#6 — Auth Bootstrap & Session Check
```
ALLOWED:
  - lib/services/auth/auth_bootstrap.dart (create)
  - lib/services/auth/auth_service.dart (update)
  - docs/ADR_AUTH_SERVICE.md (update)
  - docs/CHANGELOG_DEV.md (update)
  - docs/DELEGATION_RULES.md (update)
```

### PR#7 — Auth State Exposure
```
ALLOWED:
  - lib/services/auth/auth_state.dart (create)
  - lib/services/auth/auth_service.dart (update)
  - lib/services/auth/auth_bootstrap.dart (update)
  - docs/ADR_AUTH_SERVICE.md (update)
  - docs/CHANGELOG_DEV.md (update)
  - docs/DELEGATION_RULES.md (update)
NOT ALLOWED:
  - Any widget, route, or model file
  - pubspec.yaml
  - No UI/navigation changes
```

### Template for Future PRs
```
PR#N — [Title]
ALLOWED:
  - path/to/file1.dart (create|update)
  - path/to/file2.dart (create|update)
NOT ALLOWED:
  - Any widget, route, or model file
  - pubspec.yaml
```

---

## API Integration Rules (Flutter + Backend)

### ✅ Safe patterns

```dart
// Import from centralized config
import 'package:work_on_v1/config/app_config.dart';

// Use config for base URL
final url = '${AppConfig.apiUrl}/endpoint';

// New service in isolated file
class ApiService {
  static Future<Response> get(String endpoint) { ... }
}
```

### ❌ Forbidden patterns

```dart
// Hardcoded URLs in widgets
'https://api.example.com/users'  // ❌ Never in widget files

// Direct http calls in widgets
http.get(Uri.parse('...')); // ❌ Must go through service layer

// Modifying widget state for API
class _HomeWidgetState {
  Future fetchData() { ... } // ❌ Not allowed without explicit request
}

// Managing auth state in widgets (PR#7+)
class _MyWidgetState {
  bool isLoggedIn = false;  // ❌ Use AuthService.state instead
}
```

### 🔒 Auth State Rules (PR#7+)

- **Auth state is managed centrally in `AuthService`**
- UI must read state via `AuthService.state` or `AuthService.stateListenable`
- UI must NOT manage auth decisions directly
- Routing based on auth state will be implemented in a future PR for routing

---

## Rollback Protocol

| Severity | Action |
|----------|--------|
| **Auto-safe** | Delete the created file |
| **Semi-safe** | `git revert <commit>` or restore from CHANGELOG |
| **Breaking** | Immediate `git reset --hard` to last known good state |

---

## Enforcement

1. Every PR must reference this document
2. Cursor AI must check scope before making changes
3. Any violation = automatic rollback request

