import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rv1g_info/src/features/news/application/services/news_service.dart';

import '../../domain/models/eklase_news.dart';

class EklaseController extends StateNotifier<AsyncValue<void>> {
  EklaseController({required this.newsService})
      : super(const AsyncData<void>(null));

  NewsService newsService;

  Future<List<EklaseNews>?> getEklaseNews() async {
    state = const AsyncLoading<void>();
    final AsyncValue<List<EklaseNews>> asyncValue = await AsyncValue.guard<List<EklaseNews>>(() {
      return newsService.getEklaseNews();
    });
    state = asyncValue;
    return asyncValue.value;
  }
}

final eklaseControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider<EklaseController, AsyncValue<void>>(
        (ref) {
  return EklaseController(
    newsService: ref.watch(newsServiceProvider),
  );
});