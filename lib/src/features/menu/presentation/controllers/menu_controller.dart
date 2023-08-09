import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/menu_service.dart';
import '../../domain/models/menu.dart';

class MenuController extends StateNotifier<AsyncValue<void>> {
  MenuController({required this.menuService})
      : super(const AsyncData<void>(null));

  MenuService menuService;

  Future<void> updateMenu(String tag, String imagePath, String imageUrl) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return menuService.updateMenu(tag, imagePath, imageUrl);
    });
  }

  Future<Map<String, Menu>?> getMenu() async {
    state = const AsyncLoading<void>();
    final AsyncValue<Map<String, Menu>> asyncValue = await AsyncValue.guard<Map<String, Menu>>(() {
      return menuService.getMenu();
    });
    state = asyncValue;
    return asyncValue.value;
  }
}

final menuControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider<MenuController, AsyncValue<void>>(
        (ref) {
  return MenuController(
    menuService: ref.watch(menuServiceProvider),
  );
});