import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rv1g_info/src/utils/exception.dart';

import '../../../../constants/theme.dart';
import '../controllers/menu_controller.dart';

class CRUDMenuWidget extends ConsumerStatefulWidget {
  final List<String> tag;
  final List<String> imageUrl;

  const CRUDMenuWidget({
    required this.tag,
    required this.imageUrl,
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CRUDMenuWidgetState();
}

class _CRUDMenuWidgetState extends ConsumerState<CRUDMenuWidget> {
  String dropdownValue = '7.-9.klase';

  String imagePath = "";
  String imageUrl = "";
  String tag = "";

  @override
  void initState() {
    imageUrl = widget.imageUrl[0];
    tag = widget.tag[0];
    super.initState();
  }

  Future pickImageFromGallery() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    setState(() {
      imagePath = File(image!.path).path;
    });
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue>(
      menuControllerProvider,
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

    return AlertDialog(
      shape: RoundedRectangleBorder(
		    borderRadius: BorderRadius.circular(15.h),
	    ),
      contentPadding: EdgeInsets.zero,
      surfaceTintColor: Colors.white,
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

              if(widget.tag.length == 1)
                SizedBox(height: 10.h),

              if(widget.tag.length == 2)
                Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropdownButton<String>(
                        focusColor: Colors.black54,
                        borderRadius: BorderRadius.circular(20.w),
                        dropdownColor: navigationBarColor,
                        value: dropdownValue,
                        elevation: 20.h.toInt(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.h
                        ),
                        underline: Container(
                          height: 2.h,
                          color: blue,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                            if(dropdownValue == '7.-9.klase'){
                              imageUrl = widget.imageUrl[0];
                              tag = widget.tag[0];
                            } else {
                              imageUrl = widget.imageUrl[1];
                              tag = widget.tag[1];
                            }
                          });
                        },
                        items: <String>['7.-9.klase', '10.-12.klase']
                            .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                      )
                    ],
                  )
                ),

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
                        .read(menuControllerProvider.notifier)
                        .updateMenu(tag, imagePath, imageUrl)
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
                        color: Colors.white
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