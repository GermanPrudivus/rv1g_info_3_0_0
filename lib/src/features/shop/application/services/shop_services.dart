import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rv1g_info/src/features/shop/presentation/widgets/shop_page.dart';

import '../../data/repositories/shop_repository.dart';
import '../../domain/models/item.dart';

class ShopService {
  ShopService({
    required this.shopRepository,
  });

  final ShopRepository shopRepository;

  Future<void> addItem(String title, String shortText, 
    String price, String description, List imagesPath) async {
    
    return await shopRepository.addItem(title, shortText, price, description, imagesPath);
  }

  Future<void> editItem(int itemId, String title, String shortText, 
    String price, String description, List imagesPath, List imagesUrls) async {
    
    return await shopRepository.editItem(
      itemId, title, shortText, price, description, imagesPath, imagesUrls
    );
  }

  Future<void> deleteItem(int id) async {
    return await shopRepository.deleteItem(id);
  }

  Future<void> deleteImage(int id, List images, String imageUrl) async {
    await shopRepository.deleteImage(imageUrl);
    await shopRepository.updateImages(id, images, imageUrl);
  }

  Future<List<Item>> getItems() async {
    return await shopRepository.getItems();
  }
}

final shopServiceProvider = Provider<ShopService>((ref) {
  return ShopService(
    shopRepository: ref.watch(shopRepositoryProvider),
  );
});