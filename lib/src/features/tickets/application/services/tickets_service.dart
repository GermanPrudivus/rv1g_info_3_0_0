import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/tickets_repository.dart';
import '../../domain/models/ticket.dart';

class TicketsService {
  TicketsService({
    required this.ticketsRepository,
  });

  final TicketsRepository ticketsRepository;

  Future<List<Ticket>> getTickets() async {
    return await ticketsRepository.getTickets();
  }
}

final ticketsServiceProvider = Provider<TicketsService>((ref) {
  return TicketsService(
    ticketsRepository: ref.watch(ticketsRepositoryProvider),
  );
});