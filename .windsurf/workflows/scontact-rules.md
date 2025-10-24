---
description: 
auto_execution_mode: 1
---



### 🎯 Objectif précis

Créer une application **cross-platform (Android + iOS)** permettant à deux personnes d’échanger leurs coordonnées **en scannant un QR code**, sans serveur externe ni compte Google, **et sans API compliquée**.
L’application ne crée pas elle-même le contact dans Gmail ou autre, mais **ouvre la fiche contact pré-remplie** du système (Android/iOS) → l’utilisateur valide et choisit où enregistrer (Google, iCloud, SIM, etc.).

---

## 💡 Pourquoi c’est une idée géniale

* ✅ **Aucune dépendance API** (pas besoin de clé Google ou Apple).
* ✅ **Compatible partout** (Android, iOS, voire plus tard desktop).
* ✅ **Sécurité et confidentialité maximales** : les données restent locales.
* ✅ **Simplicité UX** : scanner → voir → “Ajouter contact”.
* ✅ **Zéro permission sensible** requise (sauf accès caméra).

---

## ⚙️ Fonctionnement général

### 1️⃣ Création du profil utilisateur

Au premier lancement :

* L’utilisateur remplit son profil :
  Nom, Téléphone, Email, Société (facultatif), Site web (facultatif).
* Ces données sont enregistrées **localement** (dans `SharedPreferences` ou `Hive`).

### 2️⃣ Génération du QR code

* L’app encode les données sous forme de **vCard (.vcf)** (format standard pour les contacts).
* Le QR code contient le texte complet du contact en format vCard, par exemple :

```
BEGIN:VCARD
VERSION:3.0
N:KOUDAKPO;Rodrigue;;;
TEL;TYPE=mobile:+22890123456
EMAIL:rodrigue@example.com
END:VCARD
```

* Ce QR code est affiché à l’écran (comme une “carte de visite numérique”).

### 3️⃣ Scan du QR code

* Une autre personne scanne le QR code avec ton application (ou n’importe quelle app de scan classique).
* L’app détecte que c’est une vCard, la parse et **propose d’ouvrir la fiche contact** du téléphone avec les champs pré-remplis.

### 4️⃣ Ajout du contact

* En appuyant sur “Enregistrer contact”, le système d’exploitation ouvre l’application “Contacts” native avec toutes les infos déjà remplies.
* L’utilisateur choisit où enregistrer le contact (Google, iCloud, SIM…).

💡 *Techniquement*, c’est possible avec un **Intent Android** (`Intent.ACTION_INSERT`) et un **URL Scheme iOS** (`CNContactViewController` ou `contacts://`).

---

## 🧱 Stack technique

| Élément                          | Technologie / Package Flutter                        |
| :------------------------------- | :--------------------------------------------------- |
| Génération QR code               | `qr_flutter`                                         |
| Scan QR code                     | `mobile_scanner`                                     |
| Stockage local                   | `shared_preferences`                                 |
| Gestion de contact (Android/iOS) | `url_launcher` + `flutter_contact` (ou Intent natif) |
| Format vCard                     | `vcard_serialize` (ou implémentation maison)         |

---

## 🧩 Architecture simple (MVP)

* **main.dart** → point d’entrée, navigation.
* **profile_page.dart** → pour configurer les infos personnelles.
* **my_qr_page.dart** → affiche le QR code de ton profil.
* **scan_page.dart** → permet de scanner le QR d’un autre.
* **contact_preview_page.dart** → affiche les infos scannées et bouton “Ajouter contact”.

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
* Scannez le QR d’un autre pour récupérer ses infos.
* Ouvrez la fiche contact pré-remplie en un clic.
* Compatible Android & iOS.

**Tech Stack :** Flutter, Dart, qr_flutter, mobile_scanner.

**Roadmap :**

* [ ] Page profil utilisateur
* [ ] Génération QR code vCard
* [ ] Scan QR code
* [ ] Prévisualisation contact
* [ ] Ouverture ajout contact
* [ ] Design simple et responsive

---

Souhaites-tu que je te génère directement le **README complet + le plan de structure du dossier Flutter** (avec le code d’exemple minimal pour chaque page) ?
Ça te ferait gagner du temps pour ton dépôt GitHub Hacktoberfest.
