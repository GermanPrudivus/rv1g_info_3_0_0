import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rv1g_info/src/features/authentication/presentation/controllers/forgot_password_page.dart';
import 'package:rv1g_info/src/utils/auth_exception.dart';
import 'package:the_validator/the_validator.dart';

import '../../../../constants/const.dart';
import '../../../../constants/theme.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue>(
      forgotPasswordScreenControllerProvider,
      (_, state) {
        if(state.isLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator(color: blue))
          );
        } else {
          context.pop();
        }
        state.showSnackbarOnError(context);
      }
    );

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 20.h, left: 25.w, right: 25.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Icon(
                        Icons.chevron_left,
                        color: blue, 
                        size: 34.h,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 70.h),
                SizedBox(
                  height: 180.h,
                  child: SvgPicture.asset('assets/forgot_password.svg'),
                ),
                SizedBox(height: 40.h),
                Row(
                  children: [
                    Text(
                      "Forgot password?",
                      style: TextStyle(
                        fontSize: 30.w,
                        color: blue,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  "Don’t worry! It happens. Please enter the address associated with your account.",
                  style: TextStyle(
                    fontSize: 15.w,
                    color: surface.withOpacity(0.4),    
                  )
                ),
                SizedBox(height: 25.h),
                TextFormField(
                  controller: emailController,
                  style: TextStyle(
                    fontSize: 15.w,
                    color: blue,
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(
                      fontSize: 15.w,
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
                  validator: FieldValidator.email(message: "Type a valid email")
                ),
                SizedBox(height: 50.h),
                ElevatedButton(
                  onPressed: () {
                    ref
                      .read(forgotPasswordScreenControllerProvider.notifier)
                      .resetPassword(emailController.text);
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
                    "Send an email",
                    style: TextStyle(
                      fontSize: 17.w,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
              ],
            ),
          )
        )
      )
    );
  }
}