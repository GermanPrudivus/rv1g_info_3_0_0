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

import '../../../../constants/theme_colors.dart';
import '../controllers/crud_volunteering_controller.dart';

class CRUDVolunteeringPage extends ConsumerStatefulWidget {
  final bool edit;
  final int jobId;
  final String title;
  final String description;
  final List<String> images;
  final DateTime startDate;
  final DateTime endDate;

  const CRUDVolunteeringPage({
    required this.edit,
    required this.jobId,
    required this.title,
    required this.description,
    required this.images,
    required this.startDate,
    required this.endDate,
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CRUDVolunteeringPageState();
}

class _CRUDVolunteeringPageState extends ConsumerState<CRUDVolunteeringPage> {

  late String title;
  late String description;
  late DateTime startDate;
  late DateTime endDate;

  bool next = true;

  late List<String> images;
  List imagesPath = [];

  @override
  void initState() {
    title = widget.title;
    description = widget.description;
    images = widget.images;
    startDate = widget.startDate;
    endDate = widget.endDate;
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
      crudVolunteeringControllerProvider,
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
                  .read(crudVolunteeringControllerProvider.notifier)
                  .deleteEvent(widget.jobId, widget.images)
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
                      ? "Rediģēt darbu:"
                      : "Pievienot darbu:",
                      style: TextStyle(
                        fontSize: 24.w,
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
                          ),
                        ),
                      ),
                      TextFormField(
                        initialValue: title,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          fontSize: 15.w
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
                          hintText: 'Ieraksti amata nosaukumu',
                          hintStyle: TextStyle(
                            fontSize: 14.w
                          )
                        ),
                        onChanged: (value) {
                          setState(() {
                            title = value;
                          });
                        },
                        cursorColor: blue,
                      ),
                    ],
                  )
                ),

                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.only(left: 5.w),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Darba ilgums:",
                        style: TextStyle(
                          fontSize: 14.w
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
                          ),
                        ),
                      ),
                      TextFormField(
                        initialValue: description,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          fontSize: 15.w
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
                          hintText: 'Ieraksti darba aprakstu',
                          hintStyle: TextStyle(
                            fontSize: 14.w
                          )
                        ),
                        minLines: 25,
                        maxLines: 1000,
                        onChanged: (value) {
                          setState(() {
                            description = value;
                          });
                        },
                        cursorColor: blue,
                      ),
                    ],
                  )
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10.h, bottom: 15.h),
                  child: Text(
                    '<b></b> - lai uztaisītu bold tekstu\n<u></u> - lai pasvītrotu tekstu\n<i></i> - lai uztaisītu italic tekstu\n<link href="your_link"></link> - lai pievienotu saiti',
                    style: TextStyle(
                      fontSize: 15.w
                    ),
                  ),
                ),

                Text(
                  "Pievienot attēlu:",
                  style: TextStyle(
                    fontSize: 15.w,
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
                                  .read(crudVolunteeringControllerProvider.notifier)
                                  .deleteImage(widget.jobId, images, images[i])
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
                            fontWeight: FontWeight.bold
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
                          .read(crudVolunteeringControllerProvider.notifier)
                          .editJob(
                            widget.jobId,
                            title,
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
                          .read(crudVolunteeringControllerProvider.notifier)
                          .addJob(
                            title, 
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
                        ? "Rediģēt darbu"
                        : "Pievienot darbu",
                      style: TextStyle(
                        fontSize: 17.w,
                        fontWeight: FontWeight.bold,
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