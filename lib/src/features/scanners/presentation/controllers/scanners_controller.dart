import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/scanner_service.dart';
import '../../domain/models/scanner.dart';

class ScannersController extends StateNotifier<AsyncValue<void>> {
  ScannersController({required this.scannerService})
      : super(const AsyncData<void>(null));

  ScannerService scannerService;

  Future<List<Scanner>?> getScanners() async {
    state = const AsyncLoading<void>();
    final AsyncValue<List<Scanner>> asyncValue = await AsyncValue.guard<List<Scanner>>(() {
      return scannerService.getScanners();
    });
    state = asyncValue;
    return asyncValue.value;
  }
}

final scannersControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider<ScannersController, AsyncValue<void>>(
        (ref) {
  return ScannersController(
    scannerService: ref.watch(scannerServiceProvider),
  );
});