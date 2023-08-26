import 'dart:convert';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

import '../../domain/models/answer.dart';
import '../../domain/models/eklase_news.dart';
import '../../domain/models/poll.dart';
import '../../domain/models/school_news.dart';

class NewsRepository {
  final supabase = Supabase.instance.client;

  //CRUD SCHOOL NEWS PAGE
  Future<int> addSchoolNews(String text, List imagesPath, bool pin) async{
    final email = supabase.auth.currentUser!.email;

    final authorId = await supabase
      .from('users')
      .select('id')
      .eq('email', email);

    List jsonParagraphs = [];

    if(text != ""){
      List paragraphs = text.split('\n');

      jsonParagraphs = paragraphs.map((paragraph) {
        return json.encode({
          "text": paragraph,
        });
      }).toList();
    }

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
          'user_liked': [],
          'pin': pin,
          'created_datetime': DateTime.now().toIso8601String()
        })
      )
      .select();

    return res[0]['id'];
  }

  Future<void> editSchoolNews(int id, String text, List imagesUrls, List imagesPath, bool pin) async{
    final email = supabase.auth.currentUser!.email;

    List jsonParagraphs = [];

    if(text != ""){
      List paragraphs = text.split('\n');

      jsonParagraphs = paragraphs.map((paragraph) {
        return json.encode({
          "text": paragraph,
        });
      }).toList();
    }

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

  Future<int> addPoll(String title, DateTime pollEnd, int newsId) async{
    final res = await supabase
      .from('polls')
      .insert(
        toJson({
          'title': title,
          'all_votes': 0,
          'poll_start': DateTime.now().toIso8601String(),
          'poll_end': pollEnd.toIso8601String(),
          'news_id': newsId,
          'voted_users': []
        })
      )
      .select();

    return res[0]['id'];
  }

  Future<void> addAnswer(int pollId, String answer) async {
    await supabase
      .from('answers')
      .insert(
        toJson({
          'answer': answer,
          'votes': 0,
          'poll_id': pollId
        })
      );
  }

  Future<void> updatePoll(int id, String title, DateTime pollEnd) async{
    await supabase
      .from('polls')
      .update(
        toJson({
          'title': title,
          'poll_end': pollEnd.toIso8601String(),
        })
      )
      .eq('id', id);
  }

  Future<void> updateAnswer(int id, String answer) async {
    await supabase
      .from('answers')
      .update(
        toJson({
          'answer': answer,
        })
      )
      .eq('id', id);
  }

  Future<void> updateImages(int id, List images, String imageUrl, String table) async{
    List imagesEdited = images;
    imagesEdited.remove(imageUrl);

    await supabase
      .from(table)
      .update({'media':imagesEdited})
      .eq('id', id);
  }

  Future<void> deleteImage(String imageUrl, String bucket) async {
    await supabase
      .storage
      .from(bucket)
      .remove([json.decode(imageUrl)['image_url'].split("/").last]);
  }

  Future<void> deleteSchoolNews(int id) async {
    await supabase
      .from('news')
      .delete()
      .eq('id', id);
  }

  Future<void> deletePoll(int id) async {
    await supabase
      .from('polls')
      .delete()
      .eq('id', id);
  }

  Future<void> deleteAnswer(int id) async {
    await supabase
      .from('answers')
      .delete()
      .eq('id', id);
  }

  //SCHOOL PAGE
  Future<List<SchoolNews>> getSchoolNews() async{
    List<SchoolNews> news = [];

    final resNews = await supabase
      .from('news')
      .select()
      .order('pin', ascending: false)
      .order('created_datetime', ascending: false);

    for(int i=0;i<resNews.length;i++){
      //author
      final resAuthor = await supabase
        .from('users')
        .select()
        .eq('id', resNews[i]['author_id']);

      //poll
      final resPoll = await supabase
        .from('polls')
        .select()
        .eq('news_id', resNews[i]['id']);

      String authorName = "Nav noteikts";
      String authorAvatar = "";

      if(resAuthor.isNotEmpty){
        authorName = "${resAuthor[0]['name']} ${resAuthor[0]['surname']}";
        authorAvatar = resAuthor[0]['profile_pic_url'];
      }

      bool hasVoted = false;
      int choosedAnswer = 0;
      List<Answer> answers = [];
      Poll poll = Poll(
          id: 0,
          title: "",
          allVotes: 0,
          pollStart: DateTime.now().toIso8601String(),
          pollEnd: DateTime.now().toIso8601String(),
          answers: answers,
          newsId: 0,
          hasVoted: hasVoted,
          choosedAnswer: choosedAnswer
        );

      if(resPoll.isNotEmpty){
        List votedUsers = resPoll[0]['voted_users'];
        int userId = await getUserId();

        if(votedUsers.isNotEmpty){
          for(int i=0;i<votedUsers.length;i++){
            if(json.decode(votedUsers[i])['user_id'] == userId){
              hasVoted = true;
              choosedAnswer = json.decode(votedUsers[i])['answer_id'];
              break;
            }
          }
        }

        //answers
        final resAnswers = await supabase
          .from('answers')
          .select()
          .eq('poll_id', resPoll[0]['id'])
          .order('id', ascending: true);
    
        if(resAnswers != []){
          for(int i=0;i<resAnswers.length;i++){
            answers.add(Answer.fromJson(resAnswers[i]));
          }
        }

        poll = Poll(
            id: resPoll[0]['id'],
            title: resPoll[0]['title'],
            allVotes: resPoll[0]['all_votes'],
            pollStart: resPoll[0]['poll_start'],
            pollEnd: resPoll[0]['poll_end'],
            answers: answers,
            newsId: resNews[i]['id'],
            hasVoted: hasVoted,
            choosedAnswer: choosedAnswer
          );
      }

      SchoolNews oneNews = SchoolNews(
        id: resNews[i]['id'], 
        authorName: authorName, 
        authorAvatar: authorAvatar,
        text: List.from(resNews[i]['text']), 
        media: List.from(resNews[i]['media']), 
        likes: resNews[i]['likes'],
        userLiked: false,
        pin: resNews[i]['pin'],
        poll: poll,
        createdDateTime: resNews[i]['created_datetime']
      );

      news.add(oneNews);
    }

    return news;
  }

  Future<void> updateVotes(int pollId, int answerId, int userdId) async{
    final res1 = await supabase
      .from('polls')
      .select()
      .eq('id', pollId);

    List votedUsers = res1[0]['voted_users'];

    votedUsers.add(
      json.encode({
        "user_id": userdId,
        "answer_id": answerId,
      })
    );

    await supabase
      .from('polls')
      .update({
        'all_votes': res1[0]['all_votes']+1,
        'voted_users': votedUsers
      })
      .eq('id', pollId);

    final res2 = await supabase
      .from('answers')
      .select('votes')
      .eq('id', answerId);

    await supabase
      .from('answers')
      .update({'votes': res2[0]['votes']+1})
      .eq('id', answerId);
  }

  //CRUD Eklase News Page
  Future<void> addEklaseNews(String title, String author, 
    String shortText, String text, List imagesPath, bool pin) async{

    List jsonParagraphs = [];

    if(text != ""){
      List paragraphs = text.split('\n');

      jsonParagraphs = paragraphs.map((paragraph) {
        return json.encode({
          "text": paragraph,
        });
      }).toList();
    }

    List<String> images = [];

    if(imagesPath.isNotEmpty) {
      for(int i=0;i<imagesPath.length;i++){
        final bytes = await File(imagesPath[i]).readAsBytes();
        final fileExt = File(imagesPath[i]).path.split('.').last;
        final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
        final filePath = fileName;
        await supabase.storage.from('eklase_news').uploadBinary(
            filePath,
            bytes,
          );
        final res = supabase.storage
          .from('eklase_news')
          .getPublicUrl(filePath);

        images.add(res);
      }
    }

    List jsonImages = images.map((image) {
      return json.encode({
        "image_url": image,
      });
    }).toList();

    await supabase
      .from('eklase_news')
      .insert(
        toJson({
          'title': title,
          'author': author,
          'short_text': shortText,
          'text': jsonParagraphs,
          'media': jsonImages,
          'pin': pin,
          'created_datetime': DateTime.now().toIso8601String()
        })
      );
  }

  Future<void> editEklaseNews(int newsId, String title, String author, 
    String shortText, String text, List imagesPath, List imagesUrls, bool pin) async{

    List jsonParagraphs = [];

    if(text != ""){
      List paragraphs = text.split('\n');

      jsonParagraphs = paragraphs.map((paragraph) {
        return json.encode({
          "text": paragraph,
        });
      }).toList();
    }

    List<String> images = [];

    if(imagesPath.isNotEmpty) {
      for(int i=0;i<imagesPath.length;i++){
        final bytes = await File(imagesPath[i]).readAsBytes();
        final fileExt = File(imagesPath[i]).path.split('.').last;
        final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
        final filePath = fileName;
        await supabase.storage.from('eklase_news').uploadBinary(
            filePath,
            bytes,
          );
        final res = supabase.storage
          .from('eklase_news')
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
      .from('eklase_news')
      .update(
        toJson({
          'title': title,
          'author': author,
          'short_text': shortText,
          'text': jsonParagraphs,
          'media': jsonImages,
          'pin': pin,
        })
      )
      .eq('id', newsId);
  }

  Future<void> deleteEklaseNews(int id) async {
    await supabase
      .from('eklase_news')
      .delete()
      .eq('id', id);
  }

  //EKLASE PAGE
  Future<List<EklaseNews>> getEklaseNews() async{
    final res = await supabase
      .from('eklase_news')
      .select()
      .order('pin', ascending: false)
      .order('created_datetime', ascending: false);

    List<EklaseNews> news = [];

    for(int i=0;i<res.length;i++){
      news.add(EklaseNews(
        id: res[i]['id'],
        title: res[i]['title'],
        author: res[i]['author'],
        shortText: res[i]['short_text'],
        text: List.from(res[i]['text']),
        media: List.from(res[i]['media']),
        pin: res[i]['pin'],
        createdDateTime: res[i]['created_datetime']
      ));
    }

    return news;
  }

  Future<int> getUserId() async{
    String email = supabase.auth.currentUser!.email!;

    final res = await supabase
      .from('users')
      .select('id')
      .eq('email', email);

    return res[0]['id'];
  }
}

final newsRepositoryProvider = riverpod.Provider<NewsRepository>((ref) {
  return NewsRepository();
});