import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rv1g_info/src/utils/exception.dart';

import '../../../../constants/theme.dart';
import '../controllers/crud_eklase_news_page.dart';

class CRUDEklaseNewsPage extends ConsumerStatefulWidget {
  final bool edit;
  final int newsId;
  final String title;
  final String author;
  final String shortText;
  final String text;
  final List<String> images;
  final bool pin;

  const CRUDEklaseNewsPage({
    required this.edit,
    required this.newsId,
    required this.title,
    required this.author,
    required this.shortText,
    required this.text,
    required this.images,
    required this.pin,
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CRUDEklaseNewsPageState();
}

class _CRUDEklaseNewsPageState extends ConsumerState<CRUDEklaseNewsPage> {

  late String title;
  late String author;
  late String shortText;
  late String text;
  late List<String> images;
  late bool pin;

  List imagesPath = [];

  @override
  void initState() {
    title = widget.title;
    author = widget.author;
    shortText = widget.shortText;
    text = widget.text;
    images = widget.images;
    pin = widget.pin;
    super.initState();
  }

  Future pickImageFromGallery() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    setState(() {
      imagesPath.add(File(image!.path).path);
    });
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue>(
      crudEklaseNewsControllerProvider,
      (_, state) {
        if(state.isLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator(color: blue))
          );
        } else if (state.asData == null){
          state.showSnackbarOnError(context);
        } else {
          Navigator.pop(context);
        }
      },
    );
    
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
        toolbarHeight: 60.h,
        actions: [
          if(widget.edit)
            GestureDetector(
              onTap: () {
                ref
                  .read(crudEklaseNewsControllerProvider.notifier)
                  .deleteEklaseNews(widget.newsId)
                  .whenComplete(() {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
              },
              child: SizedBox(
                height: 50.h,
                width: 60.w,
                child: Icon(
                  Icons.delete,
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
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.edit
                      ? "Rediģēt ziņu:"
                      : "Pievienot ziņu:",
                      style: TextStyle(
                        fontSize: 24.w,
                        height: 1.w,
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, bottom: 5.h),
                        child: Text(
                          "Nosaukums",
                          style: TextStyle(
                            fontSize: 14.w,
                            height: 1.w,
                          ),
                        ),
                      ),
                      TextFormField(
                        initialValue: title,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 15.w,
                          height: 1.w,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 2.h,
                              color: Colors.black
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 2.h,
                              color: blue
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Ieraksti ziņas nosaukumu',
                          hintStyle: TextStyle(
                            fontSize: 14.w,
                            height: 1.w,
                          )
                        ),
                        onChanged: (value) {
                          setState(() {
                            title = value;
                          });
                        },
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        cursorColor: blue,
                      ),
                    ],
                  )
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, bottom: 5.h),
                        child: Text(
                          "Īss apraksts",
                          style: TextStyle(
                            fontSize: 14.w,
                            height: 1.w,
                          ),
                        ),
                      ),
                      TextFormField(
                        initialValue: shortText,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 15.w,
                          height: 1.w,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 2.h,
                              color: Colors.black
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 2.h,
                              color: blue
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Ieraksti ziņas īso aprakstu, kuru redzēs sākumā',
                          hintStyle: TextStyle(
                            fontSize: 14.w,
                            height: 1.w,
                          )
                        ),
                        maxLength: 200,
                        minLines: 4,
                        maxLines: 6,
                        onChanged: (value) {
                          setState(() {
                            shortText = value;
                          });
                        },
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        cursorColor: blue,
                      ),
                    ],
                  )
                ),

                Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, bottom: 5.h),
                        child: Text(
                          "Autors",
                          style: TextStyle(
                            fontSize: 14.w,
                            height: 1.w,
                          ),
                        ),
                      ),
                      TextFormField(
                        initialValue: author,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 15.w,
                          height: 1.w,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 2.h,
                              color: Colors.black
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 2.h,
                              color: blue,
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Ieraksti autora vārdu',
                          hintStyle: TextStyle(
                            fontSize: 14.w,
                            height: 1.w,
                          )
                        ),
                        onChanged: (value) {
                          setState(() {
                            author = value;
                          });
                        },
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        cursorColor: blue,
                      ),
                    ],
                  )
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, bottom: 5.h),
                        child: Text(
                          "Teksts",
                          style: TextStyle(
                            fontSize: 14.w,
                            height: 1.w,
                          ),
                        ),
                      ),
                      TextFormField(
                        initialValue: text,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                          fontSize: 15.w,
                          height: 1.w,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 2.h,
                              color: Colors.black
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 2.h,
                              color: blue
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Ieraksti ziņas tekstu',
                          hintStyle: TextStyle(
                            fontSize: 14.w,
                            height: 1.w,
                          )
                        ),
                        minLines: 25,
                        maxLines: 1000,
                        onChanged: (value) {
                          setState(() {
                            text = value;
                          });
                        },
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        cursorColor: blue,
                      ),
                    ],
                  )
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Text(
                    '<b></b> - lai uztaisītu tekstu treknrakstā\n<u></u> - lai pasvītrotu tekstu\n<i></i> - lai uztaisītu tekstu kursīvā\n<link href=your_link></link> - lai pievienotu saiti',
                    style: TextStyle(
                      fontSize: 15.w,
                      height: 1.w,
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        pin = !pin;
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          value: pin,
                          checkColor: Colors.white,
                          activeColor: blue,
                          side: BorderSide(
                            width: 1.h,
                            color: blue
                          ),
                          onChanged: (_) {
                            setState(() {
                              pin = !pin;
                            });
                          }
                        ),
                        Text(
                          "Piestiprināt ziņu augšā",
                          style: TextStyle(
                            fontSize: 15.w,
                            height: 1.w,
                          ),
                        )
                      ],
                    ),
                  )
                ),

                Text(
                  "Pievienot attēlu:",
                  style: TextStyle(
                    fontSize: 15.w,
                    height: 1.w,
                  ),
                ),
                
                if(images.isNotEmpty)
                  for(int i=0;i<images.length;i++)
                    Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                ref
                                  .read(crudEklaseNewsControllerProvider.notifier)
                                  .deleteImage(widget.newsId, images, images[i])
                                  .whenComplete(() {
                                    setState(() {
                                      images = images;
                                    });
                                  });
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete'
                            )
                          ],
                        ),
                        child: Image.network(json.decode(images[i])['image_url']),
                      ),
                    ),

                if(imagesPath.isNotEmpty)
                  for(int i=0;i<imagesPath.length;i++)
                    Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                setState(() {
                                  imagesPath.remove(imagesPath[i]);
                                });
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete'
                            )
                          ],
                        ),
                        child: Image.file(File(imagesPath[i])),
                      ),
                    ),

                Container(
                  color: Colors.white,
                  height: images.isEmpty && imagesPath.isEmpty
                    ? 100.h
                    : 60.h,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 30.w,
                          color: Colors.black38,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "Pievienot attēlu",
                          style: TextStyle(
                            fontSize: 15.w,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                            height: 1.w,
                          ),
                        )
                      ],
                    ),
                    onTap: () async {
                      PermissionStatus storageStatus = await Permission.storage.request();

                      if(storageStatus == PermissionStatus.granted){
                        pickImageFromGallery();
                      }
 
                      if(storageStatus == PermissionStatus.denied){
                        if(mounted){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'You need to provide a Gallery access to upload photo!'
                              )
                            )
                          );
                        }
                      }
  
                      if(storageStatus == PermissionStatus.permanentlyDenied){
                        openAppSettings();
                      }
                    },
                  ),
                ),

                //Button
                Padding(
                  padding: EdgeInsets.only(top: 10.h, bottom: 30.h),
                  child: ElevatedButton(
                    onPressed: () {
                      if(widget.edit) {
                        ref
                          .read(crudEklaseNewsControllerProvider.notifier)
                          .editEklaseNews(
                            widget.newsId,
                            title, 
                            author, 
                            shortText, 
                            text, 
                            imagesPath,
                            images,
                            pin
                          ).whenComplete(() {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                      } else {
                        ref
                          .read(crudEklaseNewsControllerProvider.notifier)
                          .addEklaseNews(
                            title, 
                            author, 
                            shortText, 
                            text, 
                            imagesPath, 
                            pin
                          ).whenComplete(() {
                            Navigator.pop(context);
                          });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(1.sw, 50.h),
                      backgroundColor: blue,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.h)
                      )
                    ),
                    child: Text(
                      widget.edit 
                        ? "Rediģēt ziņu"
                        : "Pievienot ziņu",
                      style: TextStyle(
                        fontSize: 17.w,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}