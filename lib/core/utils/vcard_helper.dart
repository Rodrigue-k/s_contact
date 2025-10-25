import 'package:s_contact/models/contact_model.dart';

class VCardHelper {
  // Générer une vCard à partir d'un ContactModel
  static String generateVCard(ContactModel contact) {
    final buffer = StringBuffer();

    // En-tête vCard
    buffer.writeln('BEGIN:VCARD');
    buffer.writeln('VERSION:3.0');

    // Nom et prénom
    if (contact.firstName != null && contact.firstName!.isNotEmpty) {
      buffer.writeln('N:${contact.lastName ?? ''};${contact.firstName};;;');
      buffer.writeln('FN:${contact.getDisplayName()}');
    } else if (contact.name.isNotEmpty) {
      buffer.writeln('FN:${contact.name}');
    }

    // Téléphone
    if (contact.phone != null && contact.phone!.isNotEmpty) {
      // Nettoyer le numéro de téléphone
      String cleanPhone = contact.phone!
          .replaceAll(RegExp(r'[^\d+\-\s()]'), '')
          .trim();

      // Détecter le type de téléphone
      String phoneType = 'CELL';
      if (cleanPhone.contains('+')) {
        phoneType = 'CELL';
      }

      buffer.writeln('TEL;TYPE=$phoneType:$cleanPhone');
    }

    // Email
    if (contact.email != null && contact.email!.isNotEmpty) {
      buffer.writeln('EMAIL;TYPE=INTERNET:${contact.email}');
    }

    // Entreprise
    if (contact.company != null && contact.company!.isNotEmpty) {
      buffer.writeln('ORG:${contact.company}');
    }

    // Titre professionnel
    if (contact.jobTitle != null && contact.jobTitle!.isNotEmpty) {
      buffer.writeln('TITLE:${contact.jobTitle}');
    }

    // Adresse
    if (contact.address != null && contact.address!.isNotEmpty) {
      buffer.writeln('ADR;TYPE=WORK:;;${contact.address};;;;');
    }

    // Site web
    if (contact.website != null && contact.website!.isNotEmpty) {
      buffer.writeln('URL:${contact.website}');
    }

    // Note
    if (contact.note != null && contact.note!.isNotEmpty) {
      buffer.writeln('NOTE:${contact.note}');
    }

    // Pied vCard
    buffer.writeln('END:VCARD');

    return buffer.toString();
  }

  // Parser une vCard et retourner un ContactModel
  static ContactModel? parseVCard(String vCardData) {
    try {
      final lines = vCardData.split('\n');
      ContactModel contact = ContactModel(name: '');

      String? currentValue;
      for (String line in lines) {
        line = line.trim();
        if (line.isEmpty) continue;

        // Gestion des lignes multi-lignes (commençant par un espace)
        if (line.startsWith(' ')) {
          if (currentValue != null) {
            currentValue += line.substring(1);
            continue;
          }
        }

        final parts = line.split(':');
        if (parts.length < 2) continue;

        final property = parts[0];
        currentValue = parts.sublist(1).join(':');

        switch (property.toUpperCase()) {
          case 'FN':
            // Nom complet
            contact.name = currentValue;
            break;
          case 'N':
            // Structure N: Nom;Prénom;;;
            final nameParts = currentValue.split(';');
            if (nameParts.length >= 2) {
              contact.lastName = nameParts[0].isNotEmpty ? nameParts[0] : null;
              contact.firstName = nameParts[1].isNotEmpty ? nameParts[1] : null;
            }
            break;
          case 'TEL':
            // Téléphone avec type (ex: TEL;TYPE=CELL:+33123456789)
            if (property.contains('CELL') || property.contains('MOBILE')) {
              contact.phone = _extractValue(currentValue);
            } else if (contact.phone == null || contact.phone!.isEmpty) {
              // Si pas de téléphone portable, prendre le premier disponible
              contact.phone = _extractValue(currentValue);
            }
            break;
          case 'EMAIL':
            if (property.contains('INTERNET')) {
              contact.email = _extractValue(currentValue);
            }
            break;
          case 'ORG':
            contact.company = _extractValue(currentValue);
            break;
          case 'TITLE':
            contact.jobTitle = _extractValue(currentValue);
            break;
          case 'ADR':
            // Adresse (format: ADR;TYPE=WORK:;;Rue Ville;;Code postal;Pays)
            final addrParts = currentValue.split(';');
            if (addrParts.length >= 3) {
              final street = addrParts[2].isNotEmpty ? addrParts[2] : '';
              final city = addrParts[3].isNotEmpty ? addrParts[3] : '';
              final postalCode = addrParts[5].isNotEmpty ? addrParts[5] : '';
              final country = addrParts[6].isNotEmpty ? addrParts[6] : '';

              final addressParts = [street, city, postalCode, country]
                  .where((part) => part.isNotEmpty)
                  .toList();

              if (addressParts.isNotEmpty) {
                contact.address = addressParts.join(', ');
              }
            }
            break;
          case 'URL':
            contact.website = _extractValue(currentValue);
            break;
          case 'NOTE':
            contact.note = _extractValue(currentValue);
            break;
        }
      }

      // Si on n'a pas de nom, utiliser une valeur par défaut
      if (contact.name.isEmpty) {
        contact.name = contact.getDisplayName();
      }

      return contact.hasEssentialInfo() ? contact : null;
    } catch (e) {
      print('Erreur lors du parsing vCard: $e');
      return null;
    }
  }

  // Extraire la valeur d'une propriété vCard (supprimer les paramètres)
  static String _extractValue(String value) {
    // Supprimer les paramètres de type (ex: TYPE=CELL)
    return value.split(';').first;
  }

  // Générer un QR code data pour un contact (format simple pour compatibilité)
  static String generateQRData(ContactModel contact) {
    final vCard = generateVCard(contact);
    return vCard;
  }

  // Parser les données d'un QR code
  static ContactModel? parseQRData(String qrData) {
    // Essayer de parser comme vCard
    final contact = parseVCard(qrData);
    if (contact != null) {
      return contact;
    }

    // Si échec, essayer de parser comme format simple (nom:phone:email)
    return _parseSimpleFormat(qrData);
  }

  // Parser un format simple (nom:phone:email)
  static ContactModel? _parseSimpleFormat(String data) {
    try {
      final parts = data.split(':');
      if (parts.length >= 2) {
        return ContactModel(
          name: parts[0].trim(),
          phone: parts[1].trim(),
          email: parts.length > 2 ? parts[2].trim() : null,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Valider si une string est une vCard
  static bool isVCard(String data) {
    return data.contains('BEGIN:VCARD') && data.contains('END:VCARD');
  }
}
