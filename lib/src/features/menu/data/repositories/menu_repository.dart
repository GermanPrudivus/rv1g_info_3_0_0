import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../constants/const.dart';
import '../../domain/models/menu.dart';

class MenuRepository {
  Future<void> updateMenu(String tag, String imagePath, String imageUrl) async{
    final supabase = Supabase.instance.client;

    final bytes = await File(imagePath).readAsBytes();
    final fileExt = File(imagePath).path.split('.').last;
    final fileName = '$tag.${DateTime.now().toIso8601String()}.$fileExt';
    final filePath = fileName;
    await supabase.storage.from('media').uploadBinary(
        filePath,
        bytes,
      );
    final res = supabase.storage
      .from('media')
      .getPublicUrl(filePath);

    if(imageUrl != noMenu){
      await supabase
        .storage
        .from('media')
        .remove([imageUrl.split("/").last]);

      await supabase
        .from('media')
        .update({'media_url': res})
        .eq('tag', tag);
    } else {
      await supabase
        .from('media')
        .insert(
          toJson({
            'media_url': res,
            'tag': tag
          })
        );
    }
  }

  Future<void> deleteMenu(String tag, String imageUrl) async {
    final supabase = Supabase.instance.client;

    await supabase
      .from('media')
      .delete()
      .eq('tag', tag);

    await supabase
      .storage
      .from('media')
      .remove([imageUrl.split("/").last]);
  }

  Future<Map<String, Menu>> getMenu() async {
    final supabase = Supabase.instance.client;

    final res = await supabase
      .from('media')
      .select()
      .filter('tag', 'ilike', '%menu%')
      .order('tag', ascending: false);

    Map<String, Menu> schedules ={};

    for(int i=0;i<res.length;i++){
      schedules[res[i]['tag']] = Menu(
        id: res[i]['id'], 
        mediaUrl: res[i]['media_url'], 
        tag: res[i]['tag']
      );
    }

    return schedules;
  }
}

final menuRepositoryProvider = riverpod.Provider<MenuRepository>((ref) {
  return MenuRepository();
});