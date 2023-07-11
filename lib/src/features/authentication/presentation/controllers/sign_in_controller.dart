import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/auth_services.dart';

class SignInScreenController extends StateNotifier<AsyncValue<void>> {
  // set the initial value
  SignInScreenController({required this.authService})
      : super(const AsyncData<void>(null));

  AuthService authService;

  Future<void> signIn(String email, String password) async {
    // set the state to loading
    state = const AsyncLoading<void>();
    // call `authRepository.signIn` and await for the result
    state = await AsyncValue.guard<void>(
      () => authService.signIn(email, password),
    );
  }
}

final signInScreenControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider.autoDispose<SignInScreenController, AsyncValue<void>>(
        (ref) {
  return SignInScreenController(
    authService: ref.watch(authServiceProvider),
  );
});
