import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/volunteering_service.dart';

class CrudVolunteeringController extends StateNotifier<AsyncValue<void>> {
  CrudVolunteeringController({required this.volunteeringService})
      : super(const AsyncData<void>(null));

  VolunteeringService volunteeringService;

  Future<void> addJob(String title, String description, 
    String startDate, String endDate, List imagesPath) async {

    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return volunteeringService.addJob(
        title, description, startDate, endDate, imagesPath
      );
    });
  }

  Future<void> editJob(int eventId, String title, String description, 
    String startDate, String endDate, List imagesPath, List imagesUrls) async {

    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return volunteeringService.editJob(
        eventId, title, description, startDate, endDate, imagesPath, imagesUrls
      );
    });
  }

  Future<void> deleteEvent(int id, List images) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return volunteeringService.deleteJob(id, images);
    });
  }

  Future<void> deleteImage(int id, List images, String imageUrl) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return volunteeringService.deleteImage(id, images, imageUrl);
    });
  }
}

final crudVolunteeringControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider.autoDispose<CrudVolunteeringController, AsyncValue<void>>(
        (ref) {
  return CrudVolunteeringController(
    volunteeringService: ref.watch(volunteeringServiceProvider),
  );
});