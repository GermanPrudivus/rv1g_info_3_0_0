import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rv1g_info/src/features/authentication/presentation/controllers/email_verification_controller.dart';

import '../../../../constants/auth_const.dart';

class EmailVerificationPage extends ConsumerWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref
      .read(emailVerificationScreenControllerProvider.notifier)
      .verifyEmail();

    return Scaffold(
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 70.h),
              child: SizedBox(
                height: 200.h,
                child: SvgPicture.network(emailSvg),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 45.h, left: 30.w),
                  child: Text(
                    "Email\nverification",
                    style: TextStyle(
                      fontSize: 28.h,
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
                      "Verify your email to secure your account and access exclusive app features.",
                      style: TextStyle(
                        fontSize: 18.h,
                        color: lightGrey,    
                      )
                    ),
                  )
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }
}