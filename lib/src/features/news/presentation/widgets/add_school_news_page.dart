import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rv1g_info/src/features/news/presentation/controllers/add_school_news_page.dart';
import 'package:rv1g_info/src/utils/exception.dart';

import '../../../../constants/theme_colors.dart';

class AddSchoolNewsPage extends ConsumerStatefulWidget {
  final bool edit;
  final int newsId;
  final String text;
  final bool pin;
  final int poll;
  final List<String> images;

  const AddSchoolNewsPage({
    super.key,
    required this.edit,
    required this.newsId,
    required this.text,
    required this.pin,
    required this.poll,
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
  late bool showNewPoll;

  String title = "";
  String answer1 = "";
  String answer2 = "";
  String answer3 = "";
  String answer4 = "";
  DateTime pollEnd = DateTime.now();

  List imagesPath = [];

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  @override
  void initState() {
    newsId = widget.newsId;
    text = widget.text;
    pin = widget.pin;
    images = widget.images;
    showNewPoll = false;
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
                        padding: EdgeInsets.only(left: 5.w),
                        child: Text(
                          "Teksts",
                          style: TextStyle(
                            fontSize: 14.h,
                          ),
                        ),
                      ),
                      TextFormField(
                        initialValue: text,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          fontSize: 12.h
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
                            fontSize: 12.h
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
                  "Peivienot aptauju:",
                  style: TextStyle(
                    fontSize: 14.h
                  ),
                ),

                if(widget.poll != 0 || showNewPoll)
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
                                      child: Form(
                                        key: _formKey1,
                                        child: TextFormField(
                                          initialValue: title,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                            fontSize: 12.h
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
                                              fontSize: 12.h
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
                                      )
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
                                Form(
                                  key: _formKey2,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        initialValue: answer1,
                                        textInputAction: TextInputAction.next,
                                        style: TextStyle(
                                          fontSize: 12.h
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
                                            fontSize: 12.h
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
                                          fontSize: 12.h
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
                                            fontSize: 12.h
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
                                ),
                                TextFormField(
                                  initialValue: answer3,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(
                                    fontSize: 12.h
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
                                      fontSize: 12.h
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
                                    fontSize: 12.h
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
                                      fontSize: 12.h
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
                                        fontSize: 12.h
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

                if(!showNewPoll)
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
                  "Peivienot attēlu:",
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
                              onPressed: (context) {},
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete'
                            )
                          ],
                        ),
                        child: Image.network(images[i]),
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
                      if(_formKey1.currentState!.validate() && _formKey2.currentState!.validate()){
                        if(widget.edit) {

                        } else {
                          ref
                            .read(addSchoolNewsControllerProvider.notifier)
                            .addSchoolNews(
                              text,
                              imagesPath, 
                              pin, 
                              showNewPoll
                            ).then((value) {
                              setState(() {
                                newsId = value!;
                              });
                              if(showNewPoll){
                                ref
                                  .read(addSchoolNewsControllerProvider.notifier)
                                  .addPoll(
                                    title, 
                                    answer1, 
                                    answer2, 
                                    answer3, 
                                    answer4, 
                                    pollEnd, 
                                    newsId
                                  );
                                Navigator.pop(context);
                              }
                            });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'Please fill all forms with appropriative values!'
                            )
                          )
                        );
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