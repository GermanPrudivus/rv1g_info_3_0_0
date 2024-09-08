import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../constants/theme.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 20.h, left: 25.w, right: 25.w),
          child: Column(
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
              SizedBox(height: 100.h),
              SizedBox(
                height: 230.h,
                child: SvgPicture.asset("assets/email.svg"),
              ),
              SizedBox(height: 60.h),
              Row(
                children: [
                  Text(
                    "Email verification",
                    style: TextStyle(
                      fontSize: 30.w,
                      color: onBackground,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      "Verificē savu e-pastu, lai pasargātu savu profilu. Ja tu neesi saņēmis e-pastu, tad pārbaudi 'Spam' sadaļu!",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16.w,
                        color: lightGrey,    
                      )
                    ),
                  ),
                ],
              ),
            ]
          ),
        )
      ),
    );
  }
}