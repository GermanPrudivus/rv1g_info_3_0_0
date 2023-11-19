import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rv1g_info/src/features/authentication/presentation/controllers/forgot_password_page.dart';
import 'package:rv1g_info/src/utils/auth_exception.dart';
import 'package:the_validator/the_validator.dart';

import '../../../../constants/const.dart';
import '../../../../constants/theme_colors.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {

  TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
        } else if (state.asData == null){
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
          Navigator.pop(context);
        }
        state.showSnackbarOnError(context);
      }
    );

    return Scaffold(
      key: _scaffoldKey,
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
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 65.h),
                  child: SizedBox(
                    height: 166.h,
                    child: SvgPicture.network(forgotPasswordSvg),
                  ),
                ),
  
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 30.h, left: 30.w),
                      child: Text(
                        "Forgot\npassword?",
                        style: TextStyle(
                          fontSize: 30.w,
                          color: blue,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.h, left: 30.w, right: 30.w),
                        child: Text(
                          "Don’t worry! It happens. Please enter the address associated with your account.",
                          style: TextStyle(
                            fontSize: 15.w,
                            color: lightGrey,    
                          )
                        ),
                      )
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.only(left: 30.w, top: 25.h, right: 30.w),
                  child: TextFormField(
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
                ),

                Padding(
                  padding: EdgeInsets.only(top: 50.h, left: 30.w, right: 30.w),
                  child: ElevatedButton(
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
                ),
              ],
            )
          )
        )
      ),
    );
  }
}