import 'package:flutter_test/flutter_test.dart';
import 'package:s_contact/models/contact_model.dart';

void main() {
  group('ContactModel', () {
    test('should create contact with required fields', () {
      final contact = ContactModel(
        name: 'John Doe',
        phone: '+1234567890',
        email: 'john.doe@example.com',
      );

      expect(contact.name, 'John Doe');
      expect(contact.phone, '+1234567890');
      expect(contact.email, 'john.doe@example.com');
    });

    test('should create contact from full name', () {
      final contact = ContactModel.fromFullName('John Doe Smith');

      expect(contact.name, 'John Doe Smith');
      expect(contact.firstName, 'John');
      expect(contact.lastName, 'Doe Smith');
    });

    test('should handle edge cases in name extraction', () {
      final contact1 = ContactModel.fromFullName('John');
      expect(contact1.firstName, 'John');
      expect(contact1.lastName, null);

      final contact2 = ContactModel.fromFullName('');
      expect(contact2.firstName, null);
      expect(contact2.lastName, null);
    });

    test('should convert to map correctly', () {
      final contact = ContactModel(
        id: '123',
        name: 'John Doe',
        phone: '+1234567890',
        email: 'john@example.com',
        company: 'Tech Corp',
      );

      final map = contact.toMap();

      expect(map['id'], '123');
      expect(map['name'], 'John Doe');
      expect(map['phone'], '+1234567890');
      expect(map['email'], 'john@example.com');
      expect(map['company'], 'Tech Corp');
    });

    test('should create from map correctly', () {
      final map = {
        'id': '123',
        'name': 'John Doe',
        'phone': '+1234567890',
        'email': 'john@example.com',
        'company': 'Tech Corp',
      };

      final contact = ContactModel.fromMap(map);

      expect(contact.id, '123');
      expect(contact.name, 'John Doe');
      expect(contact.phone, '+1234567890');
      expect(contact.email, 'john@example.com');
      expect(contact.company, 'Tech Corp');
    });

    test('should check essential info correctly', () {
      final contact1 = ContactModel(name: 'John Doe', phone: '+1234567890');
      expect(contact1.hasEssentialInfo(), true);

      final contact2 = ContactModel(name: 'John Doe', email: 'john@example.com');
      expect(contact2.hasEssentialInfo(), true);

      final contact3 = ContactModel(name: 'John Doe');
      expect(contact3.hasEssentialInfo(), false);

      final contact4 = ContactModel(name: '', phone: '+1234567890');
      expect(contact4.hasEssentialInfo(), false);
    });

    test('should get display name correctly', () {
      final contact1 = ContactModel(name: 'John Doe');
      expect(contact1.getDisplayName(), 'John Doe');

      final contact2 = ContactModel(
        name: '',
        firstName: 'John',
        lastName: 'Doe',
      );
      expect(contact2.getDisplayName(), 'John Doe');

      final contact3 = ContactModel(
        name: '',
        firstName: 'John',
      );
      expect(contact3.getDisplayName(), 'John');

      final contact4 = ContactModel(
        name: '',
        lastName: 'Doe',
      );
      expect(contact4.getDisplayName(), 'Doe');

      final contact5 = ContactModel(name: '');
      expect(contact5.getDisplayName(), '');
    });

    test('should copy with modifications', () {
      final contact = ContactModel(
        name: 'John Doe',
        phone: '+1234567890',
        email: 'john@example.com',
      );

      final copied = contact.copyWith(
        phone: '+0987654321',
        company: 'New Company',
      );

      expect(copied.name, 'John Doe');
      expect(copied.phone, '+0987654321');
      expect(copied.email, 'john@example.com');
      expect(copied.company, 'New Company');
    });

    test('should have correct string representation', () {
      final contact = ContactModel(
        name: 'John Doe',
        phone: '+1234567890',
        email: 'john@example.com',
      );

      expect(contact.toString(), contains('John Doe'));
      expect(contact.toString(), contains('+1234567890'));
      expect(contact.toString(), contains('john@example.com'));
    });
  });
}
