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

  Future<void> signUp(String avatarPath, String email, String fullName, int form, String password) async {
    if(!await authRepository.findCurrentUser(email)){
      final uid = await authRepository.signUp(email, password);
      await authRepository.createUserInDB(uid, avatarPath, email, fullName, form, password);
    }
  }

  Future<void> resetPassword(String email) async {
    await authRepository.resetPassword(email);
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    authRepository: ref.watch(authRepositoryProvider),
  );
});
