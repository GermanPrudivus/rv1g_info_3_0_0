import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rv1g_info/src/features/news/domain/models/eklase_news.dart';
import 'package:rv1g_info/src/features/news/presentation/widgets/crud_eklase_news_page.dart';
import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../components/image_zoom_widget.dart';
import '../../../../constants/theme_colors.dart';

class OneEklaseNewsPage extends StatefulWidget {
  final bool isAdmin;
  final EklaseNews news;

  const OneEklaseNewsPage({
    required this.isAdmin,
    required this.news,
    super.key
  });

  @override
  State<OneEklaseNewsPage> createState() => _OneEklaseNewsPageState();
}

class _OneEklaseNewsPageState extends State<OneEklaseNewsPage> {

  late EklaseNews news;
  
  @override
  void initState() {
    FirebaseAnalytics.instance.logEvent(name: "one_eklase_page_opened");
    news = widget.news;
    super.initState();
  }

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
        scrolledUnderElevation: 0,
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
          if(widget.isAdmin)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) {
                      return CRUDEklaseNewsPage(
                        edit: true, 
                        newsId: news.id, 
                        title: news.title, 
                        author: news.author, 
                        shortText: news.shortText, 
                        text: formatedText(news.text), 
                        images: news.media, 
                        pin: news.pin
                      );
                    }
                  )
                );
              },
              child: SizedBox(
                height: 50.h,
                width: 60.w,
                child: Icon(
                  Icons.edit,
                  color: blue,
                ),
              ),
            )
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
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
                        news.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.w,
                          height: 1.w,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('dd.MM.yyyy.', 'en_US')
                        .format(
                          DateTime.parse(news.createdDateTime)
                        ),
                      style: TextStyle(
                        fontSize: 13.w,
                        height: 1.w,
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
                        text: formatedText(news.text),
                        style: TextStyle(
                          fontSize: 16.w,
                          height: 1.w,
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
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Text(
                        news.author,
                        style: TextStyle(
                          fontSize: 15.w,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.w,
                        ),
                      ),
                    ),
                    for(int i=0;i<news.media.length;i++)
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.w),
                          ),
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              FirebaseAnalytics.instance.logEvent(name: "image_opened");
                              showDialog(
                                context: context,
                                builder: (context) => buildImageZoom(context, json.decode(news.media[i])['image_url']),
                                barrierDismissible: true,
                              );
                            },
                            child: InteractiveViewer(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.w),
                                child: Image.network(
                                  json.decode(news.media[i])['image_url'],
                                  fit: BoxFit.cover,
                                ),
                              )
                            ),
                          )
                        )
                      ),
                    SizedBox(height: 20.h)
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