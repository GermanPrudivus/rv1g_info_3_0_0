import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rv1g_info/main.dart';
import 'package:rv1g_info/src/constants/auth_const.dart';
import 'package:rv1g_info/src/features/authentication/presentation/widgets/forgot_password_page.dart';
import 'package:rv1g_info/src/utils/auth_exception.dart';
import 'package:rv1g_info/src/features/authentication/presentation/widgets/sign_up_page.dart';

import '../../../../constants/theme_colors.dart';
import '../controllers/sign_in_controller.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {

  bool notVisibility = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue>(
      signInScreenControllerProvider,
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
          Navigator.pushAndRemoveUntil(
            context, 
            MaterialPageRoute(builder: (context) => const MyHomePage()),
            (route) => true
          );
        }
        state.showSnackbarOnError(context);
      }
    );

    return Scaffold(
      backgroundColor: Colors.white,
        body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 100.h),
                child: SizedBox(
                  height: 146.h,
                  child: SvgPicture.network(loginSvg),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 40.h, left: 30.w),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 28.h,
                        color: blue,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                  ),
                ],
              ),

              //TextForms

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
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.w, top: 15.h, right: 30.w),
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
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5.h, right: 30.w),
                    child: GestureDetector(
                      onTap: () {
                        //Nav to forgot password page
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordPage()
                          )
                        );
                      },
                      child: Container(
                        height: 30.h,
                        width: 130.w,
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(color: blue, fontSize: 14.h),
                        )
                      ),
                    )
                  )
                ],
              ),

              //Button
              Padding(
                padding: EdgeInsets.only(top: 17.h, left: 30.w, right: 30.w),
                child: ElevatedButton(
                  onPressed: () {
                    ref
                      .read(signInScreenControllerProvider.notifier)
                      .signIn(emailController.text, passwordController.text);
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
                    "Login",
                    style: TextStyle(
                      fontSize: 16.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 13.h, left: 30.w, right: 30.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: Container(
                        height: 1.h,
                        width: 129.w,
                        color: lightGrey,
                      ),
                    ),
                    Text(
                      "OR",
                        style: TextStyle(fontSize: 14.h, color: lightGrey),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                        child: Container(
                        height: 1.h,
                        width: 129.w,
                        color: lightGrey,
                      ),
                    ),
                  ]
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 7.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                    Text(
                      "New to school?",
                      style: TextStyle(fontSize: 14.h, color: lightGrey),
                    ),
                    GestureDetector(
                      onTap: () {
                        //Nav to signup page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage()
                          ),
                        );
                      },
                      child: Container(
                        height: 30.h,
                        width: 70.w,
                        alignment: Alignment.center,
                        child: Text(
                          "Register",
                          style: TextStyle(color: blue, fontSize: 14.h),
                        )
                      ),
                    ),
                  ]
                ),
              )
            ],
          ),
        )
      )
    );
  }
}
