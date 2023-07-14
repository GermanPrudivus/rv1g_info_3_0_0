import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository.dart';

class AuthService {
  AuthService({
    required this.authRepository,
  });

  final AuthRepository authRepository;

  Future<void> signIn(String email, String password) async {
    await authRepository.signIn(email, password);
  }

  Future<void> signUp(String avatarUrl, String email, String fullName, int form, String password) async {
    await authRepository.signUp(avatarUrl, email, fullName, form, password);
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    authRepository: ref.watch(authRepositoryProvider),
  );
});
