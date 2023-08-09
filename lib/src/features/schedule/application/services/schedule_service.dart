import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/schedule_repository.dart';
import '../../domain/models/schedule.dart';

class ScheduleService {
  ScheduleService({
    required this.scheduleRepository,
  });

  final ScheduleRepository scheduleRepository;

  Future<void> addSchedule(String tag, String imagePath) async{
    return await scheduleRepository.addSchedule(tag, imagePath);
  }

  Future<void> deleteSchedule(String tag, String imageUrl) async {
    return await scheduleRepository.deleteSchedule(tag, imageUrl);
  }

  Future<Map<String, Schedule>> getSchedule() async{
    return await scheduleRepository.getSchedule();
  }

  Future<Map<String, List<String>>> getForms() async {
    return await scheduleRepository.getForms();
  }

}

final scheduleServiceProvider = Provider<ScheduleService>((ref) {
  return ScheduleService(
    scheduleRepository: ref.watch(scheduleRepositoryProvider),
  );
});