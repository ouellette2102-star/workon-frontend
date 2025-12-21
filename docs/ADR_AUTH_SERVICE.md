# ADR: Authentication Service Architecture

**Status:** Accepted  
**Date:** 2025-12-19  
**PR:** #3

---

## Context

WorkOn requires user authentication to access personalized features (bookings, profiles, messaging). We need a clean, testable authentication layer that:

1. Works independently of the backend during development
2. Can be incrementally connected to the real API
3. Provides type-safe error handling
4. Keeps authentication logic out of UI widgets

---

## Decision

### 1. Service Layer Pattern

We implement authentication as a static service (`AuthService`) with:

- **Pure methods**: No side effects beyond session state
- **Typed models**: `AuthUser`, `AuthTokens`, `AuthSession`
- **Typed exceptions**: `InvalidCredentialsException`, etc.

```
lib/services/auth/
├── auth_service.dart    # Main service with login/register/logout
├── auth_models.dart     # Data classes with JSON serialization
└── auth_errors.dart     # Typed exception hierarchy
```

### 2. Mock-First Implementation

For PR#3, all methods return **deterministic mock data**:

```dart
static Future<AuthUser> login({...}) async {
  await Future.delayed(Duration(milliseconds: 300)); // Simulate latency
  return AuthUser(id: 'mock_001', email: email, ...);
}
```

**Benefits:**
- App remains stable even if backend is unavailable
- UI development can proceed in parallel
- Easy to test edge cases
- Clear TODO markers for real API integration

### 3. Progressive API Integration (PR#4)

Each method includes a TODO comment showing exact API call:

```dart
/// TODO(PR#4): Replace mock with real API call:
/// ```dart
/// final response = await ApiClient.post('/auth/login', body: {...});
/// return AuthSession.fromJson(response.body);
/// ```
```

This ensures:
- Single responsibility per PR
- Minimal diff when switching to real API
- Easy rollback if backend issues arise

---

## Consequences

### Positive

- **Safe incremental delivery**: Each PR is self-contained
- **Testable**: Mock data enables unit testing without network
- **Type-safe**: Compiler catches model mismatches
- **Clear upgrade path**: TODO markers guide future work

### Negative

- **Temporary duplication**: Mock logic will be removed in PR#4
- **No real validation**: Backend-specific rules (password strength) not enforced yet

### Mitigations

- Mock data matches expected backend response structure
- Error types align with planned API error codes
- Session state matches production flow

---

## File Structure

```
lib/
└── services/
    ├── api/
    │   └── api_client.dart      # PR#2 - HTTP layer
    └── auth/
        ├── auth_service.dart    # PR#3 - Service facade
        ├── auth_repository.dart # PR#4 - Repository abstraction
        ├── auth_models.dart     # PR#3 - Data classes
        └── auth_errors.dart     # PR#3 - Typed exceptions
```

---

## PR#4 Update: Repository Pattern & Wiring

**Date:** 2025-12-21  
**Status:** Implemented

### What Changed

1. **Introduced `AuthRepository` abstraction** (`auth_repository.dart`)
   - Abstract interface defining `login`, `register`, `me`, `logout`
   - Enables dependency injection and easy implementation swapping

2. **Created `MockAuthRepository`**
   - Implements `AuthRepository` with deterministic mock data
   - Accepts `ApiClient` parameter for interface compatibility (not used yet)
   - No network calls made

3. **Refactored `AuthService`**
   - Now delegates to `AuthRepository` instead of inline mock logic
   - Added `initialize()` method for dependency injection
   - Added `currentTokens` getter alongside existing getters
   - Added `restoreSession()` for future token persistence

### Why Mock Repository First

```
┌─────────────────┐     ┌──────────────────────┐
│   AuthService   │────▶│   AuthRepository     │ (interface)
│   (facade)      │     └──────────────────────┘
└─────────────────┘              ▲
                                 │
              ┌──────────────────┴──────────────────┐
              │                                     │
    ┌─────────────────────┐           ┌─────────────────────┐
    │ MockAuthRepository  │           │ RealAuthRepository  │
    │ (PR#4 - current)    │           │ (PR#5 - future)     │
    └─────────────────────┘           └─────────────────────┘
              │                                     │
              ▼                                     ▼
        [In-memory]                          [ApiClient]
```

**Benefits:**
- UI development unblocked (no backend dependency)
- Same interface for mock and real implementations
- Single line change to switch: `AuthService.initialize(repository: RealAuthRepository(...))`
- Easy to test with mock, easy to deploy with real

### Migration Path to PR#5

```dart
// Current (PR#4):
AuthService.initialize();  // Uses MockAuthRepository by default

// Future (PR#5):
AuthService.initialize(
  repository: RealAuthRepository(apiClient: ApiClient),
);
```

The `RealAuthRepository` will:
1. Use `ApiClient.buildUri()` for endpoint URLs
2. Use `ApiClient.defaultHeaders` for auth headers
3. Parse responses using existing `AuthSession.fromJson()`
4. Throw existing typed exceptions based on HTTP status codes

---

---

## PR#5 Update: Real API Integration

**Date:** 2025-12-21  
**Status:** Implemented

### What Changed

1. **Created `RealAuthRepository`** (`real_auth_repository.dart`)
   - Implements `AuthRepository` with real HTTP calls
   - Connects to Railway backend via `ApiClient`
   - Endpoints: `POST /auth/login`, `POST /auth/register`, `GET /auth/me`, `POST /auth/logout`

2. **Switched Default Repository**
   - `AuthService` now defaults to `RealAuthRepository`
   - Added `useMockRepository()` method for testing
   - `MockAuthRepository` preserved for offline development

3. **Error Handling**
   - HTTP 401 → `InvalidCredentialsException`
   - HTTP 409 → `EmailAlreadyInUseException`
   - HTTP 5xx / Network errors → `AuthNetworkException`

### Architecture (PR#5)

```
┌─────────────────┐     ┌──────────────────────┐
│   AuthService   │────▶│   AuthRepository     │ (interface)
│   (facade)      │     └──────────────────────┘
└─────────────────┘              ▲
                                 │
              ┌──────────────────┴──────────────────┐
              │                                     │
    ┌─────────────────────┐           ┌─────────────────────┐
    │ MockAuthRepository  │           │ RealAuthRepository  │
    │ (testing)           │           │ (PR#5 ✅ DEFAULT)   │
    └─────────────────────┘           └─────────────────────┘
              │                                     │
              ▼                                     ▼
        [In-memory]                          [ApiClient]
                                                   │
                                                   ▼
                                        [Railway Backend]
```

### Limitations (Intentional for PR#5)

- **No token refresh**: Tokens expire, user must re-login
- **No persistence**: Tokens in-memory only (lost on app restart)
- **No interceptors**: No automatic auth header injection
- **No SecureStorage**: Tokens not encrypted on device

### Usage

```dart
// Production (default - PR#5):
// RealAuthRepository is used automatically

// Testing:
AuthService.useMockRepository();

// Manual switch:
AuthService.initialize(repository: MockAuthRepository());
```

---

## PR#6 Update: Auth Bootstrap & Session Check

**Date:** 2025-12-21  
**Status:** Implemented

### What Changed

1. **Created `AuthBootstrap`** (`auth_bootstrap.dart`)
   - Lightweight session checking at app startup
   - `checkSession()`: Validates current session with backend
   - `initialize()`: Convenience method for app startup
   - Never throws exceptions - returns `false` on any error

2. **Added `hasValidSession()` to AuthService**
   - Checks if current session is valid
   - Validates token with `/auth/me` endpoint
   - Returns `true`/`false` without throwing
   - Quick local checks before network call

### Bootstrap Flow

```
┌─────────────────────────────────────────────────────────────┐
│                      App Startup                            │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │  AuthBootstrap.checkSession() │
              └───────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │  Session exists locally?      │
              └───────────────────────────────┘
                     │              │
                    No             Yes
                     │              │
                     ▼              ▼
              ┌──────────┐  ┌─────────────────┐
              │  false   │  │ Validate w/ API │
              └──────────┘  └─────────────────┘
                                    │
                           ┌────────┴────────┐
                          OK              Error
                           │                │
                           ▼                ▼
                    ┌──────────┐     ┌──────────┐
                    │   true   │     │  false   │
                    └──────────┘     └──────────┘
```

### Usage

```dart
// In main.dart (app startup)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final isLoggedIn = await AuthBootstrap.checkSession();
  
  runApp(MyApp(isAuthenticated: isLoggedIn));
}

// Or use hasValidSession directly
if (await AuthService.hasValidSession()) {
  // Navigate to home
} else {
  // Navigate to login
}
```

### Guarantees

- **No exceptions bubble up**: All errors return `false`
- **No logging noise**: Silent failure
- **MockAuthRepository compatible**: Works with both real and mock
- **Existing logic untouched**: login/register/logout unchanged

---

## PR#7 Update: Auth State Exposure

**Date:** 2025-12-21  
**Status:** Implemented

### What Changed

1. **Created `AuthState` model** (`auth_state.dart`)
   - `AuthStatus` enum: `unknown`, `authenticated`, `unauthenticated`
   - `AuthState` class with `status`, `userId`, `email`
   - Convenience constructors: `.unknown()`, `.authenticated()`, `.unauthenticated()`
   - Immutable with `copyWith` support

2. **Added reactive state to `AuthService`**
   - `ValueNotifier<AuthState> _state` for reactive updates
   - `stateListenable` getter for listening to changes
   - `state` getter for current value
   - `setAuthState()` method for updates
   - `refreshAuthState()` method to validate and update state

3. **Integrated state updates**
   - `login()` → sets authenticated with user info
   - `register()` → sets authenticated with user info
   - `logout()` → sets unauthenticated
   - `reset()` / `useMockRepository()` / `resetRepository()` → sets unknown

4. **Updated `AuthBootstrap`**
   - `checkSession()` now updates auth state via `refreshAuthState()`
   - Quick path: no session → set unauthenticated immediately

### State Flow

```
┌─────────────────────────────────────────────────────────────┐
│                      App Startup                            │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
                   AuthState = unknown
                              │
                              ▼
              ┌───────────────────────────────┐
              │  AuthBootstrap.checkSession() │
              └───────────────────────────────┘
                              │
               ┌──────────────┴──────────────┐
              Yes                           No
               │                             │
               ▼                             ▼
    ┌─────────────────────┐       ┌─────────────────────┐
    │ refreshAuthState()  │       │  unauthenticated    │
    └─────────────────────┘       └─────────────────────┘
               │
      ┌────────┴────────┐
    Valid            Invalid
      │                  │
      ▼                  ▼
┌─────────────┐   ┌─────────────────┐
│ authenticated│   │ unauthenticated │
└─────────────┘   └─────────────────┘
```

### Usage

```dart
// Listen to auth state changes (reactive)
AuthService.stateListenable.addListener(() {
  final state = AuthService.state;
  switch (state.status) {
    case AuthStatus.authenticated:
      // Navigate to home
      break;
    case AuthStatus.unauthenticated:
      // Navigate to login
      break;
    case AuthStatus.unknown:
      // Show loading
      break;
  }
});

// Check current state (one-time)
if (AuthService.state.isAuthenticated) {
  print('Logged in as ${AuthService.state.email}');
}

// Manually refresh state
final isValid = await AuthService.refreshAuthState();
```

### Key Design Decisions

1. **ValueNotifier over StreamController**: Simpler, built-in to Flutter, no subscription management
2. **Centralized state in AuthService**: UI must not manage auth decisions directly
3. **Auth state is managed in AuthService**: UI routing will be wired in a future PR
4. **Never throws from refreshAuthState**: All errors result in unauthenticated state

---

## PR#8 Update: App Startup State Orchestration

**Date:** 2025-12-21  
**Status:** Implemented

### What Changed

1. **Created `AppBootState` model** (`app_boot_state.dart`)
   - `AppBootStatus` enum: `loading`, `authenticated`, `unauthenticated`
   - `AppBootState` class with `status`, `userId`, `email`
   - Convenience constructors: `.loading()`, `.authenticated()`, `.unauthenticated()`
   - Immutable with `copyWith` support

2. **Created `AppStartupController`** (`app_startup_controller.dart`)
   - Orchestrates app boot process
   - `ValueNotifier<AppBootState>` for reactive boot state
   - `bootStateListenable` getter for listening to changes
   - `bootState` getter for current value
   - `initialize()` method to start boot sequence
   - `dispose()` method for cleanup
   - Subscribes to `AuthService.stateListenable` for ongoing updates

### Architecture (PR#8)

```
┌─────────────────────────────────────────────────────────────┐
│                      App Startup                            │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │   AppStartupController        │
              │   (orchestration layer)       │
              └───────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │   AppBootState = loading      │
              └───────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │   AuthBootstrap.initialize()  │
              └───────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │   Subscribe to AuthState      │
              └───────────────────────────────┘
                              │
           ┌──────────────────┴──────────────────┐
           │                                     │
           ▼                                     ▼
┌─────────────────────┐           ┌─────────────────────┐
│    authenticated    │           │   unauthenticated   │
└─────────────────────┘           └─────────────────────┘
```

### State Mapping

| AuthState.status   | → | AppBootState.status |
|--------------------|---|---------------------|
| `unknown`          | → | `loading` (briefly) → `unauthenticated` |
| `authenticated`    | → | `authenticated`     |
| `unauthenticated`  | → | `unauthenticated`   |

### Usage

```dart
// In main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final controller = AppStartupController();
  await controller.initialize();
  
  runApp(MyApp(bootController: controller));
}

// In app widget
controller.bootStateListenable.addListener(() {
  final state = controller.bootState;
  switch (state.status) {
    case AppBootStatus.loading:
      // Show splash screen
      break;
    case AppBootStatus.authenticated:
      // Navigate to home
      break;
    case AppBootStatus.unauthenticated:
      // Navigate to login
      break;
  }
});

// Cleanup
controller.dispose();
```

### Key Design Decisions

1. **Separate from AuthService**: Keeps boot orchestration independent
2. **Single source of truth**: One place to check app boot status
3. **Listens to AuthState**: Automatically reflects login/logout changes
4. **Never throws**: All errors result in unauthenticated state
5. **Disposable**: Proper cleanup of listeners and notifiers

### Guarantees

- **MockAuthRepository compatible**: Works with both real and mock
- **No UI changes**: Pure service layer addition
- **Backward compatible**: AuthService API unchanged

---

## PR#10 Update: User Context & Role Resolution

**Date:** 2025-12-21  
**Status:** Implemented

### What Changed

1. **Created `UserContext` model** (`lib/services/user/user_context.dart`)
   - `UserRole` enum: `worker`, `employer`, `residential`
   - `UserContextStatus` enum: `unknown`, `loading`, `ready`
   - `UserContext` class with `status`, `userId`, `email`, `role`
   - Convenience constructors: `.unknown()`, `.loading()`, `.fromAuth()`
   - Immutable with `copyWith` support

2. **Created `UserService`** (`lib/services/user/user_service.dart`)
   - Manages user context via `ValueNotifier<UserContext>`
   - `contextListenable` getter for reactive updates
   - `context` getter for current value
   - `setFromAuth()` method to set context after authentication
   - `reset()` method to clear context on logout
   - Role resolution defaults to `UserRole.worker` (safe placeholder)

3. **Wired into `AuthService`**
   - `login()` → calls `UserService.setFromAuth()`
   - `register()` → calls `UserService.setFromAuth()`
   - `logout()` → calls `UserService.reset()`
   - `reset()` / `resetRepository()` / `useMockRepository()` → calls `UserService.reset()`

### Architecture (PR#10)

```
┌─────────────────────────────────────────────────────────────┐
│                      Authentication                         │
└─────────────────────────────────────────────────────────────┘
                              │
            ┌─────────────────┴─────────────────┐
            │                                   │
            ▼                                   ▼
┌─────────────────────┐           ┌─────────────────────┐
│    AuthService      │──────────▶│    UserService      │
│    (auth state)     │           │    (user context)   │
└─────────────────────┘           └─────────────────────┘
            │                                   │
            ▼                                   ▼
┌─────────────────────┐           ┌─────────────────────┐
│    AuthState        │           │    UserContext      │
│ - status            │           │ - status            │
│ - userId            │           │ - userId            │
│ - email             │           │ - email             │
└─────────────────────┘           │ - role (worker)     │
                                  └─────────────────────┘
```

### Role Resolution

Current implementation uses a safe default:

```dart
static Future<UserRole> _resolveRole(String userId) async {
  // Safe default: all users are workers until role system is implemented
  return UserRole.worker;
}
```

Future PRs can implement actual role fetching from backend without changing the interface.

### Usage

```dart
// Listen for user context changes
UserService.contextListenable.addListener(() {
  final ctx = UserService.context;
  if (ctx.isReady) {
    print('User: ${ctx.email}, Role: ${ctx.role}');
  }
});

// After login/register, context is automatically set
await AuthService.login(email: 'user@example.com', password: 'pass');
// UserService.context.role == UserRole.worker

// After logout, context is automatically reset
await AuthService.logout();
// UserService.context.isUnknown == true
```

### Guarantees

- **MockAuthRepository compatible**: Works with both real and mock
- **No new API calls**: Role defaults to worker (no backend dependency)
- **No UI changes**: Pure service layer addition
- **Never throws**: Falls back to default role on any error

---

## PR#11 Update: Session Access Layer

**Date:** 2025-12-21  
**Status:** Implemented

### What Changed

1. **Created `AppSession` model** (`lib/services/auth/app_session.dart`)
   - `AppSession` class with `hasSession` and optional `token`
   - Convenience constructors: `.none()`, `.fromToken()`, `.authenticated()`
   - Immutable with `copyWith` support

2. **Added to `AuthService`**
   - `ValueNotifier<AppSession> _session` for reactive session updates
   - `sessionListenable` getter for listening to changes
   - `session` getter for current value
   - `hasSession` convenience getter

3. **Wired into auth lifecycle**
   - `login()` → sets `AppSession.fromToken(accessToken)`
   - `register()` → sets `AppSession.fromToken(accessToken)`
   - `logout()` → sets `AppSession.none()`
   - `reset()` / `resetRepository()` / `useMockRepository()` → sets `AppSession.none()`

### Architecture (PR#11)

```
┌─────────────────────────────────────────────────────────────┐
│                      AuthService                            │
└─────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐
│   AuthState     │   │   AppSession    │   │  UserContext    │
│   (PR#7)        │   │   (PR#11)       │   │  (PR#10)        │
├─────────────────┤   ├─────────────────┤   ├─────────────────┤
│ - status        │   │ - hasSession    │   │ - role          │
│ - userId        │   │ - token         │   │ - userId        │
│ - email         │   │                 │   │ - email         │
└─────────────────┘   └─────────────────┘   └─────────────────┘
```

### Usage

```dart
// Check if session exists (quick check)
if (AuthService.hasSession) {
  print('User is logged in');
}

// Access token if available
final token = AuthService.session.token;
if (token != null) {
  // Use token for authenticated API calls
}

// Listen for session changes (reactive)
AuthService.sessionListenable.addListener(() {
  final session = AuthService.session;
  if (session.hasSession) {
    // User logged in
  } else {
    // User logged out
  }
});
```

### Guarantees

- **MockAuthRepository compatible**: Works with mock token
- **No new API calls**: Uses existing token from login/register
- **No SecureStorage**: Token only in-memory
- **No UI changes**: Pure service layer addition

---

## PR#12 Update: Role Resolution via Backend Profile

**Date:** 2025-12-21  
**Status:** Implemented

### What Changed

1. **Created `UserApi`** (`lib/services/user/user_api.dart`)
   - Minimal API client for user profile endpoints
   - `fetchMe()` method calls `GET /auth/me` with Bearer token
   - Uses existing `ApiClient` infrastructure
   - Throws `UserApiException` on errors

2. **Updated `UserService`** (`lib/services/user/user_service.dart`)
   - Added `refreshFromBackendIfPossible()` method
   - Parses role from profile response (fields: `role`, `userRole`, `accountType`)
   - Maps to `UserRole` enum: worker, employer, residential
   - Falls back gracefully on any error (keeps current role)

3. **Updated `AuthService`**
   - After `login()` and `register()`, calls `UserService.refreshFromBackendIfPossible()`
   - Fire-and-forget: does not block auth flow

### Architecture (PR#12)

```
┌─────────────────────────────────────────────────────────────┐
│                      Login/Register                         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │   1. Auth completes           │
              │   2. setFromAuth(role=worker) │
              │   3. setSession(token)        │
              └───────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │   refreshFromBackendIfPossible │
              │   (async, non-blocking)        │
              └───────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │   GET /auth/me                │
              │   Authorization: Bearer token  │
              └───────────────────────────────┘
                              │
               ┌──────────────┴──────────────┐
            Success                       Failure
               │                             │
               ▼                             ▼
    ┌─────────────────────┐       ┌─────────────────────┐
    │ Update role from    │       │ Keep default role   │
    │ response            │       │ (worker)            │
    └─────────────────────┘       └─────────────────────┘
```

### Role Mapping

| Backend Value    | UserRole           |
|------------------|-------------------|
| `"worker"`       | `UserRole.worker` |
| `"employer"`     | `UserRole.employer` |
| `"residential"`  | `UserRole.residential` |
| unknown/missing  | keep current role |

### Usage

```dart
// Role is automatically enriched after login
await AuthService.login(email: 'user@example.com', password: 'pass');

// Check role (may be enriched asynchronously)
final role = UserService.context.role;

// Listen for role updates
UserService.contextListenable.addListener(() {
  final ctx = UserService.context;
  print('Role: ${ctx.role}');
});

// Manual refresh (if needed)
await UserService.refreshFromBackendIfPossible();
```

### Fallback Strategy

1. **No session**: Skip fetch, keep current context
2. **No token**: Skip fetch, role remains default (worker)
3. **Network error**: Keep current role
4. **Invalid response**: Keep current role
5. **Unknown role value**: Keep current role

### Guarantees

- **MockAuthRepository compatible**: Falls back safely
- **Non-blocking**: Does not slow down auth flow
- **No SecureStorage**: Uses in-memory token only
- **No new dependencies**: Uses existing http client
- **No UI changes**: Pure service layer addition

---

## PR#13 Update: Real Auth Integration with Logging

**Date:** 2025-12-21  
**Status:** Implemented

### What Changed

1. **Enhanced `RealAuthRepository`**
   - Added `debugPrint` logging for all HTTP operations
   - Improved error handling with `TimeoutException` catches
   - Better HTTP status code handling (401, 403, 500+)
   - Logs request URLs and response status codes

2. **Enhanced `UserApi`**
   - Added `debugPrint` logging for profile fetch
   - Improved error handling with specific status code checks
   - Catches and logs timeout and network errors

3. **Enhanced `UserService`**
   - Added `debugPrint` logging for role resolution flow
   - Logs when session/token is missing
   - Logs resolved role from backend

### Error Handling Strategy

```
┌─────────────────────────────────────────────────────────────┐
│                      HTTP Request                           │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │   Status Code Check           │
              └───────────────────────────────┘
                              │
        ┌──────────┬──────────┼──────────┬──────────┐
        │          │          │          │          │
        ▼          ▼          ▼          ▼          ▼
    200/201      401        403        500+      Timeout
        │          │          │          │          │
        ▼          ▼          ▼          ▼          ▼
    ┌───────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐
    │Success│ │Unauth'd │ │Forbidden│ │Server   │ │Network  │
    │       │ │Exception│ │Exception│ │Error    │ │Exception│
    └───────┘ └─────────┘ └─────────┘ └─────────┘ └─────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │   debugPrint log              │
              │   (for debugging only)        │
              └───────────────────────────────┘
```

### Logging Format

All logs use consistent prefixes for filtering:

```
[RealAuthRepository] POST /api/v1/auth/login
[RealAuthRepository] login response: 200
[UserApi] GET /api/v1/auth/me
[UserApi] fetchMe response: 200
[UserService] refreshFromBackendIfPossible: resolved role = UserRole.worker
```

### Guarantees

- **No throws to UI**: All errors are caught and logged
- **Graceful fallbacks**: App works even if backend is down
- **MockAuthRepository compatible**: Still works for testing
- **No new dependencies**: Uses Flutter's built-in `debugPrint`

---

## Future Work

| PR | Scope |
|----|-------|
| ~~PR#4~~ | ~~Connect AuthService to ApiClient with real endpoints~~ ✅ Wiring done |
| ~~PR#5~~ | ~~Implement RealAuthRepository with actual API calls~~ ✅ Done |
| ~~PR#6~~ | ~~Auth bootstrap & session check~~ ✅ Done |
| ~~PR#7~~ | ~~Auth state exposure~~ ✅ Done |
| ~~PR#8~~ | ~~App startup state orchestration~~ ✅ Done |
| ~~PR#10~~ | ~~User context & role resolution~~ ✅ Done |
| ~~PR#11~~ | ~~Session access layer~~ ✅ Done |
| ~~PR#12~~ | ~~Role resolution via backend~~ ✅ Done |
| ~~PR#13~~ | ~~Real auth integration with logging~~ ✅ Done |
| PR#14 | Add token refresh logic |
| PR#15 | Persist session to secure storage |

---

## References

- [PR#1] `lib/config/app_config.dart` — API base URL configuration
- [PR#2] `lib/services/api/api_client.dart` — HTTP client layer
- [docs/DELEGATION_RULES.md] — Change category guidelines

