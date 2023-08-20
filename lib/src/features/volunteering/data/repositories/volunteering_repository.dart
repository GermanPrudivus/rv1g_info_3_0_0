import 'dart:convert';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

import '../../domain/models/job.dart';

class VolunteeringRepository {
  final supabase = Supabase.instance.client;

  //CRUD SCHOOL NEWS PAGE
  Future<void> addJob(String title, String description, 
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
        await supabase.storage.from('volunteering_job').uploadBinary(
            filePath,
            bytes,
          );
        final res = supabase.storage
          .from('volunteering_job')
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
      .from('volunteering_job')
      .insert(
        toJson({
          'title': title,
          'description': jsonParagraphs,
          'media': jsonImages,
          'start_date': startDate,
          'end_date': endDate,
          'created_datetime': DateTime.now().toIso8601String()
        })
      );
  }

  Future<void> editJob(int id, String title, String description, 
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
        await supabase.storage.from('volunteering_job').uploadBinary(
            filePath,
            bytes,
          );
        final res = supabase.storage
          .from('volunteering_job')
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
      .from('volunteering_job')
      .update(
        toJson({
          'title': title,
          'description': jsonParagraphs,
          'media': jsonImages,
          'start_date': startDate,
          'end_date': endDate,
        })
      )
      .eq('id', id);
  }

  Future<void> updateImages(int id, List images, String imageUrl) async{
    List imagesEdited = images;
    imagesEdited.remove(imageUrl);

    await supabase
      .from('volunteering_job')
      .update({'media':imagesEdited})
      .eq('id', id);
  }

  Future<void> deleteImage(String imageUrl) async {
    await supabase
      .storage
      .from('volunteering_job')
      .remove([json.decode(imageUrl)['image_url'].split("/").last]);
  }

  Future<void> deleteJob(int id) async {
    await supabase
      .from('volunteering_job')
      .delete()
      .eq('id', id);
  }

  //Event page
  Future<List<Job>> getJobs() async {
    List<Job> events = [];
    
    final res = await supabase
      .from('volunteering_job')
      .select()
      .order('start_date', ascending: false);

    for(int i=0;i<res.length;i++){
      events.add(
        Job(
          id: res[i]['id'], 
          title: res[i]['title'], 
          description: List.from(res[i]['description']),
          media: List.from(res[i]['media']),
          startDate: res[i]['start_date'], 
          endDate: res[i]['end_date'], 
        )
      );
    }

    return events;
  }
}

final volunteeringRepositoryProvider = riverpod.Provider<VolunteeringRepository>((ref) {
  return VolunteeringRepository();
});