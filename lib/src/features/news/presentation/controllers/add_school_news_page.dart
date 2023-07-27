import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rv1g_info/src/features/news/application/services/news_service.dart';

class AddSchoolNewsController extends StateNotifier<AsyncValue<void>> {
  // set the initial value
  AddSchoolNewsController({required this.newsService})
      : super(const AsyncData<void>(null));

  NewsService newsService;

  Future<int?> addSchoolNews(String text, List imagesPath, bool pin, bool hasPoll) async {
    // set the state to loading
    state = const AsyncLoading<void>();
    // call `authRepository.signUp` and await for the result
    state = await AsyncValue.guard<void>(() {
        return newsService.addSchoolNews(text, imagesPath, pin, hasPoll);
    });
    return 0;
  }

  Future<void> addPoll(
    String title, String answer1, String answer2, String answer3, String answer4, DateTime pollEnd, int newsId) async {
    // set the state to loading
    state = const AsyncLoading<void>();
    // call `authRepository.signUp` and await for the result
    state = await AsyncValue.guard<void>(
      () => newsService.addPoll(
        title,
        answer1,
        answer2,
        answer3,
        answer4,
        pollEnd,
        newsId
      ),
    );
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