# 🚀 WorkOn — Guide de Soumission App Store & Google Play

## 📋 Pré-requis Checklist

### ✅ Avant de commencer
- [ ] Compte Apple Developer ($99/an)
- [ ] Compte Google Play Console ($25 une fois)
- [ ] App icons exportés en PNG (1024×1024 et 512×512)
- [ ] Screenshots capturés (6 par plateforme)
- [ ] Feature Graphic Android (1024×500)
- [ ] Compte test créé (`review@workon.app` / `WorkOn2026!`)
- [ ] Backend déployé et fonctionnel

---

## 🍎 PARTIE 1 : Apple App Store

### Étape 1.1 — Build iOS

```bash
# Dans le dossier Flutter
cd C:\Users\ouell\Downloads\work_on_v1\work_on_v1

# Nettoyer et rebuilder
flutter clean
flutter pub get

# Build iOS (nécessite macOS avec Xcode)
flutter build ios --release
```

### Étape 1.2 — Xcode Configuration

1. **Ouvrir le projet iOS**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Configurer Signing**
   - Target → Runner → Signing & Capabilities
   - Team: Votre compte Apple Developer
   - Bundle Identifier: `com.workon.app`

3. **Vérifier Info.plist**
   - `CFBundleDisplayName`: WorkOn
   - `CFBundleShortVersionString`: 1.0.0
   - `CFBundleVersion`: 1

4. **Permissions (déjà configurées)**
   - NSLocationWhenInUseUsageDescription ✓
   - NSCameraUsageDescription ✓
   - NSPhotoLibraryUsageDescription ✓

### Étape 1.3 — Archive et Upload

1. **Product → Archive** dans Xcode
2. **Distribute App → App Store Connect**
3. Attendre le traitement (~30 min)

### Étape 1.4 — App Store Connect

**URL**: https://appstoreconnect.apple.com

#### 1.4.1 — Informations de l'app

| Champ | Valeur |
|-------|--------|
| **Nom** | WorkOn |
| **Sous-titre** | Trouve des missions près de toi |
| **Catégorie principale** | Productivité |
| **Catégorie secondaire** | Style de vie |
| **Âge** | 4+ |

#### 1.4.2 — Description (FR)

```
WorkOn connecte les travailleurs indépendants avec des employeurs locaux pour des missions ponctuelles.

🔍 DÉCOUVRE
• Swipe pour découvrir des missions près de toi
• Carte interactive avec géolocalisation
• Filtres par catégorie et prix

💼 TRAVAILLE
• Postule en un clic
• Communique directement avec l'employeur
• Gère ton emploi du temps

💰 GAGNE
• Paiements sécurisés via Stripe
• Suivi de tes gains en temps réel
• Retraits rapides

📍 Disponible à Montréal, Laval et environs.

WorkOn - Travaille où tu veux, quand tu veux.
```

#### 1.4.3 — Mots-clés (100 caractères max)

```
mission,travail,gig,freelance,emploi,local,montreal,menage,demenagement,bricolage
```

#### 1.4.4 — Screenshots

Uploader dans l'ordre:
1. `01_swipe.png` - Découverte
2. `02_home.png` - Dashboard
3. `03_map.png` - Carte
4. `04_profile.png` - Profil
5. `05_messages.png` - Messages
6. `06_payment.png` - Paiement

#### 1.4.5 — Informations de Review

| Champ | Valeur |
|-------|--------|
| **Prénom** | App |
| **Nom** | Reviewer |
| **Email** | review@workon.app |
| **Téléphone** | +1 514 555 0199 |
| **Email démo** | review@workon.app |
| **Mot de passe** | WorkOn2026! |
| **Notes** | L'app nécessite une connexion internet. Le compte de test a accès à 5 missions de démonstration dans la région de Montréal. |

#### 1.4.6 — Informations légales

- **URL Politique de confidentialité**: https://workon.app/privacy
- **URL Conditions d'utilisation**: https://workon.app/terms
- **URL Support**: https://workon.app/support

#### 1.4.7 — Soumettre

1. Cliquer "Soumettre pour examen"
2. Répondre aux questions de conformité:
   - Cryptographie: Oui (HTTPS)
   - IDFA: Non
   - Contenu tiers: Non

**⏱️ Délai estimé**: 24-48h pour la première review

---

## 🤖 PARTIE 2 : Google Play Store

### Étape 2.1 — Build Android

```bash
# Dans le dossier Flutter
cd C:\Users\ouell\Downloads\work_on_v1\work_on_v1

# Nettoyer
flutter clean
flutter pub get

# Build App Bundle (requis par Google)
flutter build appbundle --release
```

Le fichier sera généré dans:
```
build/app/outputs/bundle/release/app-release.aab
```

### Étape 2.2 — Signature de l'App

#### Option A: Google Play App Signing (Recommandé)

Google gère automatiquement la signature. Vous uploadez juste l'AAB.

#### Option B: Signature manuelle

```bash
# Créer un keystore (une seule fois)
keytool -genkey -v -keystore workon-release.keystore -alias workon -keyalg RSA -keysize 2048 -validity 10000

# Configurer dans android/key.properties
storePassword=<password>
keyPassword=<password>
keyAlias=workon
storeFile=../workon-release.keystore
```

### Étape 2.3 — Google Play Console

**URL**: https://play.google.com/console

#### 2.3.1 — Créer l'application

1. **Toutes les applications → Créer une application**
2. Nom: **WorkOn**
3. Langue par défaut: **Français (Canada)**
4. Type: **Application**
5. Gratuit/Payant: **Gratuit**

#### 2.3.2 — Tableau de bord de configuration

Compléter toutes les sections:

**📱 Détails de l'application**

| Champ | Valeur |
|-------|--------|
| **Titre** | WorkOn - Missions locales |
| **Description courte** (80 car.) | Trouve des missions près de toi. Swipe, postule, gagne! |
| **Description complète** | (Même que iOS) |

**🏷️ Catégorisation**

| Champ | Valeur |
|-------|--------|
| **Catégorie** | Productivité |
| **Email de contact** | support@workon.app |
| **Site web** | https://workon.app |
| **Politique de confidentialité** | https://workon.app/privacy |

**🖼️ Éléments graphiques**

| Asset | Spécification | Fichier |
|-------|---------------|---------|
| Icône | 512×512 PNG | `app_icon_512.png` |
| Feature Graphic | 1024×500 PNG/JPG | `feature_graphic.png` |
| Screenshots | 1080×1920+ | `android/phone/*.png` |

#### 2.3.3 — Questionnaire sur le contenu

Réponses typiques pour WorkOn:

| Question | Réponse |
|----------|---------|
| Violence | Non |
| Contenu sexuel | Non |
| Langage vulgaire | Non |
| Substances | Non |
| Jeux d'argent | Non |
| Contenu généré par utilisateurs | Oui (messages) |
| Partage de localisation | Oui |
| Achats intégrés | Non |
| Publicités | Non |

**Classification résultante**: PEGI 3 / Everyone

#### 2.3.4 — Déclarations de confidentialité

**Section Sécurité des données**:

| Type de données | Collecté | Partagé | Obligatoire |
|-----------------|----------|---------|-------------|
| Nom | Oui | Non | Oui |
| Email | Oui | Non | Oui |
| Téléphone | Oui | Non | Oui |
| Localisation approximative | Oui | Non | Oui |
| Localisation précise | Oui | Non | Non |
| Photos | Oui | Non | Non |

#### 2.3.5 — Test interne / Compte de test

1. **Tests → Test interne**
2. Créer une release de test
3. Ajouter testeurs: votre email + `review@workon.app`

**Pour les reviewers Google**:
- Aller dans **Présence sur le Play Store → Page de fiche principale**
- Section **Coordonnées de l'application**
- Ajouter les identifiants de test

#### 2.3.6 — Publier en Production

1. **Production → Créer une release**
2. Uploader `app-release.aab`
3. Notes de version:
   ```
   Version 1.0.0
   
   🎉 Première version de WorkOn!
   
   • Découverte de missions avec swipe
   • Carte interactive
   • Messagerie intégrée
   • Paiements sécurisés Stripe
   ```
4. **Examiner la release**
5. **Démarrer le déploiement vers Production**

**⏱️ Délai estimé**: 1-7 jours pour la première review

---

## 📊 CHECKLIST FINALE

### App Store (iOS)
- [ ] Archive créée dans Xcode
- [ ] Build uploadé via Transporter/Xcode
- [ ] Métadonnées complétées
- [ ] Screenshots uploadés (6.7" et 6.5")
- [ ] Informations de review ajoutées
- [ ] URLs légales vérifiées
- [ ] Soumis pour review

### Google Play (Android)
- [ ] AAB généré et signé
- [ ] App créée dans la console
- [ ] Questionnaire contenu complété
- [ ] Déclaration confidentialité remplie
- [ ] Feature graphic uploadé
- [ ] Screenshots uploadés
- [ ] Release de production créée
- [ ] Déploiement lancé

---

## ⚠️ Erreurs Courantes et Solutions

### iOS

| Erreur | Solution |
|--------|----------|
| "Missing compliance" | Répondre aux questions cryptographie |
| "Invalid binary" | Vérifier les architectures (arm64) |
| "Missing icons" | Régénérer avec flutter_launcher_icons |
| "Rejected - Demo" | Vérifier que le compte test fonctionne |

### Android

| Erreur | Solution |
|--------|----------|
| "Deobfuscation" | Uploader le fichier mapping.txt |
| "Target API level" | Mettre à jour targetSdkVersion (34+) |
| "64-bit" | Vérifier ndk.abiFilters dans build.gradle |
| "Screenshots" | Min 2, format 16:9 ou 9:16 |

---

## 📞 Support

- **Apple Developer**: https://developer.apple.com/support/
- **Google Play Console**: https://support.google.com/googleplay/android-developer

---

**WorkOn** © 2026 - Montréal, QC

*Guide créé le 31 janvier 2026*
