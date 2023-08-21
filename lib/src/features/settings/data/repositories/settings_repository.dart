import 'dart:convert';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

import '../../domain/models/app_user.dart';

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
      .from('form')
      .select()
      .eq('', res[0]['formId']);

    return AppUser(
      id: res[0]['id'], 
      profilePicUrl: res[0]['profile_pic_url'], 
      fullName: '${res[0]['name']} ${res[0]['surname']}', 
      form: '${form[0]['number'].toString()}.${form[0]['letter']}',
      email: email!, 
      verified: res[0]['verified'], 
      createdDateTime: res[0]['created_datetime']
    );
  }

  /*Future<void> deleteItem(int id) async {
    await supabase
      .from('shop_item')
      .delete()
      .eq('id', id);
  }*/
}

final settingsRepositoryProvider = riverpod.Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});