import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rv1g_info/src/features/settings/presentation/controllers/edit_user_controller.dart';
import 'package:rv1g_info/src/utils/auth_exception.dart';
import 'package:the_validator/the_validator.dart';

import '../../../../components/drawer_app_bar_widget.dart';
import '../../../../constants/const.dart';
import '../../../../constants/theme_colors.dart';
import '../../domain/models/app_user.dart';

class EditUserPage extends ConsumerStatefulWidget {
  final AppUser user;

  const EditUserPage({
    required this.user,
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditUserPageState();
}

class _EditUserPageState extends ConsumerState<EditUserPage> {

  late AppUser user;
  late String profilePicUrl;
  late String fullName;

  String dropdownValue = "Choose your class";

  bool notVisibility = true;
  bool validPassword = true;

  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    user = widget.user;
    profilePicUrl = widget.user.profilePicUrl;
    fullName = widget.user.fullName;
    dropdownValue = dropdownValues.keys.firstWhere(
      (k) => dropdownValues[k] == widget.user.formId, 
      orElse: () => ""
    );
    super.initState();
  }

  Future<String> pickImageFromGallery() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 521,
      maxWidth: 512,
      imageQuality: 100,
    );

    if(image == null){
      return "";
    } else {
      File imageFile = File(image.path);
      return imageFile.path;
    }
  }
  
  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue>(
      editUserControllerProvider,
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: DrawerAppBarWidget(
          title: "Profils", 
          add: false, 
          navigateTo: Placeholder(), 
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            PermissionStatus storageStatus = await Permission.storage.request();
    
                            if(storageStatus == PermissionStatus.granted){
                              pickImageFromGallery()
                                .then((value) {
                                  ref
                                    .read(editUserControllerProvider.notifier)
                                    .updateProfilePicUrl(
                                      user.id,
                                      user.email,
                                      value,
                                      profilePicUrl
                                    ).then((value) {
                                      setState(() {
                                        profilePicUrl = value!;
                                      });
                                    });
                                });
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
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              profilePicUrl == ""
                                ? CircleAvatar(
                                  radius: 50.h,
                                  backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 80.h,
                                  )
                                )
                                : CircleAvatar(
                                    radius: 50.h,
                                    backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                                    backgroundImage: NetworkImage(profilePicUrl)
                                  ),
                              ClipOval(
                                child: Container(
                                  height: 25.h,
                                  width: 25.h,
                                  color: blue,
                                  child: Icon(
                                    Icons.edit,
                                    size: 15.h,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          )
                        )
                      ]
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 30.h, left: 5.w, right: 5.w),
                    child: TextFormField(
                      initialValue: user.fullName,
                      style: TextStyle(
                        fontSize: 14.h,
                        color: blue,
                      ),
                      decoration: InputDecoration(
                        hintText: "Full Name",
                        hintStyle: TextStyle(
                          fontSize: 14.h,
                          color: lightGrey,
                        ),
                        icon: const Icon(Icons.person_outline),
                        iconColor: lightGrey,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: transparentLightGrey, width: 2.h
                          )
                       ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: blue, width: 2.h)
                        ),
                      ),
                      cursorColor: blue,
                      validator: FieldValidator.required(
                        message: "Type your full name"
                      ),
                      onChanged: (value) {
                        setState(() {
                          fullName = value;
                        });
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 40.w, right: 5.w),
                    child: DropdownButton<String>(
                      menuMaxHeight: 350.h,
                      isExpanded: true,
                      itemHeight: 50.h,
                      borderRadius: BorderRadius.circular(20.w),
                      iconEnabledColor: blue,
                      dropdownColor: const Color.fromRGBO(241, 244, 251, 1),
                      value: dropdownValue,
                      elevation: 60.h.toInt(),
                      style: TextStyle(
                        fontSize: 14.h,
                        color: blue,
                      ),
                      underline: Container(
                        height: 2.h,
                        color: transparentLightGrey,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue.toString();
                       });
                      },
                      items: dropdownValues.keys
                          .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: value == "Choose your class"
                                    ? lightGrey
                                    : blue
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 5.w, top: 2.5.h, right: 5.w),
                    child: TextFormField(
                      controller: passwordController,
                      style: TextStyle(
                        fontSize: 14.h,
                        color: blue,
                     ),
                      decoration: InputDecoration(
                        hintText: "New Password",
                        hintStyle: TextStyle(
                          fontSize: 14.h,
                          color: lightGrey,
                        ),
                        icon: const Icon(Icons.lock_outline),
                        iconColor: lightGrey,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: transparentLightGrey, width: 2.h
                          )
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: blue, width: 2.h)
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              if(notVisibility == false) {
                                notVisibility = true;
                              } else {
                                notVisibility = false;
                              }
                            });
                          },
                          child: Icon(notVisibility
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                        ),
                        suffixIconColor: lightGrey,
                      ),
                      obscureText: notVisibility,
                      cursorColor: blue,
                      validator: passwordController.text != ""
                        ? FieldValidator.password(
                            minLength: 8,
                            shouldContainNumber: true,
                          )
                        : FieldValidator.equalTo("")
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 5.w, top: 10.h, right: 5.w),
                    child: TextFormField(
                      controller: repeatPasswordController,
                      style: TextStyle(
                        fontSize: 14.h,
                        color: blue,
                      ),
                      decoration: InputDecoration(
                        hintText: "Repeat New Password",
                        hintStyle: TextStyle(
                          fontSize: 14.h,
                          color: lightGrey,
                        ),
                        icon: const Icon(Icons.lock_outline),
                        iconColor: lightGrey,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: transparentLightGrey, width: 2.h
                          )
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: blue, width: 2.h)
                        ),
                      ),
                      obscureText: true,
                      cursorColor: blue,
                      validator: FieldValidator.equalTo(
                        passwordController,
                        message: "Password Mismatch"
                      ),
                    ),
                  ),

                  //botton
                  Padding(
                    padding: EdgeInsets.only(top: 160.h),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() && dropdownValue != "Choose your class" && fullName.split(' ').length > 1) {
                          ref
                            .read(editUserControllerProvider.notifier)
                            .updateUser(
                              user.id, 
                              fullName, 
                              dropdownValues[dropdownValue] ?? 1, 
                              passwordController.text
                            ).whenComplete(() {
                              Navigator.pop(context);
                            });
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
                        "Rediģēt profilu",
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
      ),
    );
  }
}