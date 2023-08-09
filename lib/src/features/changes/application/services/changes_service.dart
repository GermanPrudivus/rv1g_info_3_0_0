import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rv1g_info/src/constants/const.dart';
import 'package:rv1g_info/src/features/changes/data/repositories/changes_repository.dart';

import '../../domain/models/changes.dart';

class ChangesService {
  ChangesService({
    required this.changesRepository,
  });

  final ChangesRepository changesRepository;

  Future<void> updateChanges(String tag, String imagePath, String imageUrl) async{
    if(imageUrl != noChanges && imagePath == ""){
      return await changesRepository.deleteChanges(tag, imageUrl);
    } else if(imagePath != ""){
      return await changesRepository.updateChanges(tag, imagePath, imageUrl);
    }
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