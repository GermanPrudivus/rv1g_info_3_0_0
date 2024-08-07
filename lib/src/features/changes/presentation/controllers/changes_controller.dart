import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/changes_service.dart';
import '../../domain/models/changes.dart';

class ChangesController extends StateNotifier<AsyncValue<void>> {
  ChangesController({required this.changesService})
      : super(const AsyncData<void>(null));

  ChangesService changesService;

  Future<void> updateChanges(String tag, String imagePath, String imageUrl) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return changesService.updateChanges(tag, imagePath, imageUrl);
    });
  }

  Future<Map<String, Changes>?> getChanges() async {
    state = const AsyncLoading<void>();
    final AsyncValue<Map<String, Changes>> asyncValue = await AsyncValue.guard<Map<String, Changes>>(() {
      return changesService.getChanges();
    });
    state = asyncValue;
    return asyncValue.value;
  }
}

final changesControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider<ChangesController, AsyncValue<void>>(
        (ref) {
  return ChangesController(
    changesService: ref.watch(changesServiceProvider),
  );
});