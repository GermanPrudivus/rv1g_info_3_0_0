import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/tickets_service.dart';
import '../../domain/models/ticket.dart';

class TicketsController extends StateNotifier<AsyncValue<void>> {
  TicketsController({required this.ticketsService})
      : super(const AsyncData<void>(null));

  TicketsService ticketsService;

  Future<List<Ticket>?> getTickets() async {
    state = const AsyncLoading<void>();
    final AsyncValue<List<Ticket>> asyncValue = await AsyncValue.guard<List<Ticket>>(() {
      return ticketsService.getTickets();
    });
    state = asyncValue;
    return asyncValue.value;
  }
}

final ticketsControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider<TicketsController, AsyncValue<void>>(
        (ref) {
  return TicketsController(
    ticketsService: ref.watch(ticketsServiceProvider),
  );
});