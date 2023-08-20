import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/shop_services.dart';
import '../../domain/models/item.dart';

class ShopController extends StateNotifier<AsyncValue<void>> {
  ShopController({required this.shopService})
      : super(const AsyncData<void>(null));

  ShopService shopService;

  Future<List<Item>?> getItems() async {
    state = const AsyncLoading<void>();
    final AsyncValue<List<Item>> asyncValue = await AsyncValue.guard<List<Item>>(() {
      return shopService.getItems();
    });
    state = asyncValue;
    return asyncValue.value;
  }

  Future<List<String>?> getUser() async {
    state = const AsyncLoading<void>();
    final AsyncValue<List<String>> asyncValue = await AsyncValue.guard<List<String>>(() {
      return shopService.getUser();
    });
    state = asyncValue;
    return asyncValue.value;
  }
}

final shopControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider<ShopController, AsyncValue<void>>(
        (ref) {
  return ShopController(
    shopService: ref.watch(shopServiceProvider),
  );
});