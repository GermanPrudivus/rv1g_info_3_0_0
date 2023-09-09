import 'dart:convert';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

import '../../domain/models/item.dart';

class ShopRepository {
  final supabase = Supabase.instance.client;

  Future<void> addItem(String title, String shortText, 
    String price, String description, List imagesPath) async {

    List jsonParagraphs = [];

    if(description != ""){
      List paragraphs = description.split('\n');

      jsonParagraphs = paragraphs.map((paragraph) {
        return json.encode({
          "text": paragraph,
        });
      }).toList();
    }

    List<String> images = [];

    if(imagesPath.isNotEmpty) {
      for(int i=0;i<imagesPath.length;i++){
        final bytes = await File(imagesPath[i]).readAsBytes();
        final fileExt = File(imagesPath[i]).path.split('.').last;
        final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
        final filePath = fileName;
        await supabase.storage.from('shop_item').uploadBinary(
            filePath,
            bytes,
          );
        final res = supabase.storage
          .from('shop_item')
          .getPublicUrl(filePath);

        images.add(res);
      }
    }

    List jsonImages = images.map((image) {
      return json.encode({
        "image_url": image,
      });
    }).toList();

    await supabase
      .from('shop_items')
      .insert(
        toJson({
          'title': title,
          'short_text': shortText,
          'description': jsonParagraphs,
          'media': jsonImages,
          'price': price,
          'created_datetime': DateTime.now().toIso8601String()
        })
      );
  }

  Future<void> editItem(int itemId, String title, String shortText, 
    String price, String description, List imagesPath, List imagesUrls) async {

    List jsonParagraphs = [];

    if(description != ""){
      List paragraphs = description.split('\n');

      jsonParagraphs = paragraphs.map((paragraph) {
        return json.encode({
          "text": paragraph,
        });
      }).toList();
    }

    List<String> images = [];

    if(imagesPath.isNotEmpty) {
      for(int i=0;i<imagesPath.length;i++){
        final bytes = await File(imagesPath[i]).readAsBytes();
        final fileExt = File(imagesPath[i]).path.split('.').last;
        final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
        final filePath = fileName;
        await supabase.storage.from('shop_item').uploadBinary(
            filePath,
            bytes,
          );
        final res = supabase.storage
          .from('shop_item')
          .getPublicUrl(filePath);

        images.add(res);
      }
    }

    List jsonImages = images.map((image) {
      return json.encode({
        "image_url": image,
      });
    }).toList();

    jsonImages = imagesUrls + jsonImages;

    await supabase
      .from('shop_items')
      .update(
        toJson({
          'title': title,
          'short_text': shortText,
          'description': jsonParagraphs,
          'media': jsonImages,
          'price': price,
        })
      )
      .eq('id', itemId);
  }

  Future<void> deleteItem(int id) async {
    await supabase
      .from('shop_items')
      .delete()
      .eq('id', id);
  }

  Future<void> updateImages(int id, List images, String imageUrl) async{
    List imagesEdited = images;
    imagesEdited.remove(imageUrl);

    await supabase
      .from('shop_items')
      .update({'media':imagesEdited})
      .eq('id', id);
  }

  Future<void> deleteImage(String imageUrl) async {
    await supabase
      .storage
      .from('shop_item')
      .remove([json.decode(imageUrl)['image_url'].split("/").last]);
  }

  Future<List<Item>> getItems() async {
    final res = await supabase
      .from('shop_items')
      .select()
      .order('created_datetime', ascending: false);

    List<Item> items = [];

    for(int i=0;i<res.length;i++){
      items.add(Item(
        id: res[i]['id'], 
        title: res[i]['title'], 
        shortText: res[i]['short_text'], 
        description: List.from(res[i]['description']), 
        media: List.from(res[i]['media']), 
        price: res[i]['price']
      ));
    }

    return items;
  }
}

final shopRepositoryProvider = riverpod.Provider<ShopRepository>((ref) {
  return ShopRepository();
});