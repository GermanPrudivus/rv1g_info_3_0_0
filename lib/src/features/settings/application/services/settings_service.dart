import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/settings_repository.dart';
import '../../domain/models/app_user.dart';


class SettingsService {
  SettingsService({
    required this.settingsRepository,
  });

  final SettingsRepository settingsRepository;

  Future<AppUser> getUser() async {
    return await settingsRepository.getUser();
  }

  Future<String> updateProfilePicUrl(int id, String email, String profilePicPath) async {
    return await settingsRepository.updateProfilePicUrl(id, email, profilePicPath);
  }

  Future<void> updateUser(int id, String fullName, int formId, String newPassword) async {
    await settingsRepository.updateUser(id, fullName, formId);
    if(newPassword.isNotEmpty){
      await settingsRepository.updatePassword(id, newPassword);
    }
  }

  /*Future<void> editUser(int itemId, String title, String shortText, 
    String price, String description, List imagesPath, List imagesUrls) async {
    
    return await shopRepository.editItem(
      itemId, title, shortText, price, description, imagesPath, imagesUrls
    );
  }

  Future<void> deleteUser(int id) async {
    return await shopRepository.deleteItem(id);
  }*/
}

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService(
    settingsRepository: ref.watch(settingsRepositoryProvider),
  );
});