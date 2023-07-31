import 'dart:convert';
import 'dart:io';

import 'package:rv1g_info/src/features/news/domain/models/author_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

import '../../domain/models/answer.dart';
import '../../domain/models/poll.dart';
import '../../domain/models/school_news.dart';

class NewsRepository {
  Future<int> addSchoolNews(String text, List imagesPath, bool pin) async{
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
          'created_datetime': DateTime.now().toIso8601String()
        })
      )
      .select();

    return res[0]['id'];
  }

  Future<void> editSchoolNews(int id, String text, List imagesUrls, List imagesPath, bool pin) async{
    final supabase = Supabase.instance.client;

    final email = supabase.auth.currentUser!.email;

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

        images.add(res);
      }
    }

    List jsonImages = images.map((image) {
      return json.encode({
        "image_url": image,
      });
    }).toList();

    jsonImages = imagesUrls + jsonImages;

    await supabase
      .from('news')
      .update(
        toJson({
          'text': jsonParagraphs,
          'media': jsonImages,
          'pin': pin,
        })
      )
      .eq('id', id);
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

  Future<void> editPoll(
    int id, String title, int answer1Id, int answer2Id, int answer3Id, int answer4Id, 
    String answer1, String answer2, String answer3, String answer4, DateTime pollEnd) async{

    final supabase = Supabase.instance.client;

    await supabase
      .from('poll')
      .update(
        toJson({
          'title': title,
          'poll_end': pollEnd.toIso8601String(),
        })
      )
      .eq('id', id);

    await supabase
      .from('answer')
      .update(
        toJson({
          'answer': answer1,
        })
      )
      .eq('id', answer1Id);

    await supabase
      .from('answer')
      .update(
        toJson({
          'answer': answer2,
        })
      )
      .eq('id', answer2Id);

    if(answer3 == "" && answer3Id != 0){
      await supabase
        .from('answer')
        .delete()
        .eq('id', answer3Id);
    } else if (answer3 != "" && answer3Id == 0){
      await supabase
        .from('answer')
        .insert(
          toJson({
            'answer': answer3,
            'votes': 0,
            'poll_id':id
          })
        );
    } else if (answer3Id != 0){
      await supabase
        .from('answer')
        .update(
          toJson({
            'answer': answer3,
          })
        )
        .eq('id', answer3Id);
    }

    if(answer4 == "" && answer4Id != 0){
      await supabase
        .from('answer')
        .delete()
        .eq('id', answer4Id);
    } else if (answer4 != "" && answer4Id == 0){
      await supabase
        .from('answer')
        .insert(
          toJson({
            'answer': answer4,
            'votes': 0,
            'poll_id':id
          })
        );
    } else if (answer4Id != 0){
      await supabase
        .from('answer')
        .update(
          toJson({
            'answer': answer4,
          })
        )
        .eq('id', answer4Id);
    }
  }

  Future<List<SchoolNews>> getSchoolNews() async{
    final supabase = Supabase.instance.client;

    final res = await supabase
      .from('news')
      .select()
      .order('created_datetime', ascending: false);

    List<SchoolNews> news = [];

    for(int i=0;i<res.length;i++){
      news.add(SchoolNews.fromJson(res[i]));
    }

    return news;
  }

  Future<List<AuthorData>> getAuthorData(List<int> authorId) async{
    final supabase = Supabase.instance.client;

    List<AuthorData> authorData = [];

    for(int i=0;i<authorId.length;i++){
      final res = await supabase
        .from('users')
        .select()
        .eq('id', authorId[i]);

      authorData.add(AuthorData(
        id: authorId[i], 
        fullName: "${res[0]['name']} ${res[0]['surname']}", 
        avatarUrl: res[0]['profile_pic_url']
      ));
    }
    
    return authorData;
  }

  Future<Map<int, Poll>> getPolls(List<int> newsId) async{
    final supabase = Supabase.instance.client;

    Map<int, Poll> polls = {};
    
    for(int i=0;i<newsId.length;i++){
      final res = await supabase
        .from('poll')
        .select()
        .eq('news_id', newsId[i]);

      if(res.isNotEmpty){
        polls[newsId[i]] = Poll.fromJson(res[0]);
      }
    }

    return polls;
  }

  Future<List<Answer>> getAnswers(List<int> pollsId) async{
    final supabase = Supabase.instance.client;

    List<Answer> answers = [];

    for(int j=0;j<pollsId.length;j++){
      final res = await supabase
        .from('answer')
        .select()
        .eq('poll_id', pollsId[j]);
    
      if(res != []){
        for(int i=0;i<res.length;i++){
          answers.add(Answer.fromJson(res[i]));
        }
      }
    }
    
    return answers;
  }

  Future<void> deleteImage(int id, List images, String imageUrl) async {
    final supabase = Supabase.instance.client;

    List imagesEdited = images;
    imagesEdited.remove(imageUrl);

    await supabase
      .from('news')
      .update({'media':imagesEdited})
      .eq('id', id);

    await supabase
      .storage
      .from("news")
      .remove([json.decode(imageUrl)['image_url'].split("/").last]);
  }

}

final newsRepositoryProvider = riverpod.Provider<NewsRepository>((ref) {
  return NewsRepository();
});