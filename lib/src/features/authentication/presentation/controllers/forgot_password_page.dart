import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/auth_service.dart';

class ForgotPasswordScreenController extends StateNotifier<AsyncValue<void>> {
  ForgotPasswordScreenController({required this.authService})
      : super(const AsyncData<void>(null));

  AuthService authService;

  Future<void> resetPassword(String email) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(
      () => authService.resetPassword(email),
    );
  }
}

final forgotPasswordScreenControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider.autoDispose<ForgotPasswordScreenController, AsyncValue<void>>(
        (ref) {
  return ForgotPasswordScreenController(
    authService: ref.watch(authServiceProvider),
  );
});