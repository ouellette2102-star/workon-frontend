# DoD v1.0 — EXECUTION CHECKLIST (Flutter)

> **Date**: 2026-01-30  
> **Sync with**: `backend/docs/release/DoD_v1.0_MASTER.md`

---

## 📋 CHECKLIST PAR PHASE

### PHASE 1 — GLOBAL AUDIT ✅

- [x] Audit architecture Flutter (pubspec.yaml, lib/)
- [x] Audit services API (ApiClient, MissionsApi, AuthService)
- [x] Audit flux Worker (Discovery, Apply, Complete)
- [x] Audit flux Employer (Create, Offers, Payment)
- [x] Audit Auth, Rôles, Permissions
- [x] Audit UI/UX (erreurs, fallbacks)
- [ ] **Créer**: `GLOBAL_AUDIT_REPORT.md`

### PHASE 2 — FLOW COMPLETENESS 🟡

#### Worker Flow (9/9 ✅)
- [x] 1. Register (SignUpWidget)
- [x] 2. Login (SignInWidget) + FIX navigation
- [x] 3. Accept Terms (LegalConsentGate)
- [x] 4. Browse Missions (DiscoveryWidget)
- [x] 5. Filter/Search (FL-4 FilterChips)
- [x] 6. Apply (OffersApi)
- [x] 7. Accept Mission
- [x] 8. Complete Mission
- [x] 9. Leave Review

#### Employer Flow (9/10 🟡)
- [x] 1. Register
- [x] 2. Login
- [x] 3. Accept Terms
- [x] 4. Create Mission (FL-2 CatalogService)
- [x] 5. View Offers
- [x] 6. Accept Worker
- [x] 7. Pay (Stripe)
- [ ] 8. **Chat** ← BLOCKED (LocalUser migration)
- [x] 9. Confirm Complete
- [x] 10. Leave Review

- [ ] **Créer**: `E2E_FLOW_MATRIX.md`

### PHASE 3 — API CONTRACT 🟡

- [x] Vérifier toutes les routes Flutter vs Backend
- [x] Corriger préfixes routes (/api/v1/reviews)
- [x] Aligner DTOs (sort, category, query)
- [x] FL-1: CatalogApi créé
- [x] FL-3: Backend sort/filter activé
- [ ] **Créer**: `API_CONTRACT.md`

### PHASE 4 — SECURITY & LEGAL ⬜

- [ ] Vérifier tous les guards Flutter
- [ ] Vérifier ConsentGate enforcement
- [ ] Vérifier TokenStorage sécurisé
- [ ] Vérifier aucune clé en dur
- [ ] **Créer**: `SECURITY_COMPLIANCE_REPORT.md`

### PHASE 5 — CI/CD & OPS 🟡

- [x] flutter build apk → OK
- [x] flutter test → 108 tests
- [x] flutter analyze → 0 errors
- [ ] iOS build (si Mac disponible)
- [ ] **Créer**: `CI_STATUS_REPORT.md`

### PHASE 6 — DOCUMENTATION 🟡

- [x] DoD_v1.0_MASTER.md créé
- [x] FLUTTER_BACKEND_MAPPING.md à jour
- [x] FINAL_EXECUTION_REPORT.md à jour
- [x] DOD_EXECUTION_CHECKLIST.md créé
- [ ] E2E_FLOW_MATRIX.md
- [ ] API_CONTRACT.md
- [ ] DECISIONS_LOG.md

### PHASE 7 — FINAL GATE ⬜

| Critère | Status |
|---------|--------|
| All Worker flows | ✅ |
| All Employer flows | 🟡 (Chat) |
| All CI passes | ✅ |
| No critical blockers | 🔴 (Catalog) |
| Security validated | ⬜ |
| Docs complete | 🟡 |

**VERDICT**: 🟡 NOT DONE

---

## 🚫 BLOCKERS FLUTTER

| ID | Blocker | Impact | Fix |
|----|---------|--------|-----|
| FL-B1 | Chat non fonctionnel | Employer flow incomplet | LocalUser migration |
| FL-B2 | Categories fallback | UI dégrade | Seed catalog prod |
| FL-B3 | Location timeout émulateur | UX lente | Mock GPS ou try-catch |

---

## ✅ FIXES APPLIQUÉS (Session actuelle)

| Fix | Fichier | Description |
|-----|---------|-------------|
| FL-1 | `catalog_*.dart` | CatalogApi + Service créés |
| FL-2 | `create_mission_widget.dart` | Categories dynamiques |
| FL-3 | `missions_api.dart` | Backend sort/filter activé |
| FL-4 | `swipe_discovery_page.dart` | FilterChips catégories |
| FIX-NAV | `sign_in_widget.dart` | Navigation post-login |
| FIX-NAV | `sign_up_widget.dart` | Navigation post-signup |

---

## 📈 PROGRESSION

```
Phase 1: ████████░░ 80%
Phase 2: █████████░ 90%
Phase 3: ████████░░ 80%
Phase 4: ░░░░░░░░░░  0%
Phase 5: ███████░░░ 70%
Phase 6: ██████░░░░ 60%
Phase 7: ░░░░░░░░░░  0% (BLOCKED)

TOTAL: ~65%
```

---

## 🎯 NEXT ACTIONS (Ordered)

1. ⬜ **STOP** — Attendre validation humaine
2. ⬜ Seed catalog en production (B1)
3. ⬜ Tester Chat après LocalUser migration backend
4. ⬜ Créer E2E_FLOW_MATRIX.md
5. ⬜ Créer API_CONTRACT.md
6. ⬜ Audit sécurité Phase 4
7. ⬜ Final Gate Phase 7

---

*Dernière mise à jour: 2026-01-30*
