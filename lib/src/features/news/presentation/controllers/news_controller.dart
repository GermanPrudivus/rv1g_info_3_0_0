import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rv1g_info/src/features/news/application/services/news_service.dart';

class NewsController extends StateNotifier<AsyncValue<void>> {
  NewsController({required this.newsService})
      : super(const AsyncData<void>(null));

  NewsService newsService;

  Future<List<String>?> getUser() async {
    state = const AsyncLoading<void>();
    final AsyncValue<List<String>> asyncValue = await AsyncValue.guard<List<String>>(() {
      return newsService.getUser();
    });
    state = asyncValue;
    return asyncValue.value;
  }
}

final newsControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider<NewsController, AsyncValue<void>>(
        (ref) {
  return NewsController(
    newsService: ref.watch(newsServiceProvider),
  );
});