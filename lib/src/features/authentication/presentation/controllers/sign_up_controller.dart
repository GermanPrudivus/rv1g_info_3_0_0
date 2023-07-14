import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/auth_services.dart';

class SignUpScreenController extends StateNotifier<AsyncValue<void>> {
  // set the initial value
  SignUpScreenController({required this.authService})
      : super(const AsyncData<void>(null));

  AuthService authService;

  Future<void> signUp(String avatarUrl, String email, String fullName, int form, String password) async {
    // set the state to loading
    state = const AsyncLoading<void>();
    // call `authRepository.signIn` and await for the result
    state = await AsyncValue.guard<void>(
      () => authService.signUp(avatarUrl, email, fullName, form, password),
    );
  }
  
}

final signUpScreenControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider.autoDispose<SignUpScreenController, AsyncValue<void>>(
        (ref) {
  return SignUpScreenController(
    authService: ref.watch(authServiceProvider),
  );
});