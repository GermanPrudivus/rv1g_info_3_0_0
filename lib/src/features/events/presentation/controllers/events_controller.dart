import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/event_service.dart';
import '../../doamain/models/event.dart';

class EventsController extends StateNotifier<AsyncValue<void>> {
  EventsController({required this.eventService})
      : super(const AsyncData<void>(null));

  EventService eventService;

  Future<List<Event>?> getEvents() async {
    state = const AsyncLoading<void>();
    final AsyncValue<List<Event>> asyncValue = await AsyncValue.guard<List<Event>>(() {
      return eventService.getEvents();
    });
    state = asyncValue;
    return asyncValue.value;
  }
}

final eventsControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider<EventsController, AsyncValue<void>>(
        (ref) {
  return EventsController(
    eventService: ref.watch(eventServiceProvider),
  );
});