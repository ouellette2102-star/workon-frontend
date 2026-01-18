# WorkOn Flutter - Dette Technique

> **PR-F7** - Documentation pour cleanup post-release.

## 📋 Vue d'ensemble

Ce document liste les éléments de dette technique identifiés lors de l'audit PROMPT 3.
Ces éléments n'impactent PAS la fonctionnalité mais amélioreraient le professionnalisme du code.

**Priorité: POST-RELEASE** - Ne pas faire avant une release stable.

---

## 1. Debug Prints FlutterFlow

**Quantité:** 98 occurrences dans 57 fichiers

**Pattern:**
```dart
onPressed: () {
  print('IconButton pressed ...');
},
```

**Impact:** Console spam en mode debug, aucun impact utilisateur.

**Fix recommandé:**
```bash
# Rechercher tous les prints de debug FlutterFlow
grep -r "print('.*pressed" lib/ --include="*.dart"

# Remplacer par des no-ops ou supprimer
# Utiliser sed/regex pour un remplacement global
```

**Fichiers principaux concernés:**
- `lib/client_part/home/home_widget.dart` (4 occurrences)
- `lib/client_part/search/search_widget.dart` (9 occurrences)
- `lib/client_part/video_call/video_call_widget.dart` (5 occurrences)
- Et 54 autres fichiers...

---

## 2. Placeholders et Exemples

**Quantité:** ~61 occurrences hors traductions (272 dans internationalization.dart)

**Types:**
- `example.com` - URLs d'exemple
- `test@` - Emails de test
- `Lorem ipsum` - Textes placeholder
- `placeholder` - Labels génériques

**Fix recommandé:**
- Audit manuel fichier par fichier
- Remplacer par des textes FR réalistes
- Certains sont dans les traductions FlutterFlow (non modifiables facilement)

---

## 3. TODOs Acceptables

**Quantité:** 17 dans 8 fichiers

Ces TODOs sont documentés et intentionnels:
- `lib/services/push/push_api.dart` - Token refresh
- `lib/services/analytics/analytics_service.dart` - Events tracking
- `lib/services/auth/auth_repository.dart` - Edge cases

**Action:** Aucune - TODOs normaux pour projet actif.

---

## 4. Écrans "Coming Soon"

**Quantité:** 7 fichiers utilisent ComingSoonScreen

**Fichiers:**
- `job_item_upcoming_widget.dart`
- `job_item_menu_widget.dart`
- `job_item_in_progress_widget.dart`
- `menu_booking_item_widget.dart`
- `booking_item_upcoming_widget.dart`
- `chat_widget.dart`

**Status:** ✅ Déjà bien géré avec `ComingSoonScreen` professionnel.

---

## 5. Plan de Cleanup Post-Release

### Phase 1 (Semaine après release)
1. [ ] Supprimer tous les `print('... pressed ...')` 
2. [ ] Remplacer par `debugPrint` ou supprimer

### Phase 2 (Sprint suivant)
1. [ ] Audit des placeholders restants
2. [ ] Remplacement des exemples par textes FR réalistes
3. [ ] Nettoyage des imports inutilisés

### Phase 3 (Ongoing)
1. [ ] Traiter les TODOs selon priorité business
2. [ ] Monitoring des warnings Flutter analyze (7137 actuellement)

---

## 📊 Métriques Actuelles

| Métrique | Valeur | Cible Post-Cleanup |
|----------|--------|-------------------|
| Debug prints | 98 | 0 |
| Flutter analyze warnings | 7137 | < 100 |
| Unused imports | ~500 | < 50 |
| TODOs | 17 | < 10 |

---

*Dernière mise à jour: 2026-01-18*
*Généré par audit PROMPT 3*

