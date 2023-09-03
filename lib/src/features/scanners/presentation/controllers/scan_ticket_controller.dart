import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/scanner_service.dart';

class ScanTicketController extends StateNotifier<AsyncValue<void>> {
  ScanTicketController({required this.scannerService})
      : super(const AsyncData<void>(null));

  ScannerService scannerService;

  Future<void> activateParticipant(int userId, int eventId) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return scannerService.activateParticipant(userId, eventId);
    });
  }

  Future<List?> getParticipant(int userId, int eventId) async {
    state = const AsyncLoading<void>();
    final AsyncValue<List> asyncValue = await AsyncValue.guard<List>(() {
      return scannerService.getParticipant(userId, eventId);
    });
    state = asyncValue;
    return asyncValue.value;
  }
}

final scanTicketControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider<ScanTicketController, AsyncValue<void>>(
        (ref) {
  return ScanTicketController(
    scannerService: ref.watch(scannerServiceProvider),
  );
});