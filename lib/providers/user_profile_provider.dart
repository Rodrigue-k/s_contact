import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:s_contact/data/local_storage.dart';
import 'package:s_contact/models/contact_model.dart';

// Provider pour l'état du profil utilisateur
final userProfileProvider = NotifierProvider<UserProfileNotifier, AsyncValue<ContactModel?>>(() {
  return UserProfileNotifier();
});

class UserProfileNotifier extends Notifier<AsyncValue<ContactModel?>> {
  @override
  AsyncValue<ContactModel?> build() {
    _loadProfile();
    return const AsyncValue.loading();
  }

  Future<void> _loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await LocalStorage.getUserProfile();
      state = AsyncValue.data(profile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<bool> saveProfile(ContactModel contact) async {
    state = const AsyncValue.loading();
    try {
      final success = await LocalStorage.saveUserProfile(contact);
      if (success) {
        state = AsyncValue.data(contact);
        return true;
      } else {
        state = AsyncValue.error('Erreur lors de la sauvegarde', StackTrace.current);
        return false;
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<bool> deleteProfile() async {
    state = const AsyncValue.loading();
    try {
      final success = await LocalStorage.deleteUserProfile();
      if (success) {
        state = const AsyncValue.data(null);
        return true;
      } else {
        state = AsyncValue.error('Erreur lors de la suppression', StackTrace.current);
        return false;
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }
}
