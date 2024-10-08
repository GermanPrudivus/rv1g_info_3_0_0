import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/auth_service.dart';

class SignInScreenController extends StateNotifier<AsyncValue<void>> {
  SignInScreenController({required this.authService}) : super(const AsyncData<void>(null));

  AuthService authService;

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() {
      return authService.signIn(email, password);
    });
  }
}

final signInScreenControllerProvider = StateNotifierProvider.autoDispose<SignInScreenController, AsyncValue<void>>((ref) {
  return SignInScreenController(
    authService: ref.watch(authServiceProvider),
  );
});
