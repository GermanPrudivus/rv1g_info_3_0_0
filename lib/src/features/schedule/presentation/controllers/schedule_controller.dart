import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/schedule_service.dart';
import '../../domain/models/schedule.dart';

class ScheduleController extends StateNotifier<AsyncValue<void>> {
  ScheduleController({required this.scheduleService})
      : super(const AsyncData<void>(null));

  ScheduleService scheduleService;

  Future<void> updateSchedule(String tag, String imagePath, String imageUrl) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return scheduleService.updateSchedule(tag, imagePath, imageUrl);
    });
  }

  Future<Map<String, Schedule>?> getSchedule() async {
    state = const AsyncLoading<void>();
    final AsyncValue<Map<String, Schedule>> asyncValue = await AsyncValue.guard<Map<String, Schedule>>(() {
      return scheduleService.getSchedule();
    });
    state = asyncValue;
    return asyncValue.value;
  }

  Future<Map<String, List<String>>?> getForms() async {
    state = const AsyncLoading<void>();
    final AsyncValue<Map<String, List<String>>> asyncValue = await AsyncValue.guard<Map<String, List<String>>>(() {
      return scheduleService.getForms();
    });
    state = asyncValue;
    return asyncValue.value;
  }
}

final scheduleControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider<ScheduleController, AsyncValue<void>>(
        (ref) {
  return ScheduleController(
    scheduleService: ref.watch(scheduleServiceProvider),
  );
});