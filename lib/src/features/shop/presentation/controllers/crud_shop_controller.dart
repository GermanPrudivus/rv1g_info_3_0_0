import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/shop_services.dart';

class CrudShopController extends StateNotifier<AsyncValue<void>> {
  CrudShopController({required this.shopService})
      : super(const AsyncData<void>(null));

  ShopService shopService;

  Future<void> addItem(String title, String shortText, 
    String price, String description, List imagesPath) async {

    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return shopService.addItem(title, shortText, price, description, imagesPath);
    });
  }

  Future<void> editItem(int itemId, String title, String shortText, 
    String price, String description, List imagesPath, List imagesUrls) async {

    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return shopService.editItem(
        itemId, title, shortText, price, description, imagesPath, imagesUrls
      );
    });
  }

  Future<void> deleteItem(int id) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return shopService.deleteItem(id);
    });
  }

  Future<void> deleteImage(int id, List images, String imageUrl) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return shopService.deleteImage(id, images, imageUrl);
    });
  }
}

final crudShopControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider.autoDispose<CrudShopController, AsyncValue<void>>(
        (ref) {
  return CrudShopController(
    shopService: ref.watch(shopServiceProvider),
  );
});