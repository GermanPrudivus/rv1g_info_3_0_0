import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/volunteering_repository.dart';
import '../../domain/models/job.dart';

class VolunteeringService {
  VolunteeringService({
    required this.volunteeringRepository,
  });

  final VolunteeringRepository volunteeringRepository;

  //CRUD VOLUNTEERING PAGE
  Future<void> addJob(String title, String description, 
    String startDate, String endDate, List imagesPath) async {

    return volunteeringRepository.addJob(
      title, description, startDate, endDate, imagesPath
    );
  }

  Future<void> editJob(int eventId, String title, String description, 
    String startDate, String endDate, List imagesPath, List imagesUrls) async {
    
    return volunteeringRepository.editJob(
      eventId, title, description, startDate, endDate, imagesPath, imagesUrls
    );
  }

  Future<void> deleteJob(int id, List images) async{
    await volunteeringRepository.deleteJob(id);

    if(images.isNotEmpty){
      for(int i=0;i<images.length;i++){
        volunteeringRepository.deleteImage(images[i]);
      }
    }
  }

  Future<void> deleteImage(int id, List images, String imageUrl) async {
    await volunteeringRepository.updateImages(id, images, imageUrl);
    await volunteeringRepository.deleteImage(imageUrl);
  }

  //EVENT PAGE
  Future<List<Job>> getJobs() async {
    return await volunteeringRepository.getJobs();
  }
}

final volunteeringServiceProvider = Provider<VolunteeringService>((ref) {
  return VolunteeringService(
    volunteeringRepository: ref.watch(volunteeringRepositoryProvider),
  );
});