import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:s_contact/models/contact_model.dart';

class LocalStorage {
  static const String _userProfileKey = 'user_profile';
  static const String _appSettingsKey = 'app_settings';

  // Clés pour les préférences
  static const String _themeModeKey = 'theme_mode';
  static const String _firstLaunchKey = 'first_launch';

  // Instance SharedPreferences
  static SharedPreferences? _preferences;

  // Initialiser SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Sauvegarder le profil utilisateur
  static Future<bool> saveUserProfile(ContactModel profile) async {
    try {
      if (_preferences == null) await init();

      final profileData = jsonEncode(profile.toMap());
      return await _preferences!.setString(_userProfileKey, profileData);
    } catch (e) {
      print('Erreur sauvegarde profil: $e');
      return false;
    }
  }

  // Récupérer le profil utilisateur
  static Future<ContactModel?> getUserProfile() async {
    try {
      if (_preferences == null) await init();

      final profileData = _preferences!.getString(_userProfileKey);
      if (profileData == null || profileData.isEmpty) {
        return null;
      }

      final Map<String, dynamic> map = jsonDecode(profileData);
      final contactMap = Map<String, String?>.from(map.map(
        (key, value) => MapEntry(key, value?.toString()),
      ));

      return ContactModel.fromMap(contactMap);
    } catch (e) {
      print('Erreur récupération profil: $e');
      return null;
    }
  }

  // Vérifier si un profil existe
  static Future<bool> hasUserProfile() async {
    try {
      if (_preferences == null) await init();

      final profileData = _preferences!.getString(_userProfileKey);
      return profileData != null && profileData.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Supprimer le profil utilisateur
  static Future<bool> deleteUserProfile() async {
    try {
      if (_preferences == null) await init();

      return await _preferences!.remove(_userProfileKey);
    } catch (e) {
      print('Erreur suppression profil: $e');
      return false;
    }
  }

  // Sauvegarder les paramètres de l'application
  static Future<bool> saveAppSettings(Map<String, dynamic> settings) async {
    try {
      if (_preferences == null) await init();

      final settingsData = jsonEncode(settings);
      return await _preferences!.setString(_appSettingsKey, settingsData);
    } catch (e) {
      print('Erreur sauvegarde paramètres: $e');
      return false;
    }
  }

  // Récupérer les paramètres de l'application
  static Future<Map<String, dynamic>> getAppSettings() async {
    try {
      if (_preferences == null) await init();

      final settingsData = _preferences!.getString(_appSettingsKey);
      if (settingsData == null || settingsData.isEmpty) {
        return {};
      }

      return jsonDecode(settingsData);
    } catch (e) {
      print('Erreur récupération paramètres: $e');
      return {};
    }
  }

  // Sauvegarder le mode thème
  static Future<bool> setThemeMode(String themeMode) async {
    try {
      if (_preferences == null) await init();

      return await _preferences!.setString(_themeModeKey, themeMode);
    } catch (e) {
      print('Erreur sauvegarde mode thème: $e');
      return false;
    }
  }

  // Récupérer le mode thème
  static Future<String?> getThemeMode() async {
    try {
      if (_preferences == null) await init();

      return _preferences!.getString(_themeModeKey);
    } catch (e) {
      print('Erreur récupération mode thème: $e');
      return null;
    }
  }

  // Vérifier si c'est le premier lancement
  static Future<bool> isFirstLaunch() async {
    try {
      if (_preferences == null) await init();

      final isFirst = _preferences!.getBool(_firstLaunchKey) ?? true;
      if (isFirst) {
        await _preferences!.setBool(_firstLaunchKey, false);
      }
      return isFirst;
    } catch (e) {
      return true;
    }
  }

  // Sauvegarder une valeur générique
  static Future<bool> setString(String key, String value) async {
    try {
      if (_preferences == null) await init();

      return await _preferences!.setString(key, value);
    } catch (e) {
      print('Erreur sauvegarde string: $e');
      return false;
    }
  }

  // Récupérer une valeur générique
  static Future<String?> getString(String key) async {
    try {
      if (_preferences == null) await init();

      return _preferences!.getString(key);
    } catch (e) {
      print('Erreur récupération string: $e');
      return null;
    }
  }

  // Supprimer une clé
  static Future<bool> remove(String key) async {
    try {
      if (_preferences == null) await init();

      return await _preferences!.remove(key);
    } catch (e) {
      print('Erreur suppression clé: $e');
      return false;
    }
  }

  // Vider tout le stockage
  static Future<bool> clearAll() async {
    try {
      if (_preferences == null) await init();

      return await _preferences!.clear();
    } catch (e) {
      print('Erreur vidage stockage: $e');
      return false;
    }
  }

  // Récupérer toutes les clés
  static Future<Set<String>> getAllKeys() async {
    try {
      if (_preferences == null) await init();

      return _preferences!.getKeys();
    } catch (e) {
      print('Erreur récupération clés: $e');
      return <String>{};
    }
  }
}
