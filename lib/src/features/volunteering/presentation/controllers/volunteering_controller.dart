import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/volunteering_service.dart';
import '../../domain/models/job.dart';

class VolunteeringController extends StateNotifier<AsyncValue<void>> {
  VolunteeringController({required this.volunteeringService})
      : super(const AsyncData<void>(null));

  VolunteeringService volunteeringService;

  Future<List<Job>?> getEvents() async {
    state = const AsyncLoading<void>();
    final AsyncValue<List<Job>> asyncValue = await AsyncValue.guard<List<Job>>(() {
      return volunteeringService.getJobs();
    });
    state = asyncValue;
    return asyncValue.value;
  }
}

final volunteeringControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider<VolunteeringController, AsyncValue<void>>(
        (ref) {
  return VolunteeringController(
    volunteeringService: ref.watch(volunteeringServiceProvider),
  );
});