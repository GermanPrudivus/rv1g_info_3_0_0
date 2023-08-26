import 'dart:io';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

import '../../domain/models/app_user.dart';
import '../../domain/models/role.dart';

class SettingsRepository {
  final supabase = Supabase.instance.client;

  Future<AppUser> getUser() async {
    final supabase = Supabase.instance.client;

    final email = supabase.auth.currentUser?.email;
    final res = await supabase
      .from('users')
      .select()
      .eq('email', email);

    final form = await supabase
      .from('forms')
      .select()
      .eq('id', res[0]['form_id']);

    return AppUser(
      id: res[0]['id'], 
      profilePicUrl: res[0]['profile_pic_url'], 
      fullName: '${res[0]['name']} ${res[0]['surname']}',
      formId: res[0]['form_id'],
      form: '${form[0]['number'].toString()}.${form[0]['letter']}',
      email: email!, 
      verified: res[0]['verified'], 
      createdDateTime: res[0]['created_datetime']
    );
  }

  Future<String> updateProfilePicUrl(int id, String email, String profilePicPath) async {
    String profilePicUrl = "";

    if(profilePicPath != ""){
      final bytes = await File(profilePicPath).readAsBytes();
      final fileExt = File(profilePicPath).path.split('.').last;
      final fileName = '$email.${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;
      await supabase.storage.from('avatars').uploadBinary(
            filePath,
            bytes,
          );
        
      profilePicUrl = supabase.storage
          .from('avatars')
          .getPublicUrl(filePath);
    }

    final res = await supabase
      .from('users')
      .update({'profile_pic_url':profilePicUrl})
      .eq('id', id)
      .select();

    return res[0]['profile_pic_url'];
  }

  Future<void> updateUser(int id, String fullName, int formId) async {
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

    await supabase
      .from('users')
      .update({
        'name' : name,
        'surname' : surname,
        'form_id' : formId
      })
      .eq('id', id);
  }

  Future<void> updatePassword(int id, String newPassword) async {
    await supabase.auth.updateUser(
      UserAttributes(
        password: newPassword,
      ),
    );

    await supabase
      .from('users')
      .update({
        'password' : DBCrypt().hashpw(newPassword, DBCrypt().gensalt()),
      })
      .eq('id', id);
  }

  Future<void> deleteImage(String imageUrl, String bucket) async {
    await supabase
      .storage
      .from(bucket)
      .remove([imageUrl.split("/").last]);
  }

  Future<List<Role>> getUserRoles(int id) async {
    List<Role> roles = [];

    final res = await supabase
      .from('roles')
      .select()
      .eq('user_id', id);

    for(int i=0;i<res.length;i++){
      roles.add(
        Role(
          id: res[i]['id'], 
          role: res[i]['role'], 
          description: res[i]['description'], 
          userId: res[i]['user_id'], 
          startedDatetime: res[i]['started_datetime'], 
          endedDatetime: res[i]['ended_datetime'] ?? ""
        )
      );
    }

    return roles;
  }

  Future<void> logout() async {
    await supabase
      .auth
      .signOut();
  }

  Future<void> deleteUser() async {
    final user = await supabase.auth.currentUser!; 

    await supabase
      .auth.updateUser(
        UserAttributes(
          data: {'deleted':true}
        )
      );

    await supabase
      .from('users')
      .delete()
      .eq('email', user.email);
  }
}

final settingsRepositoryProvider = riverpod.Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});