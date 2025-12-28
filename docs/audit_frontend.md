# WorkOn Frontend Audit Report

**Date:** 2024-12-26  
**Framework:** Flutter + FlutterFlow  
**Project:** WorkOn (formerly Sparkly template)

---

## 📊 Executive Summary

| Metric | Value |
|--------|-------|
| **Total Screens** | 72 |
| **Routes Defined** | 72 |
| **API Calls Implemented** | 5 |
| **API Calls Missing** | ~20+ |
| **Critical Gaps** | 8 |
| **PRs Required** | 24 |

### Overall Status: ⚠️ **UI COMPLETE, BACKEND INTEGRATION ~10%**

---

## ✅ What's Working

| Component | Status | Notes |
|-----------|--------|-------|
| Auth: Login | ✅ OK | Wired to `/auth/login` |
| Auth: Register | ✅ OK | Wired to `/auth/register` |
| Auth: Session check | ✅ OK | Wired to `/auth/me` |
| Auth: Logout | ✅ OK | Clears session |
| Auth: Role resolution | ✅ OK | Fetches role from `/auth/me` |
| AuthGate routing | ✅ OK | Routes based on auth state |
| Navigation | ✅ OK | GoRouter properly configured |
| Localization | ✅ OK | FFLocalizations (FR/EN) |
| Theme | ✅ OK | FlutterFlow theme system |
| Legal pages | ✅ OK | TOS, Privacy Policy static |

---

## ❌ Critical Gaps (Store Blockers)

### 1. **No Token Persistence** (HIGH)
- Tokens stored in-memory only
- App restart = user must re-login
- **Fix:** PR-F04 (SecureStorage)

### 2. **Reset Password Not Functional** (HIGH)
- UI exists with 4-step wizard
- Zero backend integration
- **Fix:** PR-F01

### 3. **No Mission/Job API** (HIGH)
- All missions/jobs are static mock data
- Core business flow broken
- **Fix:** PR-F08

### 4. **No Payment Integration** (HIGH)
- Stripe not integrated
- Payment screens are UI mockups
- **Fix:** PR-F10

### 5. **No Messaging** (HIGH)
- Chat UI exists but static
- No WebSocket/real-time
- **Fix:** PR-F11

### 6. **No Provider Onboarding** (HIGH)
- Provider registration UI exists
- Not wired to backend
- **Fix:** PR-F22

### 7. **No Earnings/Payout** (HIGH)
- Provider earnings screen static
- Stripe Connect not integrated
- **Fix:** PR-F23

### 8. **Wrong Branding** (MED)
- "Sparkly" appears in many places
- Should be "WorkOn"
- **Fix:** PR-F19

---

## 📱 Screens Inventory

### Authentication (4 screens)
| Screen | Route | Backend | Status |
|--------|-------|---------|--------|
| OnboardingWidget | `/onboarding` | N/A | ✅ OK |
| SignInWidget | `/signIn` | ✅ Wired | ✅ OK |
| SignUpWidget | `/signUp` | ✅ Wired | ✅ OK |
| ResetPasswordWidget | `/resetPassword` | ❌ Not wired | ⚠️ UI Only |

### Client Part (42 screens)
| Category | Count | Backend Status |
|----------|-------|----------------|
| Home | 1 | ❌ Static |
| Profile/Settings | 12 | ❌ Static |
| Search/Catalogue | 5 | ❌ Static |
| Booking Flow | 10 | ❌ Static |
| Messaging | 4 | ❌ Static |
| Notifications | 1 | ❌ Static |
| Ratings | 2 | ❌ Static |

### Provider Part (22 screens)
| Category | Count | Backend Status |
|----------|-------|----------------|
| Provider Home | 1 | ❌ Static |
| Jobs/Requests | 4 | ❌ Static |
| Earnings | 3 | ❌ Static |
| Services | 2 | ❌ Static |
| Profile | 7 | ❌ Static |

---

## 🔌 API Calls Analysis

### Implemented (5)
```
POST /api/v1/auth/login      ← lib/services/auth/real_auth_repository.dart
POST /api/v1/auth/register   ← lib/services/auth/real_auth_repository.dart
GET  /api/v1/auth/me         ← lib/services/auth/real_auth_repository.dart
POST /api/v1/auth/logout     ← lib/services/auth/real_auth_repository.dart
GET  /api/v1/auth/me         ← lib/services/user/user_api.dart (role fetch)
```

### Missing (Critical)
```
POST /api/v1/auth/forgot-password    ← Reset password
POST /api/v1/auth/reset-password     ← Reset password
PATCH /api/v1/users/me               ← Profile update
GET /api/v1/missions/nearby          ← Mission discovery
POST /api/v1/missions                ← Create mission
POST /api/v1/missions/:id/accept     ← Accept mission
POST /api/v1/payments/intent         ← Stripe payment
GET /api/v1/payments/connect/*       ← Stripe Connect
GET /api/v1/messages/thread/:id      ← Messaging
POST /api/v1/messages                ← Send message
GET /api/v1/notifications            ← Notifications
POST /api/v1/ratings                 ← Submit rating
GET /api/v1/contracts/user/me        ← Contracts
```

---

## ⚙️ Configuration

### Environment Variables
| Variable | Location | Status |
|----------|----------|--------|
| `dart.vm.product` | `lib/config/app_config.dart` | ✅ Used for prod/dev |
| `API_BASE_URL` | Hardcoded | ⚠️ Should be env var |

### API URLs (Hardcoded)
```dart
// lib/config/app_config.dart
static const String apiBaseUrl = 'https://workon-backend-production.up.railway.app';
static const String apiBaseUrlDev = 'https://workon-backend-dev.up.railway.app';
```

---

## 🚀 Prioritized PR Plan

### Phase 1: Security & Stability (Week 1)
| PR | Title | Risk | Effort |
|----|-------|------|--------|
| PR-F04 | SecureStorage: Persist auth tokens | Low | 4h |
| PR-F03 | Token refresh mechanism | Med | 6h |
| PR-F01 | Reset password API integration | Low | 5h |

### Phase 2: Core Business (Week 2-3)
| PR | Title | Risk | Effort |
|----|-------|------|--------|
| PR-F08 | Missions API integration | Med | 10h |
| PR-F08b | Missions UI wiring | Low | 6h |
| PR-F22 | Provider registration | Low | 5h |
| PR-F05 | Profile update API | Low | 4h |

### Phase 3: Payments (Week 4)
| PR | Title | Risk | Effort |
|----|-------|------|--------|
| PR-F10 | Stripe PaymentIntent flow | High | 14h |
| PR-F23 | Provider earnings/payout | Med | 10h |

### Phase 4: Communication (Week 5)
| PR | Title | Risk | Effort |
|----|-------|------|--------|
| PR-F11 | Messaging API integration | Med | 10h |
| PR-F12 | Notifications API | Low | 6h |
| PR-F13 | Ratings API | Low | 6h |

### Phase 5: Polish (Week 6+)
| PR | Title | Risk | Effort |
|----|-------|------|--------|
| PR-F19 | Rebrand Sparkly → WorkOn | Low | 3h |
| PR-F16 | Empty states | Low | 4h |
| PR-F17 | Network retry mechanism | Low | 5h |
| PR-F02 | Social login (Google) | Med | 10h |

---

## 📁 Service Layer Architecture

```
lib/services/
├── api/
│   └── api_client.dart          ✅ Complete
├── auth/
│   ├── auth_service.dart        ✅ Complete
│   ├── auth_repository.dart     ✅ Complete (mock + real)
│   ├── real_auth_repository.dart ✅ Complete
│   ├── auth_models.dart         ✅ Complete
│   ├── auth_errors.dart         ✅ Complete
│   ├── auth_state.dart          ✅ Complete
│   ├── auth_bootstrap.dart      ✅ Complete
│   ├── app_boot_state.dart      ✅ Complete
│   ├── app_session.dart         ✅ Complete
│   └── app_startup_controller.dart ✅ Complete
└── user/
    ├── user_service.dart        ✅ Complete
    ├── user_context.dart        ✅ Complete
    └── user_api.dart            ✅ Complete
```

### Missing Services (To Create)
```
lib/services/
├── missions/
│   ├── mission_service.dart     ❌ Create
│   ├── mission_repository.dart  ❌ Create
│   └── mission_models.dart      ❌ Create
├── payments/
│   ├── payment_service.dart     ❌ Create
│   └── payout_service.dart      ❌ Create
├── messaging/
│   └── message_service.dart     ❌ Create
├── notifications/
│   └── notification_service.dart ❌ Create
├── ratings/
│   └── rating_service.dart      ❌ Create
└── contracts/
    └── contract_service.dart    ❌ Create
```

---

## 🔒 Security Checklist

| Check | Status |
|-------|--------|
| Tokens not logged | ✅ OK |
| Tokens in memory only | ⚠️ Needs SecureStorage |
| No hardcoded secrets | ✅ OK |
| HTTPS only | ✅ OK |
| Input validation | ⚠️ Basic only |
| Password complexity | ⚠️ Not enforced |
| Token refresh | ❌ Missing |
| Biometric auth | ❌ Not implemented |

---

## 📋 Next Steps

1. **Immediate:** PR-F04 (SecureStorage) - tokens must persist
2. **This week:** PR-F01 (Reset password) - critical user flow
3. **Next sprint:** PR-F08 (Missions API) - core business
4. **Before launch:** PR-F10 (Stripe) - revenue enablement

---

## 📎 Generated Files

- `docs/audit_frontend.json` - Machine-readable audit data
- `docs/pr_plan_frontend.json` - Detailed PR specifications
- `docs/audit_frontend.md` - This document

---

*Generated by WorkOn Frontend Audit Tool v1.0*

