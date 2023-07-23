import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

class NewsRepository {
  Future<String> getProfilePicUrl() async{
    final supabase = Supabase.instance.client;

    final email = supabase.auth.currentUser?.email;
    final res = await supabase
      .from('users')
      .select('profilePicUrl')
      .eq('email', email);

    final profilePicUrl = res[0]['profilePicUrl'];

    return await profilePicUrl;
  }
}

final newsRepositoryProvider = riverpod.Provider<NewsRepository>((ref) {
  return NewsRepository();
});