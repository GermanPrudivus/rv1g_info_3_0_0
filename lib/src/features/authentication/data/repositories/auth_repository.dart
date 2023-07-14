import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {

  Future<void> signIn(String email, String password) async {
    print(email+" "+password);
  }

  Future<void> signUp(String avatarUrl, String email, String fullName, int form, String password) async {
    print(avatarUrl+" "+email+" "+fullName+" "+form.toString()+" "+password);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
