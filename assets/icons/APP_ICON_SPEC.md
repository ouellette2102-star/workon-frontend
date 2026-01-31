# WorkOn App Icon Specifications

## 🎨 Design Concept

**Icône principale**: Téléphone rouge sur fond noir avec effet glow premium.

### Éléments visuels
- **Fond**: Gradient noir (#0D0D0F → #1A1A1E)
- **Icône**: Téléphone "in talk" avec ondes sonores
- **Couleur accent**: Rouge WorkOn (#E53935 → #FF6659)
- **Glow**: Subtil halo rouge derrière l'icône
- **Pin**: Petit point rouge en bas à droite (signature brand)

## 📐 Tailles Requises

### iOS (App Store Connect)
| Taille | Usage |
|--------|-------|
| 1024×1024 | App Store (obligatoire) |
| 180×180 | iPhone @3x |
| 120×120 | iPhone @2x |
| 167×167 | iPad Pro |
| 152×152 | iPad |
| 76×76 | iPad @1x |
| 40×40 | Spotlight |
| 29×29 | Settings |
| 20×20 | Notification |

### Android (Google Play Console)
| Taille | Usage |
|--------|-------|
| 512×512 | Play Store (obligatoire) |
| 192×192 | xxxhdpi |
| 144×144 | xxhdpi |
| 96×96 | xhdpi |
| 72×72 | hdpi |
| 48×48 | mdpi |

### Android Adaptive Icon
- **Foreground**: 432×432 (icône téléphone)
- **Background**: 432×432 (noir solid ou gradient)
- **Safe zone**: 66dp cercle central

## 🛠️ Génération des Icônes

### Option 1: flutter_launcher_icons (Recommandé)

1. Ajouter au `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icons/app_icon_1024.png"
  adaptive_icon_background: "#0D0D0F"
  adaptive_icon_foreground: "assets/icons/app_icon_foreground.png"
```

2. Exécuter:
```bash
flutter pub get
dart run flutter_launcher_icons
```

### Option 2: Conversion manuelle

1. Ouvrir `app_icon.svg` dans Figma/Illustrator
2. Exporter en PNG 1024×1024
3. Utiliser https://appicon.co/ pour générer toutes les tailles

## 📋 Checklist Export

- [ ] PNG 1024×1024 (iOS App Store)
- [ ] PNG 512×512 (Android Play Store)
- [ ] PNG tous formats iOS (via flutter_launcher_icons)
- [ ] PNG tous formats Android (via flutter_launcher_icons)
- [ ] Adaptive icon foreground (Android 8+)
- [ ] Pas de transparence (requis iOS)
- [ ] Coins arrondis auto (iOS applique le masque)

## 🎯 Guidelines Apple/Google

### iOS
- Pas d'alpha/transparence
- Pas de coins arrondis (appliqués auto)
- Pas de texte (illisible à petite taille)
- Simple et reconnaissable

### Android
- Adaptive icons pour Android 8+
- Safe zone de 66dp respectée
- Pas de texte
- Contraste suffisant

## 📁 Structure des fichiers

```
assets/icons/
├── app_icon.svg              # Source vectorielle
├── app_icon_1024.png         # iOS App Store
├── app_icon_512.png          # Android Play Store
├── app_icon_foreground.png   # Android adaptive
└── APP_ICON_SPEC.md          # Ce fichier
```

---
**WorkOn** © 2026 - Montréal, QC
