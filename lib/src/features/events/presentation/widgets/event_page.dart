import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rv1g_info/src/features/events/presentation/widgets/add_participant_page.dart';
import 'package:rv1g_info/src/features/events/presentation/widgets/crud_event_page.dart';
import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../components/image_zoom_widget.dart';
import '../../../../constants/theme_colors.dart';
import '../../doamain/models/event.dart';

class EventPage extends StatelessWidget {
  final bool isAdmin;
  final Event event;
  
  const EventPage({
    required this.isAdmin,
    required this.event,
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
                      return CRUDEventPage(
                        edit: true, 
                        eventId: event.id, 
                        title: event.title, 
                        shortText: event.shortText, 
                        startDate: DateTime.parse(event.startDate), 
                        endDate:DateTime.parse(event.endDate), 
                        description: formatedText(event.description), 
                        images: event.media
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
          if(isAdmin)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) {
                      return AddParticipantPage();
                    }
                  )
                );
              },
              child: SizedBox(
                height: 60.h,
                width: 50.w,
                child: Icon(
                  Icons.qr_code,
                  color: blue,
                ),
              ),
            )
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
                        event.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.h
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
                          DateTime.parse(event.startDate)
                        ),
                      style: TextStyle(
                        fontSize: 14.h,
                      ),
                    ),
                    Text(
                      "  -  ",
                      style: TextStyle(
                        fontSize: 14.h,
                      ),
                    ),
                    Text(
                      DateFormat('dd.MM.yyyy. HH:mm', 'en_US')
                        .format(
                          DateTime.parse(event.endDate)
                        ),
                      style: TextStyle(
                        fontSize: 14.h,
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
                        text: formatedText(event.description),
                        style: TextStyle(
                          fontSize: 15.h,
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
                    for(int i=0;i<event.media.length;i++)
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
                                builder: (context) => buildImageZoom(context, json.decode(event.media[i])['image_url']),
                                barrierDismissible: true,
                              );
                            },
                            child: InteractiveViewer(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.w),
                                child: Image.network(
                                  json.decode(event.media[i])['image_url'],
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