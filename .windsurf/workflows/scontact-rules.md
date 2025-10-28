---
description: 
auto_execution_mode: 1
---



### 🎯 Objectif précis

Créer une application **cross-platform (Android + iOS)** permettant de **partager ses coordonnées via un QR code**, sans serveur externe ni compte Google, **et sans API compliquée**.
L'application génère une **carte de visite numérique** sous forme de QR code que d'autres peuvent scanner avec n'importe quelle application de lecture de QR code.

---

## 💡 Pourquoi c’est une idée géniale

* ✅ **Aucune dépendance API** (pas besoin de clé Google ou Apple).
* ✅ **Compatible partout** (Android, iOS, voire plus tard desktop).
* ✅ **Sécurité et confidentialité maximales** : les données restent locales.
* ✅ **Simplicité UX** : créer son profil → générer QR code → partager.
* ✅ **Zéro permission sensible** (pas d'accès caméra nécessaire).

---

## ⚙️ Fonctionnement général

### 1️⃣ Création du profil utilisateur

Au premier lancement :

* L’utilisateur remplit son profil :
  Nom, Téléphone, Email, Société (facultatif), Site web (facultatif).
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

---

## 🧩 Architecture simple (MVP)

* **main.dart** → point d'entrée, configuration Riverpod.
* **home_page.dart** → page principale avec formulaire ou QR code selon l'état.
* **profile_page.dart** → pour configurer et modifier les infos personnelles.
* **qr_view_page.dart** → affiche le QR code en plein écran.
* **routes.dart** → gestion de la navigation.
* **providers/** → gestion d'état avec Riverpod.

---

## 🚀 Évolution possible (v2+)

* Synchronisation facultative via Firebase (option cloud).
* Personnalisation du QR code (logo, couleur, style).
* Partage rapide via NFC ou lien universel.
* Intégration automatique à Google Contacts via OAuth (optionnel).
* Import/export CSV ou VCF multiple.

---

## 🧾 README pour Hacktoberfest (draft)

**Nom du projet :** s_contact
**Description :**
Une application Flutter open-source pour partager et enregistrer rapidement des contacts via QR code

**Fonctionnalités :**

* Créez votre carte de contact numérique.
* Générez votre QR code personnel en format vCard.
* Partagez votre QR code avec d'autres.
* Compatible Android & iOS.

**Tech Stack :** Flutter, Dart, qr_flutter, flutter_riverpod, shared_preferences.

**Roadmap :**

* [x] Page profil utilisateur avec Riverpod
* [x] Génération QR code vCard
* [x] Interface adaptative (formulaire/QR selon état)
* [x] Design simple et responsive
* [ ] Partage du QR code (WhatsApp, etc.)
* [ ] Personnalisation du design du QR code

---

Souhaites-tu que je te génère directement le **README complet + le plan de structure du dossier Flutter** (avec le code d’exemple minimal pour chaque page) ?
Ça te ferait gagner du temps pour ton dépôt GitHub Hacktoberfest.
