# 🌟 S-Contact - QR Code Contact Sharing App

[![Flutter](https://img.shields.io/badge/Flutter-3.9+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Hacktoberfest](https://img.shields.io/badge/Hacktoberfest-2025-orange.svg)](https://hacktoberfest.com)
[![Open Source Love](https://img.shields.io/badge/Open%20Source-%E2%9D%A4-red.svg)](https://github.com/Rodrigue-k/s_contact)

<div align="center">
  <p><strong>Share your contact information instantly with beautiful QR codes! 📱✨</strong></p>
</div>

---

## 🚀 About S-Contact

S-Contact est une application Flutter open-source pour partager et enregistrer rapidement des contacts via QR code. Elle permet de créer une **carte de visite numérique** sous forme de QR code que d'autres peuvent scanner avec n'importe quelle application de lecture de QR code, sans serveur externe ni API compliquée.

L'application est **cross-platform (Android + iOS)**, compatible avec desktop à terme, et met l'accent sur la simplicité, la sécurité et la confidentialité : les données restent locales, sans permissions sensibles (pas d'accès caméra nécessaire).

**Nom du projet :** s_contact  
**Description :** Une application Flutter open-source pour partager et enregistrer rapidement des contacts via QR code.

---

## 💡 Pourquoi c’est une idée géniale

* ✅ **Aucune dépendance API** (pas besoin de clé Google ou Apple).
* ✅ **Compatible partout** (Android, iOS, voire plus tard desktop).
* ✅ **Sécurité et confidentialité maximales** : les données restent locales.
* ✅ **Simplicité UX** : créer son profil → générer QR code → partager.
* ✅ **Zéro permission sensible** (pas d'accès caméra nécessaire).

---

## ✨ Key Features

- 🎨 **Beautiful UI**: Modern, clean design with dark/light theme support.
- 📱 **Cross-platform**: Works on Android, iOS, Web, Windows, macOS, and Linux.
- 🔄 **Real-time Updates**: Instant profile synchronization.
- 📊 **QR Code Generation**: High-quality, customizable QR codes in vCard format.
- 🌍 **Internationalization Ready**: Prepared for multiple languages.
- 💾 **Local Storage**: All data stored securely on device.
- ⚡ **Fast & Responsive**: Optimized for smooth user experience.
- Créez votre carte de contact numérique.
- Générez votre QR code personnel en format vCard.
- Partagez votre QR code avec d'autres.
- Compatible Android & iOS.

---

## ⚙️ Fonctionnement général

### 1️⃣ Création du profil utilisateur

Au premier lancement :

* L’utilisateur remplit son profil : Nom, Téléphone, Email, Société (facultatif), Site web (facultatif).
* Ces données sont enregistrées **localement** (dans `SharedPreferences` ou `Hive`).

### 2️⃣ Génération du QR code

* L'app encode les données sous forme de **vCard (.vcf)** (format standard pour les contacts).
* Le QR code contient le texte complet du contact en format vCard, par exemple :

```
BEGIN:VCARD
VERSION:3.0
N:KOUDAKPO;Rodrigue;;;
TEL;TYPE=mobile:+22890123456
EMAIL:rodrigue@example.com
END:VCARD
```

* Ce QR code est affiché à l'écran (comme une "carte de visite numérique").

### 3️⃣ Partage du QR code

* D'autres personnes peuvent scanner le QR code avec n'importe quelle application de lecture de QR code.
* Le QR code génère automatiquement une vCard compatible avec tous les carnets d'adresses.

---

## 🧱 Stack technique

| Élément                          | Technologie / Package Flutter                        |
| :------------------------------- | :--------------------------------------------------- |
| Génération QR code               | `qr_flutter`                                         |
| Stockage local                   | `shared_preferences`                                 |
| Gestion d'état                   | `flutter_riverpod`                                   |
| Thèmes et design                 | `google_fonts` + Material Design                     |
| Format vCard                     | Implémentation maison                                |

**Tech Stack global :** Flutter, Dart, qr_flutter, flutter_riverpod, shared_preferences.

---

## 🧩 Architecture simple (MVP)

```
lib/
├── core/           # Core utilities and themes
├── data/           # Data sources and repositories (ex. local_storage.dart)
├── models/         # Data models (ex. contact_model.dart)
├── pages/          # UI screens (ex. home_page.dart, profile_page.dart, qr_view_page.dart)
├── providers/      # State management (ex. profile_provider.dart)
├── widgets/        # Reusable UI components
└── routes.dart     # Navigation configuration
```

* **main.dart** → point d'entrée, configuration Riverpod.
* **home_page.dart** → page principale avec formulaire ou QR code selon l'état.
* **profile_page.dart** → pour configurer et modifier les infos personnelles.
* **qr_view_page.dart** → affiche le QR code en plein écran.
* **routes.dart** → gestion de la navigation.
* **providers/** → gestion d'état avec Riverpod.

This project follows Clean Architecture principles:
- **Presentation Layer**: Pages and Widgets
- **Domain Layer**: Business logic and models
- **Data Layer**: Local storage and external services

**Key Components**:
- **Providers**: Riverpod for state management
- **Models**: Immutable data structures
- **Services**: Business logic operations
- **Repositories**: Data access abstraction

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.9+)
- Dart SDK (3.0+)
- Android Studio or VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Rodrigue-k/s_contact.git
   cd s_contact
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

```bash
# Android APK
flutter build apk

# iOS
flutter build ios

# Web
flutter build web

# Windows
flutter build windows

# macOS
flutter build macos

# Linux
flutter build linux
```

---

## 🚀 Évolution possible (v2+)

* Synchronisation facultative via Firebase (option cloud).
* Personnalisation du QR code (logo, couleur, style).
* Partage rapide via NFC ou lien universel.
* Intégration automatique à Google Contacts via OAuth (optionnel).
* Import/export CSV ou VCF multiple.

**Roadmap :**

* [x] Page profil utilisateur avec Riverpod
* [x] Génération QR code vCard
* [x] Interface adaptative (formulaire/QR selon état)
* [x] Design simple et responsive
* [ ] Partage du QR code (WhatsApp, etc.)
* [ ] Personnalisation du design du QR code

---

## 🤝 Contributing

We love contributions! This project is perfect for **Hacktoberfest** participants. Here's how you can help:

### 🚀 Quick Start for Contributors

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/amazing-feature`
3. **Make** your changes and test them
4. **Commit** your changes: `git commit -m 'Add amazing feature'`
5. **Push** to the branch: `git push origin feature/amazing-feature`
6. **Open** a Pull Request

### 📋 Contribution Guidelines

- Follow the existing code style and architecture
- Write clear, concise commit messages
- Add tests for new features
- Update documentation when necessary
- Be respectful and inclusive

---

## 🎯 Hacktoberfest Issues

Looking for ways to contribute? Check out these **Hacktoberfest-friendly** issues:

Voir les [issues labellisées](https://github.com/Rodrigue-k/s_contact/issues?q=is%3Aissue+is%3Aopen+label%3Ahacktoberfest)

### 🐛 Bug Fixes
- [ ] Fix responsive design issues on tablets
- [ ] Improve error handling in contact import
- [ ] Fix theme switching animation glitches

### ✨ Features
- [ ] Add contact export to PDF
- [ ] Implement contact backup/restore
- [ ] Add social media links support
- [ ] Create contact groups/categories
- [ ] Add contact search functionality

### 🎨 UI/UX Improvements
- [ ] Improve onboarding flow
- [ ] Add animations and transitions
- [ ] Enhance accessibility features
- [ ] Add more customization options

### 🧪 Testing & Quality
- [ ] Add unit tests for providers
- [ ] Add integration tests for QR generation
- [ ] Add widget tests for complex UI components
- [ ] Set up automated testing pipeline

### 📚 Documentation
- [ ] Add code documentation
- [ ] Create user guide
- [ ] Add API documentation
- [ ] Create developer setup guide

**Règles pour Hacktoberfest 2025** : PRs mergés ou labellisés "hacktoberfest-accepted" comptent. Gagnez des badges Holopin et un t-shirt pour 6 PRs mergés !

---

## 📱 Screenshots

Voici quelques aperçus de S-Contact en action, en modes clair et sombre :

| Page d'accueil (Clair) | Page d'accueil (Sombre) | QR Code (Clair) | QR Code (Sombre) |
|-----------------------|-------------------------|-----------------|------------------|
| ![Home Light](assets/home_light.png) | ![Home Dark](assets/home_dark.png) | ![QR Code Light](assets/QrCode_light.png) | ![QR Code Dark](assets/QrCode_dark.png) |

*Ajoutez vos propres screenshots pour de nouvelles fonctionnalités en soumettant une PR ! Consultez les [issues Hacktoberfest](https://github.com/Rodrigue-k/s_contact/issues?q=is%3Aissue+is%3Aopen+label%3Ahacktoberfest) pour contribuer.*
---

## 🐛 Found a Bug?

We appreciate bug reports! Please use the [issue tracker](https://github.com/Rodrigue-k/s_contact/issues) to report any bugs or request features.

**Bug Report Template:**
```markdown
## Bug Description
[Describe the bug clearly]

## Steps to Reproduce
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- OS: [Windows/Mac/Linux]
- Flutter Version: [3.9+]
- Device: [Physical/Simulator]
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Thanks to all contributors and the Flutter community
- Special thanks to Hacktoberfest for promoting open source!

---

<div align="center">

**Made with ❤️ for the Flutter community**

[⭐ Star this repo](https://github.com/Rodrigue-k/s_contact) | [🐛 Report Bug](https://github.com/Rodrigue-k/s_contact/issues) | [💡 Request Feature](https://github.com/Rodrigue-k/s_contact/issues)

</div>
