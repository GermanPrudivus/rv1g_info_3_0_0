import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/theme_colors.dart';

class OneEklaseNewsPage extends StatefulWidget {
  final String title;
  final String createdDateTime;
  final String text;
  final String author;
  final List<String> images;

  const OneEklaseNewsPage({
    required this.title,
    required this.createdDateTime,
    required this.text,
    required this.author,
    required this.images,
    super.key
  });

  @override
  State<OneEklaseNewsPage> createState() => _OneEklaseNewsPageState();
}

class _OneEklaseNewsPageState extends State<OneEklaseNewsPage> {

  Widget buildImageZoom(BuildContext context, String url) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InteractiveViewer(
                child: Image.network(
                  url,
                  fit: BoxFit.fill,
                )
            )
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          size: 24.h,
          color: blue
        ),
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
                        widget.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.h
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
                      widget.createdDateTime,
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
                        text: widget.text,
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
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Text(
                        widget.author,
                        style: TextStyle(
                          fontSize: 14.5.h,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    for(int i=0;i<widget.images.length;i++)
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
                                builder: (context) => buildImageZoom(context, json.decode(widget.images[i])['image_url']),
                                barrierDismissible: true,
                              );
                            },
                            child: InteractiveViewer(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.w),
                                child: Image.network(
                                  json.decode(widget.images[i])['image_url'],
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