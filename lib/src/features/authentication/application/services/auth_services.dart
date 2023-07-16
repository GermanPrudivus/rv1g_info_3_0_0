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
      await authRepository.signUp(avatarPath, email, fullName, form, password);
    } else {
      print('User already exists');
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    authRepository: ref.watch(authRepositoryProvider),
  );
});
