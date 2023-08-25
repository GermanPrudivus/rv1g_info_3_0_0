import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/settings_service.dart';

class EditUserController extends StateNotifier<AsyncValue<void>> {
  EditUserController({required this.settingService})
      : super(const AsyncData<void>(null));

  SettingsService settingService;

  Future<String?> updateProfilePicUrl(int id, String email, 
    String profilePicPath, String avatarUrl) async {
      
    state = const AsyncLoading<void>();
    final AsyncValue<String> asyncValue = await AsyncValue.guard<String>(() {
      return settingService.updateProfilePicUrl(id, email, profilePicPath, avatarUrl);
    });
    state = asyncValue;
    return asyncValue.value;
  }

  Future<void> updateUser(int id, String fullName, int formId, String newPassword) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return settingService.updateUser(id, fullName, formId, newPassword);
    });
  }
}

final editUserControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider<EditUserController, AsyncValue<void>>(
        (ref) {
  return EditUserController(
    settingService: ref.watch(settingsServiceProvider),
  );
});