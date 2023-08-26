import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../constants/const.dart';
import '../../domain/models/schedule.dart';

class ScheduleRepository {
  final supabase = Supabase.instance.client;

  Future<void> addSchedule(String tag, String imagePath) async{
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

    await supabase
      .from('media')
      .insert(
        toJson({
          'media_url': res,
          'tag': tag
        })
      );
  }

  Future<void> updateSchedule(String tag, String imagePath, String imageUrl) async{
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

    await supabase
      .storage
      .from('media')
      .remove([imageUrl.split("/").last]);

    await supabase
      .from('media')
      .update({'media_url': res})
      .eq('tag', tag);
  }

  Future<void> deleteSchedule(String tag, String imageUrl) async {
    await supabase
      .from('media')
      .delete()
      .eq('tag', tag);

    await supabase
      .storage
      .from('media')
      .remove([imageUrl.split("/").last]);
  }

  Future<Map<String, Schedule>> getSchedule() async {
    final res = await supabase
      .from('media')
      .select()
      .filter('tag', 'ilike', '%schedule%')
      .order('tag', ascending: false);

    Map<String, Schedule> schedules ={};

    for(int i=0;i<res.length;i++){
      schedules[res[i]['tag']] = Schedule(
        id: res[i]['id'], 
        mediaUrl: res[i]['media_url'], 
        tag: res[i]['tag']
      );
    }

    return schedules;
  }

  Future<Map<String, List<String>>> getForms() async {
    Map<String, List<String>> forms = {};

    List<int> number = numbers;
    
    for(int i=0;i<number.length;i++){
      final res = await supabase
        .from('forms')
        .select()
        .eq('number', number[i])
        .order('id', ascending: true);

      List<String> letters = [];

      for(int i=0;i<res.length;i++){
        letters.add(res[i]['letter']);
      }

      forms[number[i].toString()] = letters;
    }

    return forms;
  }
}

final scheduleRepositoryProvider = riverpod.Provider<ScheduleRepository>((ref) {
  return ScheduleRepository();
});