import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:s_contact/app.dart';
import 'package:s_contact/data/local_storage.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialiser le stockage local
  await LocalStorage.init();

  // Remove splash screen after initialization is complete
  FlutterNativeSplash.remove();

  runApp(const ProviderScope(child: App()));
}