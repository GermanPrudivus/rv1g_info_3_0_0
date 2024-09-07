import 'dart:io';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

class AuthRepository {
  final supabase = Supabase.instance.client;

  Future<void> signIn(String email, String password) async {
    await supabase
      .auth
      .signInWithPassword(
        email: email,
        password: password
      );
  }

  Future<bool> findCurrentUser(String email) async{
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

  Future<String> signUp(String email, String password) async {
    final res = await supabase
      .auth
      .signUp(
        email: email,
        password: password,
      );

    return res.user!.id;
  }

  Future<void> createUserInDB(String uid, String avatarPath, String email, 
     String fullName, int form, String password) async {

    final fullname = fullName.split(" ");

    late String name;
    late String surname;

    if(fullname.length == 3){
      name = fullname[0]+" "+fullname[1];
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
          'uid': uid,
          'profile_pic_url': imageUrlResponse,
          'name': name,
          'surname': surname,
          'form_id': form,
          'email': email,
          'password': DBCrypt().hashpw(password, DBCrypt().gensalt()),
          'verified': false,
          'created_datetime': DateTime.now().toIso8601String()
        })
      );
  }

  Future<void> resetPassword(String email) async {
    await supabase
      .auth
      .resetPasswordForEmail(email);
  }
}

final authRepositoryProvider = riverpod.Provider<AuthRepository>((ref) {
  return AuthRepository();
});
