import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/news_repository.dart';
import '../../domain/models/answer.dart';
import '../../domain/models/author_data.dart';
import '../../domain/models/poll.dart';
import '../../domain/models/school_news.dart';

class NewsService {
  NewsService({
    required this.newsRepository,
  });

  final NewsRepository newsRepository;

  Future<void> addSchoolNews(
    String text, List imagesPath, bool pin, bool showNewPoll, String title, 
    String answer1, String answer2, String answer3, String answer4, DateTime pollEnd) async {

    return newsRepository
      .addSchoolNews(text, imagesPath, pin)
      .then((value) {
        if(showNewPoll){
          newsRepository
            .addPoll(
              title, 
              answer1, 
              answer2, 
              answer3, 
              answer4, 
              pollEnd, 
              value
            );
        }
      });
  }

  Future<void> editSchoolNews(
    int newsId, String text, List imagesUrls, List imagesPath, bool pin, bool showNewPoll,
    int pollId, String title, int answer1Id, int answer2Id, int answer3Id, int answer4Id, 
    String answer1, String answer2, String answer3, String answer4, DateTime pollEnd) async {
    
    return newsRepository
      .editSchoolNews(newsId, text, imagesUrls, imagesPath, pin)
      .whenComplete(() {
        if(pollId != 0){
          newsRepository.editPoll(
            pollId, 
            title, 
            answer1Id, 
            answer2Id, 
            answer3Id, 
            answer4Id, 
            answer1, 
            answer2, 
            answer3, 
            answer4, 
            pollEnd
          );
        } else if(showNewPoll){
          newsRepository.addPoll(
            title, 
            answer1, 
            answer2, 
            answer3, 
            answer4, 
            pollEnd, 
            newsId
          );               
        }
      });
  }

  Future<void> deleteImage(int id, List images, String imageUrl) async {
    return await newsRepository.deleteImage(id, images, imageUrl);
  }

  Future<List<SchoolNews>> getSchoolNews() async {
    return await newsRepository.getSchoolNews();
  }

  Future<List<AuthorData>> getAuthorData(List<int> authorId) async {
    return await newsRepository.getAuthorData(authorId);
  }

  Future<Map<int, Poll>> getPolls(List<int> newsId) async {
    return await newsRepository.getPolls(newsId);
  }

  Future<List<Answer>> getAnswers(List<int> pollsId) async {
    return await newsRepository.getAnswers(pollsId);
  }
}

final newsServiceProvider = Provider<NewsService>((ref) {
  return NewsService(
    newsRepository: ref.watch(newsRepositoryProvider),
  );
});