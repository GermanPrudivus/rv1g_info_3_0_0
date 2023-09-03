import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rv1g_info/src/utils/exception.dart';

import '../../../../constants/theme_colors.dart';
import '../controllers/changes_controller.dart';

class CRUDChangesWidget extends ConsumerStatefulWidget {
  final String tag;
  final String imageUrl;

  const CRUDChangesWidget({
    required this.tag,
    required this.imageUrl,
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CRUDChangesWidgetState();
}

class _CRUDChangesWidgetState extends ConsumerState<CRUDChangesWidget> {

  String imagePath = "";

  Future pickImageFromGallery() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 521,
      maxWidth: 512,
      imageQuality: 100,
    );

    setState(() {
      imagePath = File(image!.path).path;
    });
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue>(
      changesControllerProvider,
      (_, state) {
        if(state.isLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator(color: blue))
          );
        } else if (state.asData == null){
          
        } else {
          Navigator.pop(context);
        }
        state.showSnackbarOnError(context);
      },
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(
		    borderRadius: BorderRadius.circular(15.h),
	    ),
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Container(
          width: 1.sw,
          alignment: Alignment.topLeft,
          color: Colors.white,
          margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 20.h, bottom: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Text(
                    "Pievienot jaunu attēlu:",
                    style: TextStyle(
                      fontSize: 18.w
                    ),
                  )
                ],
              ),

              SizedBox(height: 10.h),

              imagePath == ""
                ? Container(
                    color: Colors.white,
                    height: 380.h,
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
                  )
                : Image.file(
                    File(imagePath)
                  ),

              SizedBox(height: 20.h),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(125.w, 40.h),
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.h),
                        side: BorderSide(color: blue)
                      )
                    ),
                    child: Text(
                      "Atcelt",
                      style: TextStyle(
                        fontSize: 15.w,
                        color: blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref
                        .read(changesControllerProvider.notifier)
                        .updateChanges(widget.tag, imagePath, widget.imageUrl)
                        .whenComplete(() {
                          Navigator.pop(context);
                        });
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(125.w, 40.h),
                      backgroundColor: blue,
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.h)
                      )
                    ),
                    child: Text(
                      "Saglabāt",
                      style: TextStyle(
                        fontSize: 15.w,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      )
    );
  }
}