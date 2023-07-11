import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rv1g_info/src/constants/auth_const.dart';
import 'package:rv1g_info/src/features/authentication/presentation/widgets/sign_up_page.dart';

import '../controllers/sign_in_controller.dart';
import '../states/sign_in_state.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notvisibility = ref.watch(notVisibilityStateProvider);

    final AsyncValue<void> signInState =
        ref.watch(signInScreenControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
        body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 90.h),
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
                        if (notvisibility == false) {
                          ref.read(notVisibilityStateProvider.notifier).state = true;
                        } else {
                          ref.read(notVisibilityStateProvider.notifier).state = false;
                        }
                      },
                      child: Icon(notvisibility
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                    ),
                    suffixIconColor: lightGrey,
                  ),
                  obscureText: notvisibility,
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
                    if (signInState.isLoading) {
                      const CircularProgressIndicator();
                    } else {
                      ref
                          .read(signInScreenControllerProvider.notifier)
                          .signIn("", "");
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
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage()
                          ),
                          (route) => true
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
