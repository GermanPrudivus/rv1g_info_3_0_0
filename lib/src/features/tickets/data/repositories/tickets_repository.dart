import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

import '../../domain/models/ticket.dart';


class TicketsRepository {
  final supabase = Supabase.instance.client;

  Future<List<Ticket>> getTickets() async {
    List<Ticket> tickets = [];

    final email = supabase.auth.currentUser!.email;

    final user = await supabase
      .from('users')
      .select()
      .eq('email', email);

    final res = await supabase
      .from('tickets')
      .select()
      .eq('user_id', user[0]['id'])
      .order('created_datetime', ascending: false);

    for(int i=0;i<res.length;i++){
      final event = await supabase
        .from('events')
        .select()
        .eq('id', res[i]['event_id']);

      tickets.add(
        Ticket(
          id: res[i]['id'],
          userId: user[0]['id'], 
          title: event[0]['title'], 
          eventId: res[i]['event_id'], 
          key: res[i]['key'], 
          endDateTime: event[0]['end_date'],
          createdDateTime: res[i]['created_datetime']
        )
      );
    }

    return tickets;
  }

}

final ticketsRepositoryProvider = riverpod.Provider<TicketsRepository>((ref) {
  return TicketsRepository();
});