import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rv1g_info/src/utils/exception.dart';

import '../../../../constants/theme.dart';
import '../controllers/crud_event_controller.dart';

class CRUDEventPage extends ConsumerStatefulWidget {
  final bool edit;
  final isAdmin;
  final int eventId;
  final String title;
  final String shortText;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final List<String> images;

  const CRUDEventPage({
    required this.edit,
    required this.isAdmin,
    required this.eventId,
    required this.title,
    required this.shortText,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.images,
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CRUDEventPageState();
}

class _CRUDEventPageState extends ConsumerState<CRUDEventPage> {

  late String title;
  String email = "";
  late String shortText;
  late String description;
  late DateTime startDate;
  late DateTime endDate;

  bool next = true;

  late List<String> images;

  List imagesPath = [];

  @override
  void initState() {
    title = widget.title;
    shortText = widget.shortText;
    description = widget.description;
    startDate = widget.startDate;
    endDate = widget.endDate;
    images = widget.images;
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
      crudEventControllerProvider,
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
        toolbarHeight: 60.h,
        actions: [
          if(widget.edit && widget.isAdmin)
            GestureDetector(
              onTap: () {
                ref
                  .read(crudEventControllerProvider.notifier)
                  .deleteEvent(widget.eventId, widget.images)
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
                      ? "Rediģēt pasākumu:"
                      : "Pievienot pasākumu:",
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
                          hintText: 'Ieraksti pasākuma nosaukumu',
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

                if(!widget.edit)
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5.w, bottom: 5.h),
                          child: Text(
                            "Organizatora e-pasts",
                            style: TextStyle(
                              fontSize: 14.w,
                              height: 1.w,
                            ),
                          ),
                        ),
                        TextFormField(
                          initialValue: email,
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
                            hintText: 'Ieraksti organizatora e-pastu (ja nav VD)',
                            hintStyle: TextStyle(
                              fontSize: 14.w,
                              height: 1.w,
                            )
                          ),
                          onChanged: (value) {
                            setState(() {
                              email = value;
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
                          hintText: 'Ieraksti pasākuma īso aprakstu, kuru redzēs sākumā',
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

                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.only(left: 5.w),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Pasākuma ilgums:",
                        style: TextStyle(
                          fontSize: 14.w,
                          height: 1.w,
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 5.h),
                  padding: EdgeInsets.only(top: 5.h, left: 5.w, right: 5.w, bottom: 15.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.h),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black38
                    ),
                  ),
                  child:Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                next = true;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 10.h, bottom: 10.h, left: 5.w),
                              child: Text(
                                DateFormat('dd.MM.yyyy. HH:mm', 'en_US')
                                  .format(startDate),
                                style: TextStyle(
                                  fontSize: 14.w,
                                  height: 1.w,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ),
                          Text(
                            ':',
                            style: TextStyle(
                              fontSize: 14.w,
                              fontWeight: FontWeight.bold,
                              height: 1.w,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                next = false;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 5.w),
                              child: Text(
                                DateFormat('dd.MM.yyyy. HH:mm', 'en_US')
                                  .format(endDate),
                                style: TextStyle(
                                  fontSize: 14.w,
                                  height: 1.w,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  next
                                    ? 'No:'
                                    : 'Līdz:',
                                  style: TextStyle(
                                    fontSize: 14.w,
                                    height: 1.w,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            SizedBox(
                              height: 100.h,
                              child: CupertinoDatePicker(
                                use24hFormat: true,
                                initialDateTime: next
                                  ? startDate
                                  : endDate,
                                mode: CupertinoDatePickerMode.dateAndTime,
                                onDateTimeChanged: (value) {
                                  setState(() {
                                    if(next){
                                      startDate = value;
                                    } else {
                                      endDate = value;
                                    };
                                 });
                                },
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                        initialValue: description,
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
                          hintText: 'Ieraksti pasākuma aprakstu',
                          hintStyle: TextStyle(
                            fontSize: 14.w,
                            height: 1.w,
                          )
                        ),
                        minLines: 25,
                        maxLines: 1000,
                        onChanged: (value) {
                          setState(() {
                            description = value;
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
                  padding: EdgeInsets.only(top: 10.h, bottom: 15.h),
                  child: Text(
                    '<b></b> - lai uztaisītu tekstu treknrakstā\n<u></u> - lai pasvītrotu tekstu\n<i></i> - lai uztaisītu tekstu kursīvā\n<link href=your_link></link> - lai pievienotu saiti',
                    style: TextStyle(
                      fontSize: 15.w,
                      height: 1.w,
                    ),
                  ),
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
                                  .read(crudEventControllerProvider.notifier)
                                  .deleteImage(widget.eventId, images, images[i])
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
                          .read(crudEventControllerProvider.notifier)
                          .editEvent(
                            widget.eventId,
                            title, 
                            shortText, 
                            description,
                            startDate.toIso8601String(),
                            endDate.toIso8601String(),
                            imagesPath,
                            images,
                          ).whenComplete(() {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                      } else {
                        ref
                          .read(crudEventControllerProvider.notifier)
                          .addEvent(
                            title,
                            email,
                            shortText, 
                            description,
                            startDate.toIso8601String(),
                            endDate.toIso8601String(),
                            imagesPath
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
                        ? "Rediģēt pasākumu"
                        : "Pievienot pasākumu",
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