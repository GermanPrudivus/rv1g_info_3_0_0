import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rv1g_info/src/features/news/application/services/news_service.dart';

class CrudSchoolNewsController extends StateNotifier<AsyncValue<void>> {
  CrudSchoolNewsController({required this.newsService})
      : super(const AsyncData<void>(null));

  NewsService newsService;

  Future<void> addSchoolNews(
    String text, List imagesPath, bool pin, bool showNewPoll, 
    String title, List<String> answers, DateTime pollEnd) async {

    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return newsService.addSchoolNews(
        text, imagesPath, pin, showNewPoll, title, answers, pollEnd
      );
    });
  }

  Future<void> editSchoolNews(
    int newsId, String text, List imagesUrls, List imagesPath, bool pin, bool showNewPoll,
    int pollId, String title, List<int> answersId, List<String> answers, DateTime pollEnd) async {
      
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return newsService.editSchoolNews(
        newsId, text, imagesUrls, imagesPath, pin, showNewPoll,
        pollId, title, answersId, answers, pollEnd
      );
    });
  }

  Future<void> deleteSchoolNews(int id, List images, int pollId, List<int> answers) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return newsService.deleteSchoolNews(id, images, pollId, answers);
    });
  }

  Future<void> deleteImage(int id, List images, String imageUrl) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return newsService.deleteImage(id, images, imageUrl, 'news', 'news');
    });
  }

  Future<void> deletePoll(int id, List<int> answers) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return newsService.deletePoll(id, answers);
    });
  }
}

final crudSchoolNewsControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider.autoDispose<CrudSchoolNewsController, AsyncValue<void>>(
        (ref) {
  return CrudSchoolNewsController(
    newsService: ref.watch(newsServiceProvider),
  );
});