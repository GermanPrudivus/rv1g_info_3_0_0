import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rv1g_info/src/constants/auth_const.dart';
import 'package:rv1g_info/src/exception/auth_exception.dart';
import 'package:the_validator/the_validator.dart';

import '../controllers/sign_up_controller.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {

  String dropdownValue = "Choose your class";

  bool notVisibility = true;
  bool validPassword = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late String imagePath = "";

  @override
  void dispose() {
    emailController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();

    super.dispose();
  }

  Future pickImageFromGallery() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 521,
      maxWidth: 512,
      imageQuality: 100,
    );

    File imageFile;

    setState(() {
      imageFile = File(image!.path);
      imagePath = imageFile.path;
    });
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue>(
      signUpScreenControllerProvider,
      (_, state) => state.showSnackbarOnError(context),
    );

    final AsyncValue<void> signUpState =
        ref.watch(signUpScreenControllerProvider);

    Map<String, int> dropdownValues = const {
      "Choose your class": -1,
      "7.a klase" : 1,
      "7.b klase" : 2,
      "7.c klase" : 3,
      "7.d klase" : 4,
      "8.a klase" : 5,
      "8.b klase" : 6,
      "8.c klase" : 7,
      "8.d klase" : 8,
      "9.a klase" : 9,
      "9.b klase" : 10,
      "9.c klase" : 11,
      "9.d klase" : 12,
      "10.a klase" : 13,
      "10.b klase" : 14,
      "10.c klase" : 15,
      "10.d klase" : 16,
      "10.e klase" : 17,
      "10.f klase" : 18,
      "10.sb klase" : 19,
      "11.a klase" : 20,
      "11.b klase" : 21,
      "11.c klase" : 22,
      "11.d klase" : 23,
      "11.e klase" : 24,
      "11.f klase" : 25,
      "11.sb klase" : 26,
      "12.a klase" : 27,
      "12.b klase" : 28,
      "12.c klase" : 29,
      "12.d klase" : 30,
      "12.e klase" : 31,
      "12.f klase" : 32,
      "12.sb klase" : 33,
    };

    return Scaffold(
      key: _scaffoldKey,
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
          reverse: true,
          child: Form(
            key: _formKey,
            child:Column(
              children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30.w),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        color: blue,
                        fontSize: 28.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),

              Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        PermissionStatus storageStatus = await Permission.storage.request();

                        if(storageStatus == PermissionStatus.granted){
                          pickImageFromGallery();
                        }
 
                        if(storageStatus == PermissionStatus.denied){
                          if(mounted){
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You need to provide Gallery access to upload photo')));
                          }
                        }
  
                        if(storageStatus == PermissionStatus.permanentlyDenied){
                          openAppSettings();
                        }
                      },
                      child: CircleAvatar(
                        radius: 50.h,
                        backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                        child: (imagePath != "")
                            ? ClipOval(
                                child: Image.file(
                                  File(imagePath), 
                                  fit: BoxFit.fill
                                ),
                              )
                            : Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 80.h,
                              ),
                      )
                    )
                  ]
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 30.w, top: 25.h, right: 30.w),
                child: TextFormField(
                  controller: emailController,
                  style: TextStyle(
                    fontSize: 14.h,
                    color: blue,
                  ),
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(
                      fontSize: 14.h,
                      color: lightGrey,
                    ),
                    icon: const Icon(Icons.alternate_email),
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) => email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email'
                        : null,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 30.w, top: 10.h, right: 30.w),
                child: TextFormField(
                  controller: fullNameController,
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
                    message: "Your full name is required"
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 0, left: 65.w, right: 30.w),
                child: DropdownButton<String>(
                  menuMaxHeight: 350.h,
                  isExpanded: true,
                  itemHeight: 60.h,
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
                padding: EdgeInsets.only(left: 30.w, top: 2.5.h, right: 30.w),
                child: TextFormField(
                  controller: passwordController,
                  style: TextStyle(
                    fontSize: 14.h,
                    color: blue,
                  ),
                  decoration: InputDecoration(
                    hintText: "Password",
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
                  validator: FieldValidator.password(
                    minLength: 8,
                    shouldContainNumber: true,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 30.w, top: 10.h, right: 30.w),
                child: TextFormField(
                  controller: repeatPasswordController,
                  style: TextStyle(
                    fontSize: 14.h,
                    color: blue,
                  ),
                  decoration: InputDecoration(
                    hintText: "Repeat Password",
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
                padding: EdgeInsets.only(top: 35.h, left: 30.w, right: 30.w),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (signUpState.isLoading) {
                        const CircularProgressIndicator();
                      } else {
                        ref
                            .read(signUpScreenControllerProvider.notifier)
                            .signUp(
                              imagePath,
                              emailController.text,
                              fullNameController.text,
                              dropdownValues[dropdownValue]!,
                              passwordController.text
                            );
                      }
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
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 16.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 7.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                    Text(
                      "Already have a profile?",
                      style: TextStyle(fontSize: 14.h, color: lightGrey),
                    ),
                    GestureDetector(
                      onTap: () {
                        //Nav to login page
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 30.h,
                        width: 50.w,
                        alignment: Alignment.center,
                        child: Text(
                          "Login",
                          style: TextStyle(color: blue, fontSize: 14.h),
                        )
                      ),
                    ),
                  ]
                ),
              )
            ],
          ),
        ),
        ),
      ),
    );
  }
}
