import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/auth_services.dart';

class EmailVerificationScreenController extends StateNotifier<AsyncValue<void>> {
  // set the initial value
  EmailVerificationScreenController({required this.authService})
      : super(const AsyncData<void>(null));

  AuthService authService;

  Future<void> verifyEmail() async {
    // set the state to loading
    state = const AsyncLoading<void>();
    // call `authRepository.signUn` and await for the result
    state = await AsyncValue.guard<void>(
      () => authService.verifyEmail(),
    );
  }
  
}

final emailVerificationScreenControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider.autoDispose<EmailVerificationScreenController, AsyncValue<void>>(
        (ref) {
  return EmailVerificationScreenController(
    authService: ref.watch(authServiceProvider),
  );
});