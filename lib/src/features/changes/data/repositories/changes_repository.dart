import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:rv1g_info/src/constants/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/changes.dart';

class ChangesRepository {
  Future<void> updateChanges(String tag, String imagePath, String imageUrl) async {
    final supabase = Supabase.instance.client;

    final bytes = await File(imagePath).readAsBytes();
    final fileExt = File(imagePath).path.split('.').last;
    final fileName = '$tag.${DateTime.now().toIso8601String()}.$fileExt';
    final filePath = fileName;
    await supabase.storage.from('changes').uploadBinary(
        filePath,
        bytes,
      );
    final res = supabase.storage
      .from('changes')
      .getPublicUrl(filePath);

    if(imageUrl != noChanges){
      await supabase
        .storage
        .from('changes')
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

  Future<void> deleteChanges(String tag, String imageUrl) async {
    final supabase = Supabase.instance.client;

    await supabase
      .from('media')
      .delete()
      .eq('tag', tag);

    await supabase
      .storage
      .from('changes')
      .remove([imageUrl.split("/").last]);
  }

  Future<Map<String, Changes>> getChanges() async {
    final supabase = Supabase.instance.client;

    final resMedia = await supabase
      .from('media')
      .select()
      .filter('tag', 'ilike', '%changes%')
      .order('tag', ascending: false);
    
    Map<String, Changes> changes = {};

    for(int i=0;i<resMedia.length;i++){
      String tag = resMedia[i]['tag'];

      changes[tag] = Changes(
        id: resMedia[i]['id'],
        mediaUrl: resMedia[i]['media_url'],
        tag: tag,
        nameDay: nameDays[tag.substring(tag.length-5, tag.length)]!
      );
    }

    return changes;
  }
}

final changesRepositoryProvider = riverpod.Provider<ChangesRepository>((ref) {
  return ChangesRepository();
});