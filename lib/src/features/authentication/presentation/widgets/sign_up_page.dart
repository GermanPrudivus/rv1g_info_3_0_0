import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rv1g_info/src/constants/const.dart';
import 'package:rv1g_info/src/features/authentication/presentation/components/button.dart';
import 'package:rv1g_info/src/features/authentication/presentation/components/text_form.dart';
import 'package:rv1g_info/src/features/authentication/presentation/state/sign_up_page.dart';
import 'package:rv1g_info/src/utils/auth_exception.dart';

import '../../../../constants/theme.dart';
import '../controllers/sign_up_controller.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  Future pickImageFromGallery() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 521,
      maxWidth: 512,
      imageQuality: 100,
    );

    File imageFile;

    imageFile = File(image!.path);
    ref.read(imagePathProvider.notifier).state = imageFile.path;
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = ref.watch(imagePathProvider);
    bool notVisibile = ref.watch(notVisibleProvider);

    ref.listen<AsyncValue>(
      signUpScreenControllerProvider,
      (_, state) {
        if(state.isLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator(color: onBackground))
          );
        } else {
          context.pop();
        }
        state.showSnackbarOnError(context);
      },
    );

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.only(right: 25.w, left: 25.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Icon(
                        Icons.chevron_left,
                        color: onBackground, 
                        size: 34.h,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Reģistrējies",
                  style: TextStyle(
                    color: onBackground,
                    fontSize: 30.w,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15.h),
                GestureDetector(
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
                  child: imagePath == ""
                    ? CircleAvatar(
                        radius: 50.h,
                        backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                        child: Icon(
                          Icons.person,
                          color: background,
                          size: 80.h,
                        )
                      )
                    : CircleAvatar(
                        radius: 50.h,
                        backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                        backgroundImage: FileImage(File(imagePath)),
                      )
                ),
                SizedBox(height: 15.h),
                TextForm(
                  value: ref.watch(emailProvider), 
                  hintText: "E-pasts", 
                  onChanged: (value) => ref.read(emailProvider.notifier).state = value.trim(), 
                  onValidated: (value) => ref.read(hasValidEmailProvider.notifier).state = value
                ),
                SizedBox(height: 10.h),
                TextForm(
                  value: ref.watch(fullNameProvider), 
                  hintText: "Vārds Uzvārds", 
                  onChanged: (value) => ref.read(fullNameProvider.notifier).state = value.trim(), 
                  onValidated: (value) => ref.read(hasFullNameProvider.notifier).state = value
                ),
                SizedBox(height: 10.h),
                DropdownButtonFormField<String>(
                  menuMaxHeight: 350.h,
                  isExpanded: true,
                  itemHeight: 50.h,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: background,
                    contentPadding: EdgeInsets.all(20.r),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(
                        color: onBackground.withOpacity(0.3),
                        width: 2.r,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(
                        color: onBackground.withOpacity(0.3),
                        width: 2.r,
                      ),
                    ),
                    hintText: 'Izvēlies savu klasi',
                    hintStyle: TextStyle(
                      color: onBackground.withOpacity(0.7),
                      fontSize: 16.r,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  iconEnabledColor: onBackground,
                  dropdownColor: const Color.fromRGBO(241, 244, 251, 1),
                  value: ref.watch(dropDownValueProvider),
                  elevation: 60.h.toInt(),
                  style: TextStyle(
                    fontSize: 16.r,
                    color: onBackground,
                  ),
                  onChanged: (String? newValue) => ref.read(dropDownValueProvider.notifier).state = newValue.toString(),
                  items: dropdownValues.keys.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 16.r,
                          color: onBackground.withOpacity(
                            value == "Izvēlies savu klasi"
                              ? 0.7
                              : 1
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10.h),
                TextForm(
                  value: ref.watch(passwordProvider), 
                  hintText: "Parole", 
                  onChanged: (value) => ref.read(passwordProvider.notifier).state = value.trim(), 
                  onValidated: (value) => ref.read(hasValidPasswordProvider.notifier).state = value,
                  visible: notVisibile,
                  suffix: GestureDetector(
                    onTap: () {
                      setState(() {
                        if(notVisibile == false) {
                          ref.read(notVisibleProvider.notifier).state = true;
                        } else {
                          ref.read(notVisibleProvider.notifier).state  = false;
                        }
                      });
                    },
                    child: Icon(notVisibile
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                      color: surface,
                      size: 20.r,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                TextForm(
                  value: ref.watch(repeatPasswordProvider), 
                  hintText: "Atkārto paroli", 
                  password: ref.watch(passwordProvider),
                  visible: true,
                  onChanged: (value) => ref.read(repeatPasswordProvider.notifier).state = value.trim(), 
                  onValidated: (value) => ref.read(hasValidRepeatPasswordProvider.notifier).state = value
                ),
                SizedBox(height: 30.h),
                Button(
                  text: "Reģistrēties",
                  onPressed: () {
                    if (ref.read(dropDownValueProvider) != "Izvēlies savu klasi" && ref.read(fullNameProvider).trim().split(' ').length > 1) {
                      ref
                        .read(signUpScreenControllerProvider.notifier)
                        .signUp(
                          imagePath,
                          ref.read(emailProvider).trim(),
                          ref.read(fullNameProvider).trim(),
                          dropdownValues[ref.read(dropDownValueProvider)]!,
                          ref.read(passwordProvider).trim()
                        );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'Lūdzu ievadi pareizas vērtības visos laukos!'
                          )
                        )
                      );
                    }
                  },
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
