import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/settings_service.dart';
import '../../domain/models/app_user.dart';

class SettingsController extends StateNotifier<AsyncValue<void>> {
  SettingsController({required this.settingService})
      : super(const AsyncData<void>(null));

  SettingsService settingService;

  Future<AppUser?> getUser() async {
    state = const AsyncLoading<void>();
    final AsyncValue<AppUser> asyncValue = await AsyncValue.guard<AppUser>(() {
      return settingService.getUser();
    });
    state = asyncValue;
    return asyncValue.value;
  }
}

final settingsControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider<SettingsController, AsyncValue<void>>(
        (ref) {
  return SettingsController(
    settingService: ref.watch(settingsServiceProvider),
  );
});