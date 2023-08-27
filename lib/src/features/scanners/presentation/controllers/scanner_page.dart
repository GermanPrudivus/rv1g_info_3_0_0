import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/scanner_service.dart';
import '../../domain/models/participant.dart';

class ScannerController extends StateNotifier<AsyncValue<void>> {
  ScannerController({required this.scannerService})
      : super(const AsyncData<void>(null));

  ScannerService scannerService;

  Future<List<Participant>?> getParticipants(int eventId) async {
    state = const AsyncLoading<void>();
    final AsyncValue<List<Participant>> asyncValue = await AsyncValue.guard<List<Participant>>(() {
      return scannerService.getParticipants(eventId);
    });
    state = asyncValue;
    return asyncValue.value;
  }
}

final scannerControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider<ScannerController, AsyncValue<void>>(
        (ref) {
  return ScannerController(
    scannerService: ref.watch(scannerServiceProvider),
  );
});