import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/auth_service.dart';

class SignInScreenController extends StateNotifier<AsyncValue<void>> {
  SignInScreenController({required this.authService})
      : super(const AsyncData<void>(null));

  AuthService authService;

  Future<bool?> signIn(String email, String password) async {
    state = const AsyncLoading<void>();
    final AsyncValue<bool> asyncValue = await AsyncValue.guard<bool>(() {
      return authService.signIn(email, password);
    });
    state = asyncValue;
    return asyncValue.value;
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
