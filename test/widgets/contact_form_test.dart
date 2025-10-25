import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:s_contact/models/contact_model.dart';
import 'package:s_contact/widgets/contact_form.dart';

void main() {
  group('ContactForm Widget', () {
    testWidgets('should display form fields correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ContactForm(
                onSave: (contact) async => true,
                title: 'Test Form',
              ),
            ),
          ),
        ),
      );

      // Check if title is displayed
      expect(find.text('Test Form'), findsOneWidget);

      // Check if form fields are present
      expect(find.byType(TextFormField), findsWidgets);

      // Check for specific labels
      expect(find.text('Nom complet'), findsOneWidget);
      expect(find.text('Prénom'), findsOneWidget);
      expect(find.text('Nom'), findsOneWidget);
      expect(find.text('Téléphone'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('should display initial contact data', (WidgetTester tester) async {
      final initialContact = ContactModel(
        name: 'John Doe',
        phone: '+1234567890',
        email: 'john@example.com',
        company: 'Test Company',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ContactForm(
                initialContact: initialContact,
                onSave: (contact) async => true,
                title: 'Edit Contact',
              ),
            ),
          ),
        ),
      );

      // Check if title is displayed
      expect(find.text('Edit Contact'), findsOneWidget);

      // Check if form is in edit mode (button text should be "Mettre à jour")
      expect(find.text('Mettre à jour'), findsOneWidget);
    });

    testWidgets('should show create mode by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ContactForm(
                onSave: (contact) async => true,
              ),
            ),
          ),
        ),
      );

      // Check if form is in create mode (button text should be "Créer le profil")
      expect(find.text('Créer le profil'), findsOneWidget);
    });
  });
}
