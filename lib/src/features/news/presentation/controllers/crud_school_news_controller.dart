import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rv1g_info/src/features/news/application/services/news_service.dart';

class AddSchoolNewsController extends StateNotifier<AsyncValue<void>> {
  AddSchoolNewsController({required this.newsService})
      : super(const AsyncData<void>(null));

  NewsService newsService;

  Future<void> addSchoolNews(
    String text, List imagesPath, bool pin, bool showNewPoll, String title, 
    String answer1, String answer2, String answer3, String answer4, DateTime pollEnd) async {

    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return newsService.addSchoolNews(
        text, imagesPath, pin, showNewPoll, title, answer1, 
        answer2, answer3, answer4, pollEnd
      );
    });
  }

  Future<void> editSchoolNews(
    int newsId, String text, List imagesUrls, List imagesPath, bool pin, bool showNewPoll,
    int pollId, String title, int answer1Id, int answer2Id, int answer3Id, int answer4Id, 
    String answer1, String answer2, String answer3, String answer4, DateTime pollEnd) async {
      
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return newsService.editSchoolNews(
        newsId, text, imagesUrls, imagesPath, pin, showNewPoll,
        pollId, title, answer1Id, answer2Id, answer3Id, answer4Id, 
        answer1, answer2, answer3, answer4, pollEnd
      );
    });
  }

  Future<void> deleteImage(int id, List images, String imageUrl) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return newsService.deleteImage(id, images, imageUrl);
    });
  }
}

final addSchoolNewsControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider.autoDispose<AddSchoolNewsController, AsyncValue<void>>(
        (ref) {
  return AddSchoolNewsController(
    newsService: ref.watch(newsServiceProvider),
  );
});