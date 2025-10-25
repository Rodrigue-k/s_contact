import 'package:flutter/material.dart';
import 'package:s_contact/pages/home_page.dart';
import 'package:s_contact/pages/profile_page.dart';

class AppRoutes {
  // Noms des routes
  static const String home = '/';
  static const String profile = '/profile';

  // Générer les routes
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page non trouvée'),
            ),
          ),
        );
    }
  }

  // Navigation helpers
  static void navigateToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(home, (route) => false);
  }

  static void navigateToProfile(BuildContext context) {
    Navigator.of(context).pushNamed(profile);
  }

  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}
