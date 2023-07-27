import 'dart:convert';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

class NewsRepository {
  Future<int> addSchoolNews(String text, List imagesPath, bool pin, bool hasPoll) async{
    final supabase = Supabase.instance.client;

    final email = supabase.auth.currentUser!.email;

    final authorId = await supabase
      .from('users')
      .select('id')
      .eq('email', email);

    List paragraphs = text.split('\n');

    List jsonParagraphs = paragraphs.map((paragraph) {
      return json.encode({
        "text": paragraph,
      });
    }).toList();

    List<String> images = [];

    if(imagesPath.isNotEmpty) {
      for(int i=0;i<imagesPath.length;i++){
        final bytes = await File(imagesPath[i]).readAsBytes();
        final fileExt = File(imagesPath[i]).path.split('.').last;
        final fileName = '$email.${DateTime.now().toIso8601String()}.$fileExt';
        final filePath = fileName;
        await supabase.storage.from('news').uploadBinary(
            filePath,
            bytes,
          );
        final res = supabase.storage
          .from('news')
          .getPublicUrl(filePath);
        
        print(res);
        images.add(res);
      }
    }

    List jsonImages = images.map((image) {
      return json.encode({
        "image_url": image,
      });
    }).toList();

    final res = await supabase
      .from('news')
      .insert(
        toJson({
          'author_id': authorId[0]['id'],
          'text': jsonParagraphs,
          'media': jsonImages,
          'likes': 0,
          'pin': pin,
          'has_poll': hasPoll,
          'created_datetime': DateTime.now().toIso8601String()
        })
      )
      .select();

    print(res[0]['id']);

    return res[0]['id'];
  }

  Future<void> addPoll(
    String title, String answer1, String answer2, String answer3, String answer4, DateTime pollEnd, int newsId) async{
    final supabase = Supabase.instance.client;

    final res = await supabase
      .from('poll')
      .insert(
        toJson({
          'title': title,
          'all_votes': 0,
          'poll_start': DateTime.now().toIso8601String(),
          'poll_end': pollEnd.toIso8601String(),
          'news_id': newsId
        })
      )
      .select();

    print(res[0]);
    int pollId = res[0]['id'];

    await supabase
      .from('answer')
      .insert(
        toJson({
          'answer': answer1,
          'votes': 0,
          'poll_id': pollId
        })
      );

    await supabase
      .from('answer')
      .insert(
        toJson({
          'answer': answer2,
          'votes': 0,
          'poll_id': pollId
        })
      );

    if(answer3 != ""){
      await supabase
        .from('answer')
        .insert(
          toJson({
            'answer': answer3,
            'votes': 0,
            'poll_id': pollId
          })
        );
    }

    if(answer4 != ""){
      await supabase
        .from('answer')
        .insert(
          toJson({
            'answer': answer4,
            'votes': 0,
            'poll_id': pollId
          })
        );
    }
  }

}

final newsRepositoryProvider = riverpod.Provider<NewsRepository>((ref) {
  return NewsRepository();
});