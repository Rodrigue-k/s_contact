import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:s_contact/app.dart';
import 'package:s_contact/data/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser le stockage local
  await LocalStorage.init();

  runApp(const ProviderScope(child: App()));
}
