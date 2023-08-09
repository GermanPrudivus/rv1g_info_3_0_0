import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/news_repository.dart';
import '../../domain/models/eklase_news.dart';
import '../../domain/models/school_news.dart';

class NewsService {
  NewsService({
    required this.newsRepository,
  });

  final NewsRepository newsRepository;

  //CRUD SCHOOL NEWS PAGE
  Future<void> addSchoolNews(
    String text, List imagesPath, bool pin, bool showNewPoll, 
    String title, List<String> answers, DateTime pollEnd) async {

    return newsRepository
      .addSchoolNews(text, imagesPath, pin)
      .then((value) {
        if(showNewPoll){
          newsRepository
            .addPoll(title, pollEnd, value).then((value) async{
              for(int i=0;i<answers.length;i++){
                if(answers[i] != ""){
                  await newsRepository.addAnswer(value, answers[i]);
                }
              }
            });
        }
      });
  }

  Future<void> editSchoolNews(
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
  }

  Future<void> deleteSchoolNews(int id, List images, int pollId, List<int> answers) async{
    await newsRepository.deleteSchoolNews(id);

    if(images.isNotEmpty){
      for(int i=0;i<images.length;i++){
        newsRepository.deleteImage(images[i], 'news');
      }
    }

    if(pollId != 0){
      newsRepository.deletePoll(pollId)
        .whenComplete(() {
          for(int i=0;i<answers.length;i++){
            newsRepository.deleteAnswer(answers[i]);
          }
        });
    }
  }

  Future<void> deleteImage(int id, List images, String imageUrl, String bucket, String table) async {
    await newsRepository.updateImages(id, images, imageUrl, table);
    await newsRepository.deleteImage(imageUrl, bucket);
  }

  Future<void> deletePoll(int id, List<int> answers) async {
    return await newsRepository.deletePoll(id)
      .whenComplete(() {
        for(int i=0;i<answers.length;i++){
          newsRepository.deleteAnswer(answers[i]);
        }
      });
  }

  //SCHOOL PAGE
  Future<List<SchoolNews>> getSchoolNews() async {
    return await newsRepository.getSchoolNews();
  }

  Future<void> updateVotes(int pollId, int answerId, int userId) async {
    return await newsRepository.updateVotes(pollId, answerId, userId);
  }

  //CRUD Eklase News Page
  Future<void> addEklaseNews(String title, String author, 
    String shortText, String text, List imagesPath, bool pin) async{

    return await newsRepository.addEklaseNews(title, author, shortText, text, imagesPath, pin);
  }

  Future<void> editEklaseNews(int newsId, String title, String author, 
    String shortText, String text, List imagesPath, List imagesUrls, bool pin) async{

    return await newsRepository.editEklaseNews(
      newsId, title, author, shortText, text, imagesPath, imagesUrls, pin
    );
  }

  Future<void> deleteEklaseNews(int id) async{
    return await newsRepository.deleteEklaseNews(id);
  }

  //EKLASE PAGE
  Future<List<EklaseNews>> getEklaseNews() async {
    return await newsRepository.getEklaseNews();
  }

  Future<int> getUserId() async {
    return await newsRepository.getUserId();
  }
}

final newsServiceProvider = Provider<NewsService>((ref) {
  return NewsService(
    newsRepository: ref.watch(newsRepositoryProvider),
  );
});