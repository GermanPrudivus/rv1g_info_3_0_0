import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/scanner_repository.dart';
import '../../domain/models/participant.dart';
import '../../domain/models/scanner.dart';

class ScannerService {
  ScannerService({
    required this.scannerRepository,
  });

  final ScannerRepository scannerRepository;

  Future<List<Scanner>> getScanners() async {
    return await scannerRepository.getScanners();
  }

  Future<List<Participant>> getParticipants(int eventId) async {
    return await scannerRepository.getParticipants(eventId);
  }

  /*Future<String> updateProfilePicUrl(int id, String email, 
    String profilePicPath, String avatarUrl) async {

    await settingsRepository.deleteImage(avatarUrl, 'avatars');
    return await settingsRepository.updateProfilePicUrl(id, email, profilePicPath);
  }

  Future<void> updateUser(int id, String fullName, int formId, String newPassword) async {
    await settingsRepository.updateUser(id, fullName, formId);
    if(newPassword.isNotEmpty){
      await settingsRepository.updatePassword(id, newPassword);
    }
  }

  Future<List<Role>> getUserRoles(int id) async {
    return await settingsRepository.getUserRoles(id);
  }

  Future<void> logout() async {
    return await settingsRepository.logout();
  }

  Future<void> deleteUser(String avatarUrl) async {
    await settingsRepository.deleteImage(avatarUrl, 'avatars');
    await settingsRepository.deleteUser();
  }*/
}

final scannerServiceProvider = Provider<ScannerService>((ref) {
  return ScannerService(
    scannerRepository: ref.watch(scannerRepositoryProvider),
  );
});