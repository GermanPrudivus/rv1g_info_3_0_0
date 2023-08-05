import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rv1g_info/src/features/changes/data/repositories/changes_repository.dart';

import '../../domain/models/changes.dart';

class ChangesService {
  ChangesService({
    required this.changesRepository,
  });

  final ChangesRepository changesRepository;

  Future<void> addChanges(String tag, String imagePath) async{
    return await changesRepository.addChanges(tag, imagePath);
  }

  Future<void> deleteChanges(String tag, String imageUrl) async {
    return await changesRepository.deleteChanges(tag, imageUrl);
  }

  Future<Map<String, Changes>> getChanges() async{
    return await changesRepository.getChanges();
  }
}

final changesServiceProvider = Provider<ChangesService>((ref) {
  return ChangesService(
    changesRepository: ref.watch(changesRepositoryProvider),
  );
});