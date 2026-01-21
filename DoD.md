# WorkOn — Definition of Done (DoD)

> **Version:** 1.0.0  
> **Date:** 2026-01-21  
> **Status:** 🟡 EN COURS

---

## 🎯 Objectif

WorkOn est considérée **TERMINÉE ET PUBLIABLE** lorsque **TOUS** les critères ci-dessous sont satisfaits.

---

## ✅ Critères de Complétion

### 1. Accessibilité des Écrans
| Critère | Statut |
|---------|--------|
| 100% des écrans accessibles via navigation | ✅ |
| Aucun écran orphelin | ✅ |
| Deep links fonctionnels | ✅ |

### 2. Fonctionnalité des Boutons
| Critère | Statut |
|---------|--------|
| 0 bouton sans effet réel | ✅ |
| Tous les CTAs exécutent leur action | ✅ |
| Feedback utilisateur sur chaque action | ✅ |

### 3. Code Propre
| Critère | Statut |
|---------|--------|
| 0 TODO actif bloquant | ✅ |
| 0 FIXME non résolu | ✅ |
| 0 mock/fake data en production | ✅ |
| Pas de code commenté inutile | ✅ |

### 4. Parcours Critiques E2E
| Parcours | Statut |
|----------|--------|
| Inscription Client | ✅ |
| Inscription Prestataire | ✅ |
| Création de Mission | ✅ |
| Acceptation de Mission | ✅ |
| Complétion de Mission | ✅ |
| Paiement Stripe | ⏳ Sandbox validé |
| Notation/Review | ✅ |

### 5. Paiements Stripe
| Critère | Statut |
|---------|--------|
| PaymentIntent création | ✅ |
| Webhook payment_intent.succeeded | ✅ |
| Webhook payment_intent.payment_failed | ✅ |
| Mode sandbox fonctionnel | ✅ |
| Stripe Connect (Post-MVP) | 📋 Planifié |

### 6. Sécurité (AuthZ)
| Critère | Statut |
|---------|--------|
| JWT validation sur tous endpoints | ✅ |
| Guards par rôle (Client/Worker/Admin) | ✅ |
| Rate limiting actif | ✅ |
| CORS configuré | ✅ |
| Données sensibles non exposées | ✅ |

### 7. CI/CD
| Critère | Statut |
|---------|--------|
| Lint pass | ✅ |
| Build pass | ✅ |
| Tests unitaires pass | ✅ |
| Tests E2E smoke pass | ✅ |
| Release gate verte | ⏳ |

### 8. Stabilité
| Critère | Statut |
|---------|--------|
| 0 crash bloquant connu | ✅ |
| Error boundaries en place | ✅ |
| Logging structuré | ✅ |
| Graceful degradation | ✅ |

### 9. Store Compliance
| Critère | Statut |
|---------|--------|
| Privacy Policy accessible | ✅ |
| Terms of Service accessible | ✅ |
| Legal consent screen | ✅ |
| Age rating compatible | ✅ |
| Screenshots prêts | 📋 À faire |
| App description rédigée | 📋 À faire |
| Firebase iOS config | ❌ Requis |

---

## 📊 Progression par Phase

| # | Phase | % | Statut |
|---|-------|---|--------|
| 1 | Discovery / Foundations | 100% | ✅ |
| 2 | Product Definition | 100% | ✅ |
| 3 | Architecture & Setup | 95% | 🟡 |
| 4 | MVP Build | 100% | ✅ |
| 5 | Stabilisation / Hardening | 95% | 🟡 |
| 6 | Feature Completion | 100% | ✅ |
| 7 | Pre-Release Readiness | 85% | 🟡 |
| 8 | Store & Distribution | 75% | 🟡 |
| 9 | Post-Launch Preparedness | 70% | 🟡 |

---

## 🚀 Checklist Pré-Release

### Backend
- [x] Tous les endpoints documentés (Swagger)
- [x] Variables d'environnement documentées
- [x] Migrations Prisma à jour
- [x] Seeds de données de test
- [x] Health check endpoint
- [x] Rate limiting configuré
- [ ] Monitoring/alerting (Post-MVP)

### Frontend Flutter
- [x] Builds Android release
- [ ] Builds iOS release (requiert Firebase config)
- [x] Deep linking configuré
- [x] Push notifications configurées
- [x] Analytics events définis
- [x] Crash reporting prêt
- [x] Localization FR/EN

### Infrastructure
- [x] Backend déployé (Railway)
- [x] Base de données PostgreSQL
- [x] Redis pour rate limiting
- [ ] Environnement staging séparé (Post-MVP)
- [ ] CDN pour assets (Post-MVP)

### Documentation
- [x] README à jour
- [x] DoD.md (ce document)
- [ ] Runbook de déploiement
- [ ] Guide incident response

---

## 🛡️ Constitution WorkOn (Règles Non-Négociables)

1. **Marketplace neutre** — Pas agence, pas employeur
2. **Opt-in total** — Anti-subordination
3. **Contrats par mission** — Pas de CDI déguisé
4. **Paiements sécurisés** — Auditables via Stripe
5. **Légalité by design** — Conformité dès la conception
6. **Zéro action trompeuse** — UI honnête et claire

---

## 📋 PRs Complétées

| PR | Description | Date |
|----|-------------|------|
| PR-C02 | CI: smoke-e2e dans release-gate | 2026-01-21 |
| PR-C04 | Backend: TODOs critiques résolus | 2026-01-21 |
| PR-C06 | Flutter: MockAuthRepository supprimé | 2026-01-21 |
| PR-C03a | Legal: Placeholders remplacés | 2026-01-21 |
| PR-C05 | Flutter: TODOs critiques résolus | 2026-01-21 |
| PR-C07 | Docs: DoD.md créé | 2026-01-21 |

---

## 🔮 Post-MVP (Hors DoD Actuelle)

Ces éléments sont **explicitement exclus** de la Definition of Done actuelle :

- Stripe Connect (paiement direct aux prestataires)
- Firebase Crashlytics intégration complète
- Firebase Analytics intégration complète
- Amplitude analytics
- Environnement staging dédié
- Monitoring Datadog/Sentry
- CDN pour media uploads
- Tests de charge
- Audit de sécurité externe

---

## 🏁 Final Gate

Quand tous les critères sont ✅ :

> **"WorkOn est TERMINÉE et PUBLIABLE MONDIALEMENT"**

Cette déclaration requiert une validation humaine explicite avant toute action de publication.

---

*Document généré automatiquement — Mode COMPLETE actif*

