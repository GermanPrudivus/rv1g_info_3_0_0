import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

import '../../doamain/models/event.dart';

class EventRepository {
  final supabase = Supabase.instance.client;

  //CRUD SCHOOL NEWS PAGE
  Future<void> addEvent(String title, String shortText, String description, 
    String startDate, String endDate, List imagesPath) async{

    List jsonParagraphs = [];

    if(description != ""){
      List paragraphs = description.split('\n');

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
        await supabase.storage.from('event').uploadBinary(
            filePath,
            bytes,
          );
        final res = supabase.storage
          .from('event')
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
      .from('events')
      .insert(
        toJson({
          'title': title,
          'short_text': shortText,
          'description': jsonParagraphs,
          'participant_quant': 0,
          'start_date': startDate,
          'end_date': endDate,
          'key': Random().nextInt(1000000000)+1000000000,
          'media': jsonImages,
          'created_datetime': DateTime.now().toIso8601String()
        })
      );
  }

  Future<void> addRole(String title, String email, String endDate) async {
    final res = await supabase
      .from('users')
      .select()
      .eq('email', email);

    await supabase
      .from('roles')
      .insert({
        'role' : 'Pasākumu organizators ${title}',
        'description' : 'Tev ir iespēja pievienot sava pasākuma dalībniekus un atļauta pieeja QR kodu skeneru sadaļai.',
        'user_id' : res[0]['id'],
        'started_datetime': DateTime.now().toIso8601String(),
        'ended_datetime' : endDate
      });
  }

  Future<void> editEvent(
    int id, String title, String shortText, String description, 
    String startDate, String endDate, List imagesPath, List imagesUrls) async{

    List jsonParagraphs = [];

    if(description != ""){
      List paragraphs = description.split('\n');

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
        await supabase.storage.from('event').uploadBinary(
            filePath,
            bytes,
          );
        final res = supabase.storage
          .from('event')
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

    final res = await supabase
      .from('events')
      .select()
      .eq('id', id);

    await supabase
      .from('events')
      .update(
        toJson({
          'title': title,
          'short_text': shortText,
          'description': jsonParagraphs,
          'start_date': startDate,
          'end_date': endDate,
          'media': jsonImages,
        })
      )
      .eq('id', id);

    await supabase
      .from('roles')
      .update({
        'ended_datetime':endDate,
        'role':'Pasākumu organizators ${title}'
      })
      .eq('role', 'Pasākumu organizators ${res[0]['title']}');
  }

  Future<void> updateImages(int id, List images, String imageUrl) async{
    List imagesEdited = images;
    imagesEdited.remove(imageUrl);

    await supabase
      .from('events')
      .update({'media':imagesEdited})
      .eq('id', id);
  }

  Future<void> deleteImage(String imageUrl) async {
    await supabase
      .storage
      .from('event')
      .remove([json.decode(imageUrl)['image_url'].split("/").last]);
  }

  Future<void> deleteEvent(int id) async {
    await supabase
      .from('events')
      .delete()
      .eq('id', id);
  }

  Future<void> deleteRole(int eventId) async {
    final res = await supabase
      .from('events')
      .select()
      .eq('id', eventId);

    await supabase
      .from('roles')
      .delete()
      .eq('role', 'Pasākumu organizators ${res[0]['title']}');
  }

  //Event page
  Future<List<Event>> getEvents() async {
    List<Event> events = [];
    
    final res = await supabase
      .from('events')
      .select()
      .order('start_date', ascending: false);

    for(int i=0;i<res.length;i++){
      events.add(
        Event(
          id: res[i]['id'], 
          title: res[i]['title'], 
          shortText: res[i]['short_text'], 
          description: List.from(res[i]['description']), 
          participantQuant: res[i]['participant_quant'], 
          startDate: res[i]['start_date'], 
          endDate: res[i]['end_date'], 
          key: res[i]['key'], 
          media: List.from(res[i]['media'])
        )
      );
    }

    return events;
  }
}

final eventRepositoryProvider = riverpod.Provider<EventRepository>((ref) {
  return EventRepository();
});