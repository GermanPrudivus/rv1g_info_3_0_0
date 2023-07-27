import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/news_repository.dart';

class NewsService {
  NewsService({
    required this.newsRepository,
  });

  final NewsRepository newsRepository;

  Future<int> addSchoolNews(String text, List imagesPath, bool pin, bool hasPoll) async {
    return await newsRepository.addSchoolNews(text, imagesPath, pin, hasPoll);
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

}

final newsServiceProvider = Provider<NewsService>((ref) {
  return NewsService(
    newsRepository: ref.watch(newsRepositoryProvider),
  );
});