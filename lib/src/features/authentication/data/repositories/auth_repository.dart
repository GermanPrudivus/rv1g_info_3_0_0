
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository{

}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});