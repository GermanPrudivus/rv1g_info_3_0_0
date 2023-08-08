import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../constants/const.dart';

class ScheduleRepository {
  Future<Map<String, List<String>>> getForms() async {
    final supabase = Supabase.instance.client;

    Map<String, List<String>> forms = {};

    List<int> number = numbers;
    
    for(int i=0;i<number.length;i++){
      final res = await supabase
        .from('form')
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