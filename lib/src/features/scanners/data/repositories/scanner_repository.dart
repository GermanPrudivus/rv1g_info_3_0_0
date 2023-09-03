import 'package:rv1g_info/src/features/scanners/domain/models/participant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

import '../../domain/models/scanner.dart';

class ScannerRepository {
  final supabase = Supabase.instance.client;

  Future<List<Scanner>> getScanners() async {
    List<Scanner> scanners = [];

    final res = await supabase
      .from('events')
      .select()
      .order('start_date', ascending: false);

    for(int i=0;i<res.length;i++){
      final resParticipants = await supabase
        .from('participants')
        .select()
        .eq('event_id', res[i]['id']);
      
      List<Participant> participants = [];

      for(int j=0;j<resParticipants.length;j++){
        final user = await supabase
          .from('users')
          .select()
          .eq('id', resParticipants[j]['user_id']);
        
        final form = await supabase
          .from('forms')
          .select()
          .eq('id', user[0]['form_id']);

        participants.add(
          Participant(
            userId: resParticipants[j]['user_id'], 
            fullName: '${user[0]['name']} ${user[0]['surname']}', 
            form: '${form[0]['number']}.${form[0]['letter']}', 
            active: resParticipants[j]['active']
          )
        );
      }

      scanners.add(
        Scanner(
          id: res[i]['id'],
          title: res[i]['title'], 
          key: res[i]['key'],
          participantQuant: res[i]['participant_quant'], 
          participants: participants, 
          endedDate: res[i]['end_date']
        )
      );
    }

    return scanners;
  }

  Future<List<Participant>> getParticipants(int eventId) async {
    List<Participant> participants = [];

    final res = await supabase
      .from('participants')
      .select()
      .eq('event_id', eventId);

    for(int i=0;i<res.length;i++){
      final user = await supabase
        .from('users')
        .select()
        .eq('id', res[i]['user_id']);
        
      final form = await supabase
        .from('forms')
        .select()
        .eq('id', user[0]['form_id']);

      participants.add(
        Participant(
          userId: res[i]['user_id'], 
          fullName: '${user[0]['name']} ${user[0]['surname']}', 
          form: '${form[0]['number']}.${form[0]['letter']}', 
          active: res[i]['active']
        )
      );
    }

    return participants;
  }

  Future<void> activateParticipant(int userId, int eventId) async {
    await supabase
      .from('participants')
      .update({
        'active' : true
      })
      .eq('user_id', userId)
      .eq('event_id', eventId);
  }

  Future<List> getParticipant(int userId, int eventId) async {
    final user = await supabase
      .from('users')
      .select()
      .eq('id', userId);
    
    final form = await supabase
      .from('forms')
      .select()
      .eq('id', user[0]['form_id']);
    
    final res = await supabase
      .from('participants')
      .select()
      .eq('user_id', userId)
      .eq('event_id', eventId);
    
    return [
      '${user[0]['name']} ${user[0]['surname']}',
      '${form[0]['number']}.${form[0]['letter']}',
      res[0]['active']
    ];
  }
}

final scannerRepositoryProvider = riverpod.Provider<ScannerRepository>((ref) {
  return ScannerRepository();
});