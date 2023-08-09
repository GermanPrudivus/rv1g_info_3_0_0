import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rv1g_info/src/constants/const.dart';

import '../../data/repositories/schedule_repository.dart';
import '../../domain/models/schedule.dart';

class ScheduleService {
  ScheduleService({
    required this.scheduleRepository,
  });

  final ScheduleRepository scheduleRepository;

  Future<void> updateSchedule(String tag, String imagePath, String imageUrl) async{
    if(imageUrl != noSchedule && imagePath == ""){
      return await scheduleRepository.deleteSchedule(tag, imageUrl);
    } else if(imagePath != ""){
      return await scheduleRepository.updateSchedule(tag, imagePath, imageUrl);
    }
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