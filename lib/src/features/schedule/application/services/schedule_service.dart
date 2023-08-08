import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/schedule_repository.dart';

class ScheduleService {
  ScheduleService({
    required this.scheduleRepository,
  });

  final ScheduleRepository scheduleRepository;

  Future<Map<String, List<String>>> getForms() async {
    return await scheduleRepository.getForms();
  }

}

final scheduleServiceProvider = Provider<ScheduleService>((ref) {
  return ScheduleService(
    scheduleRepository: ref.watch(scheduleRepositoryProvider),
  );
});