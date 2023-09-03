import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/event_repository.dart';
import '../../doamain/models/event.dart';

class EventService {
  EventService({
    required this.eventRepository,
  });

  final EventRepository eventRepository;

  //CRUD EVENT PAGE
  Future<void> addEvent(String title, String email, String shortText, 
    String description, String startDate, String endDate, List imagesPath) async {

    await eventRepository.addEvent(
      title, shortText, description, startDate, endDate, imagesPath
    );

    if(email != ""){
      await eventRepository.addRole(title, email, endDate);
    }
  }

  Future<void> editEvent(
    int eventId, String title, String shortText, String description, 
    String startDate, String endDate, List imagesPath, List imagesUrls) async {
    
    return eventRepository.editEvent(
      eventId, title, shortText, description, 
      startDate, endDate, imagesPath, imagesUrls
    );
  }

  Future<void> deleteEvent(int id, List images) async{
    await eventRepository.deleteEvent(id);
    await eventRepository.deleteRole(id);

    if(images.isNotEmpty){
      for(int i=0;i<images.length;i++){
        eventRepository.deleteImage(images[i]);
      }
    }
  }

  Future<void> deleteImage(int id, List images, String imageUrl) async {
    await eventRepository.updateImages(id, images, imageUrl);
    await eventRepository.deleteImage(imageUrl);
  }

  //EVENT PAGE
  Future<List<Event>> getEvents() async {
    return await eventRepository.getEvents();
  }

  //ADD PARTICIPANT PAGE
  Future<void> addParticipant(int userId, Event event) async {
    return await eventRepository.addParticipant(userId, event);
  }
}

final eventServiceProvider = Provider<EventService>((ref) {
  return EventService(
    eventRepository: ref.watch(eventRepositoryProvider),
  );
});