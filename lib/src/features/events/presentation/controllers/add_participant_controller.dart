import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/event_service.dart';
import '../../doamain/models/event.dart';

class AddParticipantController extends StateNotifier<AsyncValue<void>> {
  AddParticipantController({required this.eventService})
      : super(const AsyncData<void>(null));

  EventService eventService;

  Future<void> addParticipant(int userId, Event event) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return eventService.addParticipant(userId, event);
    });
  }
}

final addParticipantControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider.autoDispose<AddParticipantController, AsyncValue<void>>(
        (ref) {
  return AddParticipantController(
    eventService: ref.watch(eventServiceProvider),
  );
});