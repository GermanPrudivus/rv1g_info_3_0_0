import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rv1g_info/src/features/news/presentation/controllers/crud_school_news_controller.dart';
import 'package:rv1g_info/src/utils/exception.dart';

import '../../../../constants/theme_colors.dart';

class AddSchoolNewsPage extends ConsumerStatefulWidget {
  final bool edit;
  final int newsId;
  final String text;
  final bool pin;
  final int pollId;
  final String title;
  final int answer1Id;
  final int answer2Id;
  final int answer3Id;
  final int answer4Id;
  final String answer1;
  final String answer2;
  final String answer3;
  final String answer4;
  final DateTime pollEnd;
  final List<String> images;

  const AddSchoolNewsPage({
    super.key,
    required this.edit,
    required this.newsId,
    required this.text,
    required this.pin,
    required this.pollId,
    required this.title,
    required this.answer1Id,
    required this.answer2Id,
    required this.answer3Id,
    required this.answer4Id,
    required this.answer1,
    required this.answer2,
    required this.answer3,
    required this.answer4,
    required this.pollEnd,
    required this.images
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddSchoolNewsPageState();
}

class _AddSchoolNewsPageState extends ConsumerState<AddSchoolNewsPage> {

  late int newsId;
  late String text;
  late bool pin;
  late List<String> images;
  bool showNewPoll = false;

  late int pollId;
  late String title;
  late String answer1;
  late String answer2;
  late String answer3;
  late String answer4;
  late DateTime pollEnd;

  List imagesPath = [];

  @override
  void initState() {
    newsId = widget.newsId;
    text = widget.text;
    pin = widget.pin;
    pollId = widget.pollId;
    title = widget.title;
    answer1 = widget.answer1;
    answer2 = widget.answer2;
    answer3 = widget.answer3;
    answer4 = widget.answer4;
    pollEnd = widget.pollEnd;
    images = widget.images;
    super.initState();
  }

  Future pickImageFromGallery() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 521,
      maxWidth: 512,
      imageQuality: 100,
    );

    setState(() {
      imagesPath.add(File(image!.path).path);
    });
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue>(
      addSchoolNewsControllerProvider,
      (_, state) {
        if(state.isLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(child: CircularProgressIndicator(),)
          );
        } else if (state.asData == null){
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
        }
        state.showSnackbarOnError(context);
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          size: 28.h,
          color: blue
        ),
        toolbarHeight: 60.h,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
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
                        fontSize: 22.h,
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
                          "Teksts",
                          style: TextStyle(
                            fontSize: 13.h,
                          ),
                        ),
                      ),
                      TextFormField(
                        initialValue: text,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          fontSize: 14.h
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
                            fontSize: 14.h
                          )
                        ),
                        minLines: 25,
                        maxLines: 1000,
                        onChanged: (value) {
                          setState(() {
                            text = value;
                          });
                        },
                        cursorColor: blue,
                      ),
                    ],
                  )
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Text(
                    '<b></b> - lai uztaisītu bold tekstu\n<u></u> - lai pasvītrotu tekstu\n<i></i> - lai uztaisītu italic tekstu\n<link href="your_link"></link> - lai pievienotu saiti',
                    style: TextStyle(
                      fontSize: 14.h
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
                            fontSize: 14.h,
                          ),
                        )
                      ],
                    ),
                  )
                ),

                Text(
                  widget.edit
                    ? "Rediģēt aptauju:"
                    : "Peivienot aptauju:",
                  style: TextStyle(
                    fontSize: 14.h
                  ),
                ),

                if(widget.title != "" || showNewPoll)
                  Padding(
                    padding: EdgeInsets.only(top: 10.h, bottom: 15.h),
                    child: Container(
                      height: 525.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.h),
                        color: Colors.white,
                        border: Border.all(),
                      ),
                      child: SingleChildScrollView(
                        primary: false,
                        child: Column(
                          children: [
                          Padding(
                            padding: EdgeInsets.only(top: 12.5.h, left: 10.w, right: 10.w),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 5.w),
                                      width: 255.w,
                                      child: TextFormField(
                                        initialValue: title,
                                        textInputAction: TextInputAction.next,
                                        style: TextStyle(
                                          fontSize: 13.h
                                        ),
                                        decoration: InputDecoration(
                                          isDense: true,
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
                                          hintText: 'Ieraksti jautājumu',
                                          hintStyle: TextStyle(
                                            fontSize: 13.h
                                          )
                                        ),
                                        cursorColor: blue,
                                        onChanged: (value) {
                                          setState(() {
                                            title = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter question';
                                          } 
                                          return null;
                                        },
                                      ),
                                    ),
                                    GestureDetector(
                                      child: ClipOval(
                                        child: Container(
                                          height: 35.h,
                                          width: 35.h,
                                          color: Colors.red,
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.delete,
                                            size: 20.h,
                                            color: Colors.white,
                                          ),
                                        )
                                      ),
                                      onTap: () {
                                        setState(() {
                                          showNewPoll = false;
                                          title = "";
                                          answer1 = "";
                                          answer2 = "";
                                          answer3 = "";
                                          answer4 = "";
                                        });
                                      },
                                    )
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                Column(
                                  children: [
                                    TextFormField(
                                      initialValue: answer1,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                        fontSize: 13.h
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            width: 2.h,
                                            color: Colors.black
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            width: 2.h,
                                            color: blue
                                          ),
                                        ),
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        hintText: '1. Atbilde',
                                        hintStyle: TextStyle(
                                          fontSize: 13.h
                                        )
                                      ),
                                      cursorColor: blue,
                                      onChanged: (value) {
                                        setState(() {
                                          answer1 = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter answer';
                                        } 
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 10.h),
                                    TextFormField(
                                      initialValue: answer2,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                        fontSize: 13.h
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            width: 2.h,
                                            color: Colors.black
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            width: 2.h,
                                            color: blue
                                          ),
                                        ),
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        hintText: '2. Atbilde',
                                        hintStyle: TextStyle(
                                          fontSize: 13.h
                                        )
                                      ),
                                      cursorColor: blue,
                                      onChanged: (value) {
                                        setState(() {
                                          answer2 = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter answer';
                                        } 
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 10.h),
                                  ],
                                ),
                                TextFormField(
                                  initialValue: answer3,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(
                                    fontSize: 13.h
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        width: 2.h,
                                        color: Colors.black
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        width: 2.h,
                                        color: blue
                                      ),
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    hintText: '3. Atbilde (opcionāli)',
                                    hintStyle: TextStyle(
                                      fontSize: 13.h
                                    )
                                  ),
                                  cursorColor: blue,
                                  onChanged: (value) {
                                    setState(() {
                                      answer3 = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 10.h),
                                TextFormField(
                                  initialValue: answer4,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(
                                    fontSize: 13.h
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        width: 2.h,
                                        color: Colors.black
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        width: 2.h,
                                        color: blue
                                      ),
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    hintText: '4. Atbilde (opcionāli)',
                                    hintStyle: TextStyle(
                                      fontSize: 13.h
                                    )
                                  ),
                                  cursorColor: blue,
                                  onChanged: (value) {
                                    setState(() {
                                      answer4 = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                            height: 17.5.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.w, right: 10.w),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Aptaujas ilgums:",
                                      style: TextStyle(
                                        fontSize: 13.h
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                SizedBox(
                                  height: 200.h,
                                  child: CupertinoDatePicker(
                                    use24hFormat: true,
                                    initialDateTime: DateTime(
                                      pollEnd.year,
                                      pollEnd.month,
                                      pollEnd.day,
                                      pollEnd.hour,
                                      pollEnd.minute
                                    ),
                                    mode: CupertinoDatePickerMode.dateAndTime,
                                    onDateTimeChanged: (value) {
                                      setState(() {
                                        pollEnd = DateTime(
                                          value.year, 
                                          value.month, 
                                          value.day,
                                          value.hour,
                                          value.minute
                                        );
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ),
                  ),
                  ),

                if(!showNewPoll && title == "")
                  Container(
                    color: Colors.white,
                    height: 80.h,
                    alignment: Alignment.center,
                    child: GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 30.h,
                            color: Colors.black38,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "Pievienot aptauju",
                            style: TextStyle(
                              fontSize: 14.h,
                              color: Colors.black45
                            ),
                          )
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          showNewPoll = true;
                        });
                      },
                    ),
                  ),

                Text(
                  "Pievienot attēlu:",
                  style: TextStyle(
                    fontSize: 14.h
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
                                  .read(addSchoolNewsControllerProvider.notifier)
                                  .deleteImage(newsId, images, images[i])
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
                          size: 30.h,
                          color: Colors.black38,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "Pievienot attēlu",
                          style: TextStyle(
                            fontSize: 14.h,
                            color: Colors.black45
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
                  padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                  child: ElevatedButton(
                    onPressed: () {
                      if(widget.edit) {
                        ref
                          .read(addSchoolNewsControllerProvider.notifier)
                          .editSchoolNews(
                            newsId,
                            text,
                            images,
                            imagesPath,
                            pin,
                            showNewPoll,
                            pollId,
                            title,
                            widget.answer1Id,
                            widget.answer2Id,
                            widget.answer3Id,
                            widget.answer4Id,
                            answer1, 
                            answer2, 
                            answer3, 
                            answer4, 
                            pollEnd,
                          ).whenComplete(() {
                            Navigator.pop(context);
                          });
                      } else {
                        ref
                          .read(addSchoolNewsControllerProvider.notifier)
                          .addSchoolNews(
                            text,
                            imagesPath, 
                            pin,
                            showNewPoll,
                            title, 
                            answer1, 
                            answer2, 
                            answer3, 
                            answer4, 
                            pollEnd
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
                        fontSize: 16.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}