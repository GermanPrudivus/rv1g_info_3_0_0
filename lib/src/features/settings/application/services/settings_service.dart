import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/settings_repository.dart';
import '../../domain/models/app_user.dart';
import '../../domain/models/role.dart';

class SettingsService {
  SettingsService({
    required this.settingsRepository,
  });

  final SettingsRepository settingsRepository;

  Future<AppUser> getUser() async {
    return await settingsRepository.getUser();
  }

  Future<String> updateProfilePicUrl(int id, String email, 
    String profilePicPath, String avatarUrl) async {

    await settingsRepository.deleteImage(avatarUrl, 'avatars');
    return await settingsRepository.updateProfilePicUrl(id, email, profilePicPath);
  }

  Future<void> updateUser(int id, String fullName, int formId, String newPassword) async {
    await settingsRepository.updateUser(id, fullName, formId);
    if(newPassword.isNotEmpty){
      await settingsRepository.updatePassword(id, newPassword);
    }
  }

  Future<List<Role>> getUserRoles(int id) async {
    return await settingsRepository.getUserRoles(id);
  }

  Future<void> logout() async {
    return await settingsRepository.logout();
  }

  Future<void> deleteUser(String avatarUrl) async {
    if(avatarUrl == ""){
      await settingsRepository.deleteImage(avatarUrl, 'avatars');
    }
    await settingsRepository.deleteUser();
  }
}

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService(
    settingsRepository: ref.watch(settingsRepositoryProvider),
  );
});