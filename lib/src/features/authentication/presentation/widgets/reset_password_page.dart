import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:the_validator/the_validator.dart';

import '../../../../constants/auth_const.dart';
import '../../../../constants/theme_colors.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  final String email;

  const ResetPasswordPage({super.key, required this.email});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {

  bool notVisibility = true;
  bool validPassword = true;

  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    /*ref.listen<AsyncValue>(
      resetPasswordScreenControllerProvider,
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
          Navigator.pop(context);
        }
        state.showSnackbarOnError(context);
      }
    );*/

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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: SizedBox(
                    height: 176.h,
                    child: SvgPicture.network(resetPasswordSvg),
                  ),
                ),

                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 45.h, left: 30.w),
                      child: Text(
                        "Reset\npassword",
                        style: TextStyle(
                          fontSize: 28.h,
                          color: blue,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.only(left: 30.w, top: 20.h, right: 30.w),
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

                Padding(
                  padding: EdgeInsets.only(top: 50.h, left: 30.w, right: 30.w),
                  child: ElevatedButton(
                    onPressed: () {
                      /*ref
                        .read(resetPasswordScreenControllerProvider.notifier)
                        .resetPassword(widget.email, passwordController.text);*/
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
                      "Submit",
                      style: TextStyle(
                        fontSize: 16.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}