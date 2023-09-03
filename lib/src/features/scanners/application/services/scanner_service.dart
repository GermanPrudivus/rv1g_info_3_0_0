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

  Future<void> activateParticipant(int userId, int eventId) async {
    return await scannerRepository.activateParticipant(userId, eventId);
  }

  Future<List> getParticipant(int userId, int eventId) async {
    return await scannerRepository.getParticipant(userId, eventId);
  }
}

final scannerServiceProvider = Provider<ScannerService>((ref) {
  return ScannerService(
    scannerRepository: ref.watch(scannerRepositoryProvider),
  );
});