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

## [PR-F20] Push Notifications (MVP) — 2024-12-30

**Risk Level:** 🟢 Auto-safe (disabled by default)

**Files Changed:**
- `lib/services/push/push_config.dart` (created) — Configuration + feature flag
- `lib/services/push/push_api.dart` (created) — Device registration API
- `lib/services/push/push_service.dart` (created) — Push service + handlers
- `lib/main.dart` (updated) — Initialize push service
- `lib/services/auth/auth_service.dart` (updated) — Register/unregister on login/logout
- `lib/config/ui_tokens.dart` (updated) — Push microcopy
- `docs/PUSH_NOTIFICATIONS_SETUP.md` (created) — Full setup documentation
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Implemented push notifications infrastructure ready for Firebase integration. The feature is disabled by default via `PushConfig.enabled = false` to ensure builds work without Firebase configuration. When enabled, devices are registered on login and unregistered on logout.

**Endpoints Required (Backend):**
- `POST /devices/register` — body: `{ token, platform }`
- `DELETE /devices/unregister` — body: `{ token }`

**Key Features:**
- **Feature flag:** `PushConfig.enabled` controls all push operations
- **Device registration:** Auto-registers FCM token after login
- **Unregistration:** Removes token on logout
- **Foreground handling:** Snackbar with "Voir" action
- **Background handling:** Navigation to chat on tap
- **Firebase-ready:** Code prepared, just needs uncomment + config files

**Security:**
- FCM tokens never logged
- UserId from JWT, not request body
- Graceful fallback if push not configured

**How to Enable:**
1. Add Firebase project + download google-services.json
2. Add firebase_messaging to pubspec.yaml
3. Set `PushConfig.enabled = true`
4. Uncomment Firebase code in PushService
5. Implement backend endpoints

**How to Test (current state):**
1. Login → no error (push disabled, NO-OP)
2. Logout → no error (push disabled, NO-OP)
3. dart analyze = 0
4. App builds and runs normally

**How to Test (when enabled):**
1. Login → token registered (check DB)
2. Send message → push received
3. Tap notification → opens chat
4. Foreground → snackbar appears
5. Logout → token unregistered

**Rollback:**
```bash
git rm -r lib/services/push
git rm docs/PUSH_NOTIFICATIONS_SETUP.md
git checkout HEAD~1 -- lib/main.dart lib/services/auth/auth_service.dart lib/config/ui_tokens.dart docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR-F20"
```

---

## [PR-F19] Basic Messaging — 2024-12-30

**Risk Level:** 🟡 Semi-safe

**Files Changed:**
- `lib/services/messages/message_models.dart` (created) — Conversation + Message models
- `lib/services/messages/messages_api.dart` (created) — HTTP client for conversations/messages
- `lib/services/messages/messages_service.dart` (created) — Service with polling support
- `lib/client_part/messages/messages_widget.dart` (updated) — Real conversations list
- `lib/client_part/chat/chat_widget.dart` (updated) — Real chat with send
- `lib/flutter_flow/nav/nav.dart` (updated) — Chat route params
- `lib/config/ui_tokens.dart` (updated) — Messaging microcopy
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Implemented basic messaging between Employer ↔ Worker using HTTP polling. Users can now view their conversations, read messages, and send new messages. Includes optimistic UI updates for sent messages and automatic polling for new messages.

**Endpoints Used:**
- `GET /conversations` — list user's conversations
- `GET /conversations/{id}/messages` — messages in a conversation
- `POST /conversations/{id}/messages` — send a message

**Key Features:**
- **Conversations list:** Real data with avatar/initials, last message, unread count
- **Chat screen:** Message bubbles (left/right), send input, timestamps
- **Optimistic send:** Message appears immediately, updates on success/failure
- **Polling:** Auto-refresh every 10s when chat is open
- **Pull-to-refresh:** Manual refresh on both screens
- **Error handling:** French messages, retry buttons
- **Empty states:** CTA to explore missions

**UX:**
- Scroll to bottom after send
- Loading/error/empty states
- Badge for unread count
- Sent/read indicators

**How to Test:**
1. Login → Messages (bottom nav)
2. Empty state if no conversations
3. Tap conversation → Chat opens
4. Send message → appears immediately
5. Pull to refresh → messages reload
6. Wait 10s → polling updates
7. Token expired → refresh auto → chat OK
8. Network error → retry button

**Rollback:**
```bash
git rm -r lib/services/messages
git checkout HEAD~1 -- lib/client_part/messages/messages_widget.dart lib/client_part/chat/chat_widget.dart lib/flutter_flow/nav/nav.dart lib/config/ui_tokens.dart docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR-F19"
```

---

## [PR-F18] Profile Edit — 2024-12-28

**Risk Level:** 🟡 Semi-safe

**Files Changed:**
- `lib/services/user/user_api.dart` (updated) — added patchMe() method
- `lib/services/user/user_service.dart` (updated) — added updateProfile() + fetchCurrentProfile()
- `lib/client_part/profile_pages/edit_profile/edit_profile_widget.dart` (updated) — wired to real API
- `lib/config/ui_tokens.dart` (updated) — added profile microcopy
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Implemented real profile editing via PATCH /users/me. The EditProfile screen now pre-fills with current user data (via GET /auth/me), validates form inputs, shows loading states, and saves changes to the backend. Includes error handling and French snackbar messages.

**Endpoint Used:**
- `PATCH /users/me` — body: `{ fullName?, phone?, city?, bio?, gender? }` — returns updated profile

**Key Features:**
- **Pre-fill:** Form loads current profile data on init
- **Validation:** Name is required
- **Change detection:** Save button checks if anything changed
- **Loading states:** Loading spinner during fetch and save
- **Error handling:** User-friendly French messages for all errors
- **Session handling:** Works with token refresh interceptor (PR-F17)

**How to Test:**
1. Login → Navigate to Profile → Edit Profile
2. Verify fields are pre-filled with current data
3. Modify name → Save → Verify snackbar "Profil mis à jour !"
4. Navigate back → Verify Profile shows new name
5. Try saving with empty name → Error snackbar
6. Try saving without changes → "Aucune modification" snackbar
7. Kill app → Reopen → Verify profile persists

**Rollback:**
```bash
git checkout HEAD~1 -- lib/services/user/user_api.dart lib/services/user/user_service.dart lib/client_part/profile_pages/edit_profile/edit_profile_widget.dart lib/config/ui_tokens.dart docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR-F18"
```

---

## [PR-F17] Token Refresh Interceptor — 2024-12-28

**Risk Level:** 🟡 Semi-safe (AUTH CRITICAL)

**Files Changed:**
- `lib/services/auth/token_refresh_interceptor.dart` (created) — interceptor with concurrency control
- `lib/services/auth/auth_repository.dart` (updated) — added refreshTokens interface
- `lib/services/auth/real_auth_repository.dart` (updated) — implemented refreshTokens
- `lib/services/auth/auth_service.dart` (updated) — added tryRefreshTokens
- `lib/services/api/api_client.dart` (updated) — added authenticatedGet/Post/Put/Delete
- `lib/main.dart` (updated) — configured interceptor callbacks
- `lib/config/ui_tokens.dart` (updated) — added sessionExpired microcopy
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Implemented automatic token refresh when access token expires. When a 401 is received, the interceptor attempts to refresh tokens using the stored refresh token. If successful, the original request is replayed. If refresh fails, user is logged out with a snackbar message.

**Endpoint Used:**
- `POST /api/v1/auth/refresh` — body: `{ refreshToken }` — returns new tokens

**Key Features:**
- **Automatic refresh:** 401 triggers transparent token refresh
- **Concurrency control:** Multiple simultaneous 401s wait for single refresh (mutex pattern)
- **Single retry:** Each request retries max once after refresh (prevents loops)
- **Graceful logout:** Failed refresh triggers logout + user notification
- **Global snackbar:** "Session expirée, veuillez vous reconnecter."
- **API helpers:** `ApiClient.authenticatedGet/Post/Put/Delete` with built-in refresh

**Security:**
- Tokens never logged
- Refresh token stored in SharedPreferences (existing pattern)
- Timeout on refresh request
- Max 1 retry per request

**How to Test:**
1. **Normal flow:** Login → use app → tokens stay valid → no 401
2. **Expired token (simulate):** Manually edit TokenStorage to set expired token, make API call → should refresh and succeed
3. **Invalid refresh token:** Clear refreshToken in storage, make call with expired access token → should logout + show snackbar
4. **Concurrent requests:** Trigger multiple API calls simultaneously with expired token → only 1 refresh, all requests succeed
5. **Backend refresh endpoint down:** Returns 500 on refresh → logout + snackbar

**Manual Test Steps (Detailed):**
1. Login normally
2. Navigate to Home (missions load OK)
3. In DevTools/debugger, call `TokenStorage.setToken('invalid_token')` 
4. Pull to refresh missions
5. Expected: Automatic refresh → missions reload OK (or if refresh fails → logout + snackbar)

**Rollback:**
```bash
git rm lib/services/auth/token_refresh_interceptor.dart
git checkout HEAD~1 -- lib/services/auth/auth_repository.dart lib/services/auth/real_auth_repository.dart lib/services/auth/auth_service.dart lib/services/api/api_client.dart lib/main.dart lib/config/ui_tokens.dart docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR-F17"
```

---

## [PR-F16] My Applications (Mes candidatures) — 2024-12-28

**Risk Level:** 🟡 Semi-safe (NEW PAGE + API CALL)

**Files Changed:**
- `lib/services/offers/offer_models.dart` (created) — Offer model with status enum
- `lib/services/offers/offers_api.dart` (updated) — added fetchMyOffersDetailed()
- `lib/services/offers/offers_service.dart` (updated) — added getMyApplications()
- `lib/client_part/my_applications/my_applications_widget.dart` (created) — applications list page
- `lib/client_part/home/home_widget.dart` (updated) — added applications button
- `lib/flutter_flow/nav/nav.dart` (updated) — added route
- `lib/config/ui_tokens.dart` (updated) — added FR microcopy
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
New page displaying user's mission applications with status tracking. Users can see all missions they applied to, with status badges (En attente, Acceptée, Refusée, etc.) and navigate to mission details. Accessible via the Home screen with a badge showing count of applications.

**Endpoint Used:**
- `GET /api/v1/offers/mine` — returns list of user's offers with mission details

**Key Features:**
- **List view:** All applications sorted by most recent first
- **Status badges:** Visual indicators (En attente/Acceptée/Refusée/Annulée/Expirée)
- **Mission details:** If backend embeds mission, shows title/city/price
- **Navigation:** Tap card → opens MissionDetail
- **Pull to refresh:** Refresh list with swipe
- **Empty state:** Friendly message + CTA to explore missions
- **Error state:** Retry button
- **Quick access:** Badge button in Home header (shows count)

**Microcopy (French):**
- myApplications: "Mes candidatures"
- emptyApplications: "Tu n'as pas encore postulé."
- emptyApplicationsHint: "Explore les missions et postule !"
- applicationPending/Accepted/Rejected/Cancelled/Expired
- viewMission: "Voir la mission"
- appliedOn: "Postulé le"

**Manual Test Flow:**
1. Login → Home → tap applications button (work icon) → MyApplicationsWidget
2. Empty state visible if no applications
3. If applications exist → list with status badges
4. Pull down to refresh
5. Tap card → navigates to MissionDetail
6. Apply to new mission → badge count increments
7. Kill app → reopen → applications still visible

**Rollback:**
```bash
git rm -r lib/client_part/my_applications
git rm lib/services/offers/offer_models.dart
git checkout HEAD~1 -- lib/services/offers/offers_api.dart lib/services/offers/offers_service.dart lib/client_part/home/home_widget.dart lib/flutter_flow/nav/nav.dart lib/config/ui_tokens.dart docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR-F16"
```

---

## [PR-F15] Apply to Mission (Real API) — 2024-12-28

**Risk Level:** 🟡 Semi-safe (NEW SERVICE + API CALL)

**Files Changed:**
- `lib/services/offers/offers_api.dart` (created) — HTTP client for offers endpoint
- `lib/services/offers/offers_service.dart` (created) — high-level service with idempotency
- `lib/services/offers/applied_missions_store.dart` (created) — local persistence for applied missions
- `lib/client_part/mission_detail/mission_detail_widget.dart` (updated) — wired Postuler button
- `lib/config/ui_tokens.dart` (updated) — added apply-related microcopy
- `lib/main.dart` (updated) — initialized OffersService at startup
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Wired the "Postuler" button in MissionDetail to real backend API (`POST /api/v1/offers`). Users can now apply to missions with proper loading states, error handling, and idempotency protection. Applied missions are persisted locally to prevent re-apply.

**Endpoint Used:**
- `POST /api/v1/offers` — body: `{ missionId }` — creates offer/application
- Response: 201 success, 409 already applied, 401 unauthorized

**Key Features:**
- **Loading state:** Button shows "Envoi…" while request is in progress
- **Success state:** Button becomes "Postulé" (green) and disabled after success
- **Idempotency:** Prevents double-tap during request, checks local store before API call
- **Local persistence:** Applied mission IDs stored in SharedPreferences
- **409 handling:** Already-applied response treated as success
- **Error feedback:** French snackbar messages for network/auth/generic errors

**Microcopy (French):**
- applySuccess: "Candidature envoyée !"
- applyAlreadyApplied: "Vous avez déjà postulé à cette mission."
- applyError: "Une erreur est survenue. Réessaye."
- applyNetworkError: "Connexion impossible. Vérifie ta connexion."
- applied: "Postulé"
- applying: "Envoi…"

**Manual Test Flow:**
1. Login → Home → Tap mission → MissionDetail
2. "Postuler" button visible (green, enabled)
3. Tap "Postuler" → button shows "Envoi…" → success snackbar → button becomes "Postulé" (disabled)
4. Kill app → reopen → same mission → button still shows "Postulé"
5. Rapid double-tap → only 1 request sent
6. Offline test → shows network error, button stays enabled
7. Try apply to already-applied mission → shows "Vous avez déjà postulé" → button disabled

**Rollback:**
```bash
git rm -r lib/services/offers
git checkout HEAD~1 -- lib/client_part/mission_detail/mission_detail_widget.dart lib/config/ui_tokens.dart lib/main.dart docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR-F15"
```

---

## [PR-F14] Reset Password (Real API) — 2024-12-28

**Risk Level:** 🟢 Auto-safe (LOW)

**Files Changed:**
- `lib/services/auth/auth_repository.dart` (updated) — added forgotPassword/resetPassword interface
- `lib/services/auth/real_auth_repository.dart` (updated) — implemented HTTP calls
- `lib/services/auth/auth_service.dart` (updated) — added wrapper methods
- `lib/client_part/reset_password/reset_password_model.dart` (updated) — added loading state
- `lib/client_part/reset_password/reset_password_widget.dart` (updated) — wired API calls
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Wired the Reset Password flow to real backend API. Users can now request a password reset email, enter the verification code, and set a new password. Full end-to-end flow with loading states, error handling, and French messages. Success redirects to Sign In page.

**Endpoints Used:**
- `POST /api/v1/auth/forgot-password` — body: `{ email }` — sends reset code
- `POST /api/v1/auth/reset-password` — body: `{ email, code, newPassword }` — resets password

**Flow:**
1. User enters email → API sends code
2. User enters 4-digit code
3. User sets new password (min 8 chars) + confirmation
4. Success → redirects to Sign In

**Error Handling (French):**
- Empty email: "Veuillez entrer votre adresse email"
- Invalid email: "Adresse email invalide"
- Email not found: "Aucun compte associé à cet email"
- Invalid code: "Code invalide ou expiré"
- Passwords don't match: "Les mots de passe ne correspondent pas"
- Password too short: "Le mot de passe doit contenir au moins 8 caractères"
- Network error: "Erreur de connexion. Réessaie."

**Validation:**
- Email: required, contains @ and .
- Code: 4 digits
- Password: min 8 characters, must match confirmation
- All inputs trimmed

**Security:**
- No tokens/codes logged (debugPrint only logs status, not values)
- Inputs trimmed before submission

**Manual Test Flow:**
1. Go to Sign In → tap "Mot de passe oublié"
2. Enter valid email → tap "Next" → see "Code envoyé" SnackBar
3. Enter 4-digit code → tap "Continue"
4. Enter new password + confirmation → tap "Save New Password"
5. See success screen → tap "Se connecter" → redirects to Sign In
6. Login with new password → should work
7. Test error cases:
   - Invalid email → SnackBar error
   - Wrong code → SnackBar error, stays on page
   - Passwords don't match → SnackBar error
   - Password too short → SnackBar error
   - Network down → Failed widget with retry option

**MockAuthRepository Behavior:**
- `forgotPassword`: succeeds unless email is "notfound@test.com"
- `resetPassword`: succeeds unless code is "0000"

**Rollback:**
```bash
git checkout HEAD~1 -- lib/services/auth/auth_repository.dart lib/services/auth/real_auth_repository.dart lib/services/auth/auth_service.dart lib/client_part/reset_password/reset_password_model.dart lib/client_part/reset_password/reset_password_widget.dart docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR-F14 reset password"
```

---

## [PR-F13] Location Permissions — 2024-12-28

**Risk Level:** 🟡 Semi-safe (NEW DEPENDENCY)

**Files Changed:**
- `android/app/src/main/AndroidManifest.xml` (updated) — added location permissions
- `ios/Runner/Info.plist` (updated) — added NSLocationWhenInUseUsageDescription
- `pubspec.yaml` (updated) — added geolocator dependency
- `lib/services/location/location_service.dart` (created) — location permission + position service
- `lib/client_part/home/home_widget.dart` (updated) — request location on init
- `lib/client_part/home/home_model.dart` (updated) — user position fields
- `lib/client_part/components_client/missions_map/missions_map_widget.dart` (updated) — enable myLocation
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Added Android + iOS location permission support. Created `LocationService` for requesting permission and getting user position. Home now requests location permission on init and uses real coordinates for nearby missions if granted. Map shows user location indicator when permission granted. Falls back to default Montreal coordinates if denied. Non-blocking SnackBar messages when permission denied.

**Key Features:**
- **Android permissions**: ACCESS_FINE_LOCATION + ACCESS_COARSE_LOCATION
- **iOS permission**: NSLocationWhenInUseUsageDescription (French message)
- **LocationService**: Singleton with permission check, request, and getCurrentPosition
- **Graceful fallback**: Uses Montreal (45.5017, -73.5673) if permission denied
- **Non-blocking UI**: SnackBar messages for denied/disabled states with action buttons
- **Map enhancement**: Shows user location dot + button when permission granted
- **Web-safe**: Guards for kIsWeb to prevent crashes on web platform

**New Dependency:**
- `geolocator: ^13.0.2`

**SnackBar Messages (French):**
- Denied: "Position non disponible. Affichage des missions près de Montréal."
- Denied Forever: "Accès à la position refusé. Activez-la dans les paramètres." + [Paramètres]
- Service Disabled: "Localisation désactivée. Activez-la pour voir les missions près de vous." + [Activer]

**Manual Test Flow:**
1. Fresh install Android: open app → permission prompt appears
2. Allow → map loads, centers on user, nearby missions for user location
3. Deny → SnackBar shown, map loads with Montreal default
4. iOS build: same flow with iOS permission prompt
5. Toggle Map view → user location dot visible (if granted)
6. Backend down → app doesn't crash, shows error state

**Configuration Notes:**
- No background location requested (not needed for MVP)
- Accuracy set to "medium" for battery efficiency
- Timeout set to 10 seconds for position request

**Rollback:**
```bash
git rm -r lib/services/location
git checkout HEAD~1 -- android/app/src/main/AndroidManifest.xml ios/Runner/Info.plist pubspec.yaml lib/client_part/home/home_widget.dart lib/client_part/home/home_model.dart lib/client_part/components_client/missions_map/missions_map_widget.dart docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR-F13 location permissions"
flutter pub get
```

---

## [PR-F12] Share Mission — 2024-12-28

**Risk Level:** 🟢 Auto-safe (LOW)

**Files Changed:**
- `pubspec.yaml` (updated) — added share_plus dependency
- `lib/client_part/mission_detail/mission_detail_widget.dart` (updated)
- `lib/config/ui_tokens.dart` (updated)
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Made "Partager" button functional using OS native share sheet (share_plus package). Users can share mission details including title, city, price, and a deep link placeholder.

**Key Features:**
- **Native share sheet**: Uses OS share functionality (iOS/Android/Web)
- **Clean message format**: 🔧 Title, 📍 City, 💰 Price, workon:// link
- **Graceful degradation**: Missing fields are omitted without crash
- **Error handling**: Shows snackbar on share failure

**Share Message Format:**
```
🔧 {title}
📍 {city}
💰 {price}

workon://mission/{id}
```

**New Dependency:**
- `share_plus: ^10.1.4`

**New Microcopy (WkCopy):**
- `shareError`: "Impossible de partager"

**Manual Test Flow:**
1. Login → Home → tap any mission → open detail
2. Tap "Partager" → native share sheet opens
3. See formatted message with title/city/price/link
4. Share via any app (Messages, Email, etc.)
5. Cancel share → no crash

**Rollback:**
```bash
git checkout HEAD~1 -- pubspec.yaml lib/client_part/mission_detail/mission_detail_widget.dart lib/config/ui_tokens.dart docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR-F12 share mission"
flutter pub get
```

---

## [PR-F11] Saved Missions (Local) — 2024-12-28

**Risk Level:** 🟢 Auto-safe (LOW)

**Files Changed:**
- `lib/services/saved/saved_missions_store.dart` (created)
- `lib/client_part/saved/saved_missions_page.dart` (created)
- `lib/client_part/mission_detail/mission_detail_widget.dart` (updated)
- `lib/client_part/home/home_widget.dart` (updated)
- `lib/flutter_flow/nav/nav.dart` (updated)
- `lib/main.dart` (updated)
- `lib/config/ui_tokens.dart` (updated)
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Made "Sauvegarder" button functional using local persistence (SharedPreferences). Users can save/unsave missions, view saved missions list, and saved state persists across app restarts. Works offline - no backend required.

**Key Features:**
- **SavedMissionsStore**: Service for local persistence of saved mission IDs
- **Functional save button**: Toggle saved state with visual feedback + snackbar
- **Saved missions page**: List view of saved missions with tap-to-remove
- **Saved indicator**: Bookmark icon with count in missions header
- **Offline support**: Works without backend, persists across restarts

**New Files:**
- `lib/services/saved/saved_missions_store.dart` - Local storage service
- `lib/client_part/saved/saved_missions_page.dart` - Saved missions list page

**New Microcopy (WkCopy):**
- `savedMissions`: "Sauvegardées"
- `savedSuccess`: "Mission sauvegardée"
- `unsavedSuccess`: "Retirée des sauvegardées"
- `emptySavedMissions`: "Aucune mission sauvegardée."
- `tapToSaveHint`: "Appuie sur 🔖 pour sauvegarder une mission"

**Manual Test Flow:**
1. Login → Home → tap any mission → open detail
2. Tap "Sauvegarder" → button changes to filled bookmark + snackbar
3. Go back → tap saved button (bookmark icon with count) → opens saved page
4. See mission in list → tap to open detail
5. Tap filled bookmark → mission removed from saved list
6. Kill app → reopen → saved missions persist
7. Empty saved list → shows empty state with hint

**Rollback:**
```bash
git rm -r lib/services/saved lib/client_part/saved
git checkout HEAD~1 -- lib/client_part/mission_detail/mission_detail_widget.dart lib/client_part/home/home_widget.dart lib/flutter_flow/nav/nav.dart lib/main.dart lib/config/ui_tokens.dart docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR-F11 saved missions"
```

---

## [PR-F10] Missions Filters (Read-Only) — 2024-12-28

**Risk Level:** 🟢 Auto-safe (LOW)

**Files Changed:**
- `lib/client_part/home/home_widget.dart` (updated)
- `lib/client_part/home/home_model.dart` (updated)
- `lib/services/missions/missions_service.dart` (updated)
- `lib/services/missions/missions_api.dart` (updated)
- `lib/config/ui_tokens.dart` (updated)
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Added read-only filters for missions discovery. Users can filter by distance radius (5km/10km/25km), and sort by proximity, price ascending/descending, or newest. Filters trigger a re-fetch with current parameters. Sort is applied client-side as fallback if backend doesn't support it.

**Key Features:**
- **Distance chips**: 5km, 10km, 25km (default: 10km)
- **Sort dropdown**: Proximité, Prix ↑, Prix ↓, Nouveau (default: Proximité)
- **Client-side fallback**: Sort is applied locally if backend ignores param
- **Refresh preserves filters**: Refresh button uses current filter values
- **No new dependencies**: All UI built with existing widgets

**New Microcopy (WkCopy):**
- `filters`: "Filtres"
- `sortBy`: "Trier par"
- `sortProximity`: "Proximité"
- `sortPriceAsc`: "Prix ↑"
- `sortPriceDesc`: "Prix ↓"
- `sortNewest`: "Nouveau"
- `allCategories`: "Toutes"

**Manual Test Flow:**
1. Login → Home → missions section
2. See filter row with distance chips + sort dropdown
3. Tap "5 km" → missions refetch with new radius
4. Tap "25 km" → missions refetch with larger radius
5. Select "Prix ↑" in dropdown → missions sorted by price ascending
6. Select "Nouveau" → missions sorted by newest first
7. Toggle List/Cards/Map → same filtered dataset
8. Tap refresh → keeps current filters
9. Backend down → existing error + retry works

**Rollback:**
```bash
git checkout HEAD~1 -- lib/client_part/home/home_widget.dart lib/client_part/home/home_model.dart lib/services/missions/missions_service.dart lib/services/missions/missions_api.dart lib/config/ui_tokens.dart docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR-F10 missions filters"
```

---

## [PR-F09] MissionDetail Actions (UI Only) — 2024-12-28

**Risk Level:** 🟢 Auto-safe (LOW)

**Files Changed:**
- `lib/client_part/mission_detail/mission_detail_widget.dart` (updated)
- `lib/config/ui_tokens.dart` (updated)
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Added "Actions" section to MissionDetailWidget with UI-only CTA buttons. Primary CTA "Postuler" shows snackbar "Bientôt disponible". Secondary actions "Partager" and "Sauvegarder" also show snackbar. CTA is disabled when mission status is not "open". Added legal disclaimer text about WorkOn being a platform.

**Key Features:**
- **Primary CTA**: "Postuler" button (enabled only for open missions)
- **Secondary actions**: "Partager" and "Sauvegarder" buttons
- **Snackbar feedback**: All buttons show "Bientôt disponible" snackbar
- **Disabled state**: Clear "Mission non disponible" label when not open
- **Legal disclaimer**: Platform info text at bottom

**New Microcopy (WkCopy):**
- `actions`: "Actions"
- `apply`: "Postuler"
- `applyDisabled`: "Mission non disponible"
- `share`: "Partager"
- `save`: "Sauvegarder"
- `comingSoon`: "Bientôt disponible"
- `legalDisclaimer`: WorkOn platform disclaimer

**Manual Test Flow:**
1. Login → Home → tap mission (open status)
2. See Actions section with enabled "Postuler" button
3. Tap "Postuler" → snackbar "Bientôt disponible"
4. Tap "Partager" → snackbar "Bientôt disponible"
5. Tap "Sauvegarder" → snackbar "Bientôt disponible"
6. See legal disclaimer text at bottom
7. For assigned/completed mission → CTA shows "Mission non disponible" (disabled)

**Rollback:**
```bash
git checkout HEAD~1 -- lib/client_part/mission_detail/mission_detail_widget.dart lib/config/ui_tokens.dart docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR-F09 mission detail actions"
```

---

## [PR-F08] Polish + Branding + UX Consistency — 2024-12-28

**Risk Level:** 🟢 Auto-safe (LOW)

**Files Changed:**
- `lib/config/ui_tokens.dart` (created)
- `lib/client_part/home/home_widget.dart` (updated)
- `lib/client_part/mission_detail/mission_detail_widget.dart` (updated)
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Introduced centralized UI tokens for consistent branding and UX across the app. Created `ui_tokens.dart` with spacing, radius, colors, gradients, icon sizes, and French microcopy constants. Updated missions surfaces (Home feed, MissionDetail) to use these tokens. Harmonized loading/error/empty state messages in French. Added animated toggle button for List/Cards view.

**Key Changes:**
- **WkSpacing**: Standardized spacing values (xs/sm/md/lg/xl/xxl/xxxl)
- **WkRadius**: Standardized border radius values (card, button, badge)
- **WkCopy**: Centralized French microcopy (loading, errors, empty states, labels)
- **WkStatusColors**: Consistent status colors (open/assigned/inProgress/completed/cancelled)
- **WkGradients**: Reusable card gradient presets
- **WkIconSize**: Standardized icon sizes
- **WkDuration**: Animation duration constants

**French Microcopy Harmonized:**
- Loading: "Chargement…"
- Empty missions: "Aucune mission disponible près de toi."
- Error: "Impossible de charger les missions." + "Réessayer"
- Mission not found: "Mission introuvable."
- Back: "Retour"

**Manual Test Flow:**
1. Login → Home loads
2. Missions section visible; loading/empty/error texts in French
3. Toggle List/Cards/Map works; UI consistent with animated transitions
4. Tap mission → MissionDetail displays correctly
5. Retry button works on error state
6. No crashes; `dart analyze` = 0

**Rollback:**
```bash
git rm lib/config/ui_tokens.dart
git checkout HEAD~1 -- lib/client_part/home/home_widget.dart lib/client_part/mission_detail/mission_detail_widget.dart docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR-F08 polish + branding"
```

---

## [PR-F07] Missions Map Pins — 2024-12-28

**Risk Level:** 🟡 Semi-safe (NEW DEPENDENCY)

**Files Changed:**
- `pubspec.yaml` (updated - added google_maps_flutter)
- `lib/config/app_config.dart` (updated - Google Maps config)
- `lib/client_part/components_client/missions_map/missions_map_widget.dart` (created)
- `lib/client_part/home/home_widget.dart` (updated - map toggle)
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Added Google Map view displaying mission locations as colored pins. Users can toggle between List, Cards, and Map views. Pins are color-coded by status. Tap pin info → navigates to MissionDetail.

**Key Features:**
- **MissionsMapWidget**: Google Map with mission markers
- **Pin colors by status**: Green (open), Blue (assigned), Orange (in progress)
- **Toggle 3 views**: List / Cards / Map icons
- **Tap pin**: Shows InfoWindow → tap → MissionDetail
- **Fit bounds**: Button to fit all markers in view
- **Legend**: Shows status color meanings
- **Graceful fallback**: No API key → "Carte non disponible" message

**Configuration Required:**
```bash
# Android: android/app/src/main/AndroidManifest.xml
<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_API_KEY"/>

# iOS: ios/Runner/AppDelegate.swift
GMSServices.provideAPIKey("YOUR_API_KEY")

# Build with:
flutter run --dart-define=GOOGLE_MAPS_API_KEY=YOUR_KEY
```

**Manual Test Flow:**
1. Login → Home → missions section
2. Toggle to Map (🗺️ icon)
3. Pins visible on map
4. Tap pin → InfoWindow shows title/price
5. Tap InfoWindow → MissionDetail opens
6. Backend down → app doesn't crash

**Rollback:**
```bash
git rm lib/client_part/components_client/missions_map/missions_map_widget.dart
git checkout HEAD~1 -- pubspec.yaml lib/config/app_config.dart lib/client_part/home/home_widget.dart docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR-F07"
flutter pub get
```

---

## [PR-F06] Real Mission Detail + Fallback Fetch — 2024-12-28

**Risk Level:** 🟢 Auto-safe (LOW)

**Files Changed:**
- `lib/client_part/mission_detail/mission_detail_widget.dart` (updated)
- `lib/services/missions/missions_api.dart` (updated)
- `docs/CHANGELOG_DEV.md` (updated)

**Summary:**  
Enhanced MissionDetail to be fully resilient with real backend data. Added Retry button on error, improved logging throughout, and better error messages for network/timeout/server errors.

**Key Features:**
- **Instant render**: If mission object is passed, displays immediately (no fetch)
- **Fallback fetch**: If only missionId provided, fetches from backend
- **Retry button**: On error, user can retry without navigating back
- **Improved logging**: Debug prints for all fetch states
- **Better error messages**: Specific messages for timeout, network, 404, 500+

**Manual Test Flow:**
1. Login → Home → tap mission (from list or cards)
2. Expected: instant render (mission passed from Home)
3. Navigate with missionId only → spinner → loads → renders
4. Backend down → error message + Retry button
5. Tap Retry → attempts fetch again

**Rollback:**
```bash
git checkout HEAD~1 -- lib/client_part/mission_detail/mission_detail_widget.dart lib/services/missions/missions_api.dart docs/CHANGELOG_DEV.md
git commit -m "Rollback: PR-F06"
```

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
