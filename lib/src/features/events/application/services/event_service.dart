import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/event_repository.dart';
import '../../doamain/models/event.dart';

class EventService {
  EventService({
    required this.eventRepository,
  });

  final EventRepository eventRepository;

  //CRUD EVENT PAGE
  Future<void> addEvent(
    String title, String shortText, String description, 
    String startDate, String endDate, List imagesPath) async {

    return eventRepository.addEvent(
      title, shortText, description, startDate, endDate, imagesPath
    );
  }

  /*Future<void> editSchoolNews(
    int newsId, String text, List imagesUrls, List imagesPath, bool pin, bool showNewPoll,
    int pollId, String title, List<int> answersId, List<String> answers, DateTime pollEnd) async {
    
    return newsRepository
      .editSchoolNews(newsId, text, imagesUrls, imagesPath, pin)
      .whenComplete(() {
        if(pollId != 0){
          newsRepository.updatePoll(
            pollId, 
            title, 
            pollEnd
          ).whenComplete(() async {
            for(int i=0;i<answers.length;i++){
              if(answers[i] == "" && answersId[i]  != 0){
                await newsRepository.deleteAnswer(answersId[i]);
              } else if (answers[i] != "" && answersId[i] == 0){
                await newsRepository.addAnswer(pollId, answers[i]);
              } else if (answersId[i] != 0){
                await newsRepository.updateAnswer(answersId[i], answers[i]);
              }
            }
          });
        } else if(showNewPoll){
          newsRepository.addPoll(
            title,
            pollEnd, 
            newsId
          ).then((value) async {
            for(int i=0;i<answers.length;i++){
              if(answers[i] != ""){
                await newsRepository.addAnswer(value, answers[i]);
              }
            }
          });               
        }
      });
  }*/

  Future<void> deleteEvent(int id, List images) async{
    await eventRepository.deleteEvent(id);

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

}

final eventServiceProvider = Provider<EventService>((ref) {
  return EventService(
    eventRepository: ref.watch(eventRepositoryProvider),
  );
});