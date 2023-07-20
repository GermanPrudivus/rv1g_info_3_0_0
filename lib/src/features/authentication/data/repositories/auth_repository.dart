import 'dart:io';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

class AuthRepository {

  Future<void> signIn(String email, String password) async {
    final supabase = Supabase.instance.client;

    await supabase
      .auth
      .signInWithPassword(
        email: email,
        password: password
      );
  }

  Future findCurrentUser(String email) async{
    final supabase = Supabase.instance.client;

    final response = await supabase
      .from('users')
      .select()
      .eq('email', email);

    if(response.length == 0){
      return false;
    } else {
      return true;
    }
  }

  Future<void> signUp(String email, String password) async {

    final supabase = Supabase.instance.client;

    await supabase
      .auth
      .signUp(
        email: email,
        password: password,
      );
  }

  Future<void> createUserInDB(
    String avatarPath, String email, String fullName, int form, String password) async {

    final supabase = Supabase.instance.client;

    final res = await supabase.from('users').select(
          'id',
          const FetchOptions(
            count: CountOption.exact,
          ),
        );

    final count = res.count;

    final fullname = fullName.split(" ");

    late String name;
    late String surname;

    if(fullname.length == 3){
      name = fullname[0]+fullname[1];
      surname = fullname[2];
    } else {
      name = fullname[0];
      surname = fullname[1];
    }

    String imageUrlResponse = "";

    if(avatarPath != "") {
      final bytes = await File(avatarPath).readAsBytes();
      final fileExt = File(avatarPath).path.split('.').last;
      final fileName = '$email.${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;
      await supabase.storage.from('avatars').uploadBinary(
            filePath,
            bytes,
          );
      imageUrlResponse = supabase.storage
          .from('avatars')
          .getPublicUrl(filePath);
    }

    await supabase
      .from('users')
      .insert(
        toJson({
          'id': count+1,
          'profilePicUrl': imageUrlResponse,
          'name': name,
          'surname': surname,
          'formId': form,
          'email': email,
          'password': DBCrypt().hashpw(password, DBCrypt().gensalt()),
          'verified': false,
          'createdDateTime': DateTime.now().toIso8601String()
        })
      );
  }

  Stream<AuthState> authStateChange() async*{
    Supabase.instance.client.auth.onAuthStateChange;
  }
}

final authRepositoryProvider = riverpod.Provider<AuthRepository>((ref) {
  return AuthRepository();
});
