import 'package:flutter/material.dart';
import 'package:s_contact/core/theme.dart';
import 'package:s_contact/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'S Contact',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.generateRoute,

      // Configuration locale pour l'internationalisation
      localizationsDelegates: const [
        // DefaultMaterialLocalizations.delegate,
        // DefaultWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'), // Français
        Locale('en', 'US'), // Anglais
      ],

      // Builder pour gérer les contextes de navigation
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
