import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../components/image_zoom_widget.dart';
import '../../../../constants/theme_colors.dart';
import '../../domain/models/job.dart';
import 'crud_volunteering_job_page.dart';

class VolunteeringJobPage extends StatelessWidget {
  final bool isAdmin;
  final Job job;
  
  const VolunteeringJobPage({
    required this.isAdmin,
    required this.job,
    super.key
  });

  String formatedText(List<String> text) {
    String formatedText = "";
    for(int i=0;i<text.length-1;i++){
      if(json.decode(text[i])['text']==""){
        formatedText = "$formatedText\n\n";
      } else if(json.decode(text[i])['text']!="" && json.decode(text[i+1])['text']!=""){
        formatedText = '${formatedText + json.decode(text[i])['text']}\n';
      } else {
        formatedText = formatedText + json.decode(text[i])['text'];
      }
    }

    if(text.isNotEmpty) {
      formatedText = formatedText+json.decode(text[text.length-1])['text'];
    }

    return formatedText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          splashRadius: 0.01,
          icon: Icon(
            Icons.chevron_left,
            color: blue, 
            size: 34.h,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if(isAdmin)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) {
                      return CRUDVolunteeringPage(
                        edit: true, 
                        jobId: job.id, 
                        title: job.title, 
                        description: formatedText(job.description), 
                        images: job.media,
                        startDate: DateTime.parse(job.startDate), 
                        endDate:DateTime.parse(job.endDate), 
                      );
                    }
                  )
                );
              },
              child: SizedBox(
                height: 50.h,
                width: 50.w,
                child: Icon(
                  Icons.edit,
                  color: blue,
                ),
              ),
            ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 5.h, bottom: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        job.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.w
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('dd.MM.yyyy. HH:mm', 'en_US')
                        .format(
                          DateTime.parse(job.startDate)
                        ),
                      style: TextStyle(
                        fontSize: 15.w,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      "-",
                      style: TextStyle(
                        fontSize: 15.w,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      DateFormat('dd.MM.yyyy. HH:mm', 'en_US')
                        .format(
                          DateTime.parse(job.endDate)
                        ),
                      style: TextStyle(
                        fontSize: 15.w,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: blue,
                  height: 10.h,
                  thickness: 3.h,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      StyledText(
                        text: formatedText(job.description),
                        style: TextStyle(
                          fontSize: 16.w,
                        ),
                        textAlign: TextAlign.start,
                        tags: {
                          'b': StyledTextTag(style: const TextStyle(fontWeight: FontWeight.bold)),
                          'u': StyledTextTag(style: const TextStyle(decoration: TextDecoration.underline)),
                          'i': StyledTextTag(style: const TextStyle(fontStyle:FontStyle.italic)),
                          'link': StyledTextActionTag(
                            (_, attrs) async {
                              await launchUrl(Uri.parse(attrs['href']!));
                            },
                            style: const TextStyle(color: Colors.lightBlue),
                          ),
                        },
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for(int i=0;i<job.media.length;i++)
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.w),
                          ),
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => buildImageZoom(context, json.decode(job.media[i])['image_url']),
                                barrierDismissible: true,
                              );
                            },
                            child: InteractiveViewer(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.w),
                                child: Image.network(
                                  json.decode(job.media[i])['image_url'],
                                  fit: BoxFit.cover,
                                ),
                              )
                            ),
                          )
                        )
                      ),
                    SizedBox(height: 10.h)
                  ],
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}