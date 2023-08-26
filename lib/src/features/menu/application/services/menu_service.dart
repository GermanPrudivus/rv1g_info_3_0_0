import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rv1g_info/src/constants/const.dart';

import '../../data/repositories/menu_repository.dart';
import '../../domain/models/menu.dart';

class MenuService {
  MenuService({
    required this.menuRepository,
  });

  final MenuRepository menuRepository;

  Future<void> updateMenu(String tag, String imagePath, String imageUrl) async{
    if(imageUrl != noMenu && imagePath == ""){
      await menuRepository.deleteMenu(tag, imageUrl);
    } else if(imageUrl == noMenu && imagePath != ""){
      await menuRepository.addMenu(tag, imagePath);
    } else if(imageUrl != noMenu && imagePath != ""){
      await menuRepository.updateMenu(tag, imagePath, imageUrl);
    }
  }

  Future<Map<String, Menu>> getMenu() async{
    return await menuRepository.getMenu();
  }
}

final menuServiceProvider = Provider<MenuService>((ref) {
  return MenuService(
    menuRepository: ref.watch(menuRepositoryProvider),
  );
});