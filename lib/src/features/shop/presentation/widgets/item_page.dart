import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:rv1g_info/src/features/shop/presentation/widgets/crud_shop_page.dart';

import '../../../../components/image_zoom_widget.dart';
import '../../../../constants/theme_colors.dart';
import '../../domain/models/item.dart';

class ItemPage extends StatefulWidget {
  final bool isAdmin;
  final Item item;

  const ItemPage({
    required this.isAdmin,
    required this.item,
    super.key
  });

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {

  late Item item;
  
  @override
  void initState() {
    item = widget.item;
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
                      return CRUDShopPage(
                        edit: true,
                        itemId: item.id,
                        title: item.title, 
                        shortText: item.shortText, 
                        price: item.price, 
                        description: formatedText(item.description), 
                        images: item.media
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
                        item.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.w,
                          height: 1.w,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5.h,),
                Divider(
                  color: blue,
                  height: 10.h,
                  thickness: 3.h,
                ),
                SizedBox(height: 5.h,),
                Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      StyledText(
                        text: formatedText(item.description),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text(
                              item.price,
                              style: TextStyle(
                                fontSize: 17.w,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.w,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for(int i=0;i<item.media.length;i++)
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
                                builder: (context) => buildImageZoom(context, json.decode(item.media[i])['image_url']),
                                barrierDismissible: true,
                              );
                            },
                            child: InteractiveViewer(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.w),
                                child: Image.network(
                                  json.decode(item.media[i])['image_url'],
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