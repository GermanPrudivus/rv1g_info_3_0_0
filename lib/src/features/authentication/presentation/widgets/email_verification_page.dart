import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/const.dart';
import '../../../../constants/theme_colors.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 100.h),
              child: SizedBox(
                height: 220.h,
                child: SvgPicture.network(emailSvg),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 60.h, left: 30.w),
                  child: Text(
                    "Email\nverification",
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
                      "Verify your email to secure your account and access exclusive app features.",
                      style: TextStyle(
                        fontSize: 16.w,
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