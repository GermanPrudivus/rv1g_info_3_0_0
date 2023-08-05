import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rv1g_info/src/features/news/application/services/news_service.dart';

class CrudEklaseNewsController extends StateNotifier<AsyncValue<void>> {
  CrudEklaseNewsController({required this.newsService})
      : super(const AsyncData<void>(null));

  NewsService newsService;

  Future<void> addEklaseNews(String title, String author, 
    String shortText, String text, List imagesPath, bool pin) async {

    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return newsService.addEklaseNews(title, author, shortText, text, imagesPath, pin);
    });
  }

  Future<void> editEklaseNews(int newsId, String title, String author, 
    String shortText, String text, List imagesPath, List imagesUrls, bool pin) async {

    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return newsService.editEklaseNews(
        newsId, title, author, shortText, text, imagesPath, imagesUrls, pin
      );
    });
  }

  Future<void> deleteEklaseNews(int id) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return newsService.deleteEklaseNews(id);
    });
  }

  Future<void> deleteImage(int id, List images, String imageUrl) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return newsService.deleteImage(id, images, imageUrl, 'eklase_news', 'eklase_news');
    });
  }
}

final crudEklaseNewsControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider.autoDispose<CrudEklaseNewsController, AsyncValue<void>>(
        (ref) {
  return CrudEklaseNewsController(
    newsService: ref.watch(newsServiceProvider),
  );
});