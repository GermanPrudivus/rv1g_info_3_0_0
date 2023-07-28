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

  Future<int> addSchoolNews(String text, List imagesPath, bool pin) async {
    return await newsRepository.addSchoolNews(text, imagesPath, pin);
  }

  Future<void> addPoll(
    String title, String answer1, String answer2, String answer3, String answer4, DateTime pollEnd, int newsId) async {
    await newsRepository.addPoll(
      title,
      answer1,
      answer2,
      answer3,
      answer4,
      pollEnd,
      newsId
    );
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