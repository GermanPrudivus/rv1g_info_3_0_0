import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository.dart';

class AuthService {
  AuthService({
    required this.authRepository,
  });

  final AuthRepository authRepository;

  Future<bool> signIn(String email, String password) async {
    await authRepository.signIn(email, password);
    return await authRepository.checkUserDeleted();
  }

  Future<void> signUp(String avatarPath, String email, String fullName, int form, String password) async {
    await authRepository.signUp(email, password);
    if(!await authRepository.findCurrentUser(email)){
      await authRepository.createUserInDB(avatarPath, email, fullName, form, password);
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
