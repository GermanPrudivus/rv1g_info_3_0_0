import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/auth_service.dart';

class SignUpScreenController extends StateNotifier<AsyncValue<void>> {
  SignUpScreenController({required this.authService})
      : super(const AsyncData<void>(null));

  AuthService authService;

  Future<void> signUp(String avatarPath, String email, String fullName, int form, String password) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(
      () => authService.signUp(avatarPath, email, fullName, form, password),
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