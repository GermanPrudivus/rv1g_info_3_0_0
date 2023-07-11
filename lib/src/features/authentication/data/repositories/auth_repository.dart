import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  Future<void> signIn(String email, String password) async {
    print("AuthRepository");
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
