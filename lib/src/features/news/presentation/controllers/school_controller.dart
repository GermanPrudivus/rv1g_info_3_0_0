import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rv1g_info/src/features/news/application/services/news_service.dart';

import '../../domain/models/school_news.dart';

class SchoolController extends StateNotifier<AsyncValue<void>> {
  SchoolController({required this.newsService})
      : super(const AsyncData<void>(null));

  NewsService newsService;

  Future<List<SchoolNews>?> getSchoolNews() async {
    state = const AsyncLoading<void>();
    final AsyncValue<List<SchoolNews>> asyncValue = await AsyncValue.guard<List<SchoolNews>>(() {
      return newsService.getSchoolNews();
    });
    state = asyncValue;
    return asyncValue.value;
  }

  Future<int?> getUserId() async {
    state = const AsyncLoading<void>();
    final AsyncValue<int> asyncValue = await AsyncValue.guard<int>(() {
      return newsService.getUserId();
    });
    state = asyncValue;
    return asyncValue.value;
  }

  Future<void> updateVotes(int pollId, int answerId, int userId) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return newsService.updateVotes(pollId, answerId, userId);
    });
  }

  Future<void> updateLikes(int newsId, int likes, bool likePressed, int userId) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return newsService.updateLikes(newsId, likes, likePressed, userId);
    });
  }
}

final schoolControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider<SchoolController, AsyncValue<void>>(
        (ref) {
  return SchoolController(
    newsService: ref.watch(newsServiceProvider),
  );
});