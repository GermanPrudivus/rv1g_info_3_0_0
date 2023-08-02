import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rv1g_info/src/features/news/application/services/news_service.dart';

import '../../domain/models/answer.dart';
import '../../domain/models/poll.dart';
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

  Future<Map<int, Poll>?> getPolls(List<int> newsId) async {
    state = const AsyncLoading<void>();
    final AsyncValue<Map<int, Poll>> asyncValue = await AsyncValue.guard<Map<int, Poll>>(() {
      return newsService.getPolls(newsId);
    });
    state = asyncValue;
    return asyncValue.value;
  }

  Future<List<Answer>?> getAnswers(List<int> pollsId) async {
    state = const AsyncLoading<void>();
    final AsyncValue<List<Answer>> asyncValue = await AsyncValue.guard<List<Answer>>(() {
      return newsService.getAnswers(pollsId);
    });
    state = asyncValue;
    return asyncValue.value;
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