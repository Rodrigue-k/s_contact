import 'package:flutter/material.dart';
import 'package:s_contact/models/contact_model.dart';
import 'package:s_contact/pages/main_navigation_shell.dart';
import 'package:s_contact/pages/save_contact_page.dart';

class AppRoutes {
  // Noms des routes
  static const String home = '/';
  static const String saveContact = '/save-contact';

  // Générer les routes
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const MainNavigationShell());
      case saveContact:
        final contact = settings.arguments as ContactModel;
        return MaterialPageRoute(
          builder: (_) => SaveContactPage(contact: contact),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page non trouvée'))),
        );
    }
  }

  // Navigation helpers
  static void navigateToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(home, (route) => false);
  }

  static void navigateToSaveContact(
    BuildContext context,
    ContactModel contact,
  ) {
    Navigator.of(context).pushNamed(saveContact, arguments: contact);
  }

  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}
