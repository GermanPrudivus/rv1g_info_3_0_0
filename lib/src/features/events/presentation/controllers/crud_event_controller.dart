import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/event_service.dart';

class CrudEventController extends StateNotifier<AsyncValue<void>> {
  CrudEventController({required this.eventService})
      : super(const AsyncData<void>(null));

  EventService eventService;

  Future<void> addEvent(String title, String email, String shortText, 
    String description, String startDate, String endDate, List imagesPath) async {

    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return eventService.addEvent(
        title, email, shortText, description, startDate, endDate, imagesPath
      );
    });
  }

  Future<void> editEvent(int eventId, String title, String shortText, String description, 
    String startDate, String endDate, List imagesPath, List imagesUrls) async {

    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return eventService.editEvent(
        eventId, title, shortText, description, startDate, endDate, imagesPath, imagesUrls
      );
    });
  }

  Future<void> deleteEvent(int id, List images) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return eventService.deleteEvent(id, images);
    });
  }

  Future<void> deleteImage(int id, List images, String imageUrl) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return eventService.deleteImage(id, images, imageUrl);
    });
  }
}

final crudEventControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider.autoDispose<CrudEventController, AsyncValue<void>>(
        (ref) {
  return CrudEventController(
    eventService: ref.watch(eventServiceProvider),
  );
});