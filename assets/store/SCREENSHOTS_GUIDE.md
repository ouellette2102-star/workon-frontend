# WorkOn Store Screenshots Guide

## 📐 Spécifications Requises

### iOS App Store (App Store Connect)

| Device | Résolution | Requis |
|--------|------------|--------|
| iPhone 6.7" | 1290 × 2796 | ✅ Obligatoire |
| iPhone 6.5" | 1284 × 2778 | ✅ Obligatoire |
| iPhone 5.5" | 1242 × 2208 | Optionnel |
| iPad Pro 12.9" | 2048 × 2732 | Si iPad supporté |

**Format**: PNG ou JPEG, 72 dpi, sRGB
**Quantité**: 2-10 par device (recommandé: 6)

### Google Play Store

| Type | Résolution | Requis |
|------|------------|--------|
| Phone | 1080 × 1920 min | ✅ Obligatoire (2-8) |
| Tablet 7" | 1080 × 1920 | Optionnel |
| Tablet 10" | 1920 × 1200 | Optionnel |

**Format**: PNG ou JPEG, 24-bit, pas d'alpha
**Quantité**: 2-8 par type

---

## 🎬 Écrans à Capturer (Dans l'ordre)

### Screenshot 1: **Découverte Swipe** (Hero)
- **Page**: SwipeDiscoveryPage
- **Contenu**: Carte mission avec photo, prix, swipe indicators
- **Message**: "Découvre des missions près de toi"
- **Pourquoi**: Premier impact, montre le UX innovant

### Screenshot 2: **Home Dashboard**
- **Page**: HomeWidget
- **Contenu**: Header WorkOn, liste missions, BottomNav
- **Message**: "Gère tes missions facilement"
- **Pourquoi**: Vue d'ensemble de l'app

### Screenshot 3: **Carte Interactive**
- **Page**: MapDiscoveryPage
- **Contenu**: Carte Google Maps avec pins rouges
- **Message**: "Trouve des missions autour de toi"
- **Pourquoi**: Montre la géolocalisation

### Screenshot 4: **Profil Travailleur**
- **Page**: ProviderPublicProfile
- **Contenu**: Photo, évaluations, services offerts
- **Message**: "Consulte les profils vérifiés"
- **Pourquoi**: Trust & safety

### Screenshot 5: **Messages**
- **Page**: MessagesWidget / ChatWidget
- **Contenu**: Conversation avec travailleur
- **Message**: "Communique directement"
- **Pourquoi**: Montre l'interaction

### Screenshot 6: **Paiement Sécurisé**
- **Page**: PaymentReceiptScreen ou Stripe sheet
- **Contenu**: Récapitulatif paiement
- **Message**: "Paiements sécurisés via Stripe"
- **Pourquoi**: Confiance financière

---

## 🎨 Style des Screenshots

### Option A: Screenshots Bruts (Rapide)
- Capture directe de l'émulateur
- Pas de cadre device
- Simple et authentique

### Option B: Device Frames (Recommandé)
- Screenshots dans un cadre iPhone/Android
- Background gradient WorkOn
- Texte marketing au-dessus

### Palette pour backgrounds:
```
Gradient: #0D0D0F → #1A1A1E (vertical)
Accent: #E53935 (WorkOn Red)
Text: #FFFFFF
```

---

## 📱 Comment Capturer

### iOS Simulator (Mac requis)
```bash
# Lancer le simulateur iPhone 14 Pro Max
flutter run -d "iPhone 14 Pro Max"

# Capturer (Cmd+S dans Simulator)
# Ou: xcrun simctl io booted screenshot screenshot.png
```

### Android Emulator
```bash
# Lancer l'émulateur Pixel 7
flutter run -d "Pixel 7"

# Capturer: Ctrl+S dans emulator
# Ou: adb exec-out screencap -p > screenshot.png
```

### Windows (Chrome Debug)
```bash
flutter run -d chrome --web-renderer html

# F12 → Toggle device toolbar → iPhone 14 Pro Max
# Capture avec extension ou Snipping Tool
```

---

## 📋 Checklist Screenshots

### iOS
- [ ] Screenshot 1: Swipe Discovery (1290×2796)
- [ ] Screenshot 2: Home Dashboard (1290×2796)
- [ ] Screenshot 3: Map View (1290×2796)
- [ ] Screenshot 4: Worker Profile (1290×2796)
- [ ] Screenshot 5: Messages (1290×2796)
- [ ] Screenshot 6: Payment (1290×2796)

### Android
- [ ] Screenshot 1: Swipe Discovery (1080×1920+)
- [ ] Screenshot 2: Home Dashboard (1080×1920+)
- [ ] Screenshot 3: Map View (1080×1920+)
- [ ] Screenshot 4: Worker Profile (1080×1920+)
- [ ] Screenshot 5: Messages (1080×1920+)
- [ ] Screenshot 6: Payment (1080×1920+)

---

## 🛠️ Outils Recommandés

1. **Figma** - Ajouter device frames et texte
2. **Previewed.app** - Mockups automatiques
3. **AppMockUp** - Templates gratuits
4. **Rotato** - Animations 3D (optionnel)

---

## 📁 Structure de sortie

```
assets/store/
├── ios/
│   ├── 6.7/
│   │   ├── 01_swipe.png
│   │   ├── 02_home.png
│   │   ├── 03_map.png
│   │   ├── 04_profile.png
│   │   ├── 05_messages.png
│   │   └── 06_payment.png
│   └── 6.5/
│       └── (same files)
├── android/
│   └── phone/
│       ├── 01_swipe.png
│       └── ...
└── SCREENSHOTS_GUIDE.md
```

---

**WorkOn** © 2026 - Montréal, QC
