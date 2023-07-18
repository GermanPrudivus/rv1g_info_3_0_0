import 'dart:io';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

class AuthRepository {

  Future<void> signIn(String email, String password) async {
    print(email+" "+password);
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

  Future<bool> verifyEmail() async{
    final supabase = Supabase.instance.client;

    String verified = "";

    verified = supabase.auth.currentUser!.emailConfirmedAt!;

    print(verified);

    if(verified=="") {
      return false;
    } else {
      return true;
    }
  }

  Future<void> createUserInDB(
    String avatarPath, String email, String fullName, int form, String password) async {

    final supabase = Supabase.instance.client;

    final res = await supabase.from('users').select(
          '*',
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

    await supabase
      .auth
      .signUp(
        email: email,
        password: password,
      );

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
      imageUrlResponse = await supabase.storage
          .from('avatars')
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 20);
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
