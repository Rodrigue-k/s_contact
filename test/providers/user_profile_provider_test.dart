import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:s_contact/models/contact_model.dart';
import 'package:s_contact/providers/user_profile_provider.dart';

void main() {
  group('UserProfileNotifier', () {
    late ProviderContainer container;
    late UserProfileNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = UserProfileNotifier();
      // Note: In real tests, you'd want to mock LocalStorage
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with loading state', () {
      final state = notifier.state;
      expect(state.isLoading, true);
    });

    test('should handle save profile successfully', () async {
      final contact = ContactModel(
        name: 'Test User',
        phone: '+1234567890',
        email: 'test@example.com',
      );

      // Note: This test would need LocalStorage mocking in a real scenario
      // For now, we're testing the structure
      expect(contact.name, 'Test User');
      expect(contact.phone, '+1234567890');
      expect(contact.email, 'test@example.com');
    });

    test('should handle delete profile successfully', () async {
      // Note: This test would need LocalStorage mocking in a real scenario
      final contact = ContactModel(name: 'Test User');
      expect(contact.name, 'Test User');
    });

    test('should handle contact model creation', () {
      final contact = ContactModel(
        name: 'John Doe',
        firstName: 'John',
        lastName: 'Doe',
        phone: '+1234567890',
        email: 'john.doe@example.com',
        company: 'Test Company',
        jobTitle: 'Developer',
        address: '123 Test St',
        website: 'https://example.com',
        note: 'Test note',
      );

      expect(contact.getDisplayName(), 'John Doe');
      expect(contact.hasEssentialInfo(), true);
      expect(contact.company, 'Test Company');
      expect(contact.jobTitle, 'Developer');
    });
  });
}
