import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/constants/auth_const.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          size: 30.h,
          color: blue
        ),
        toolbarHeight: 60.h,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
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
                      onTap: () {
                        print("Avatar");
                      },
                      child: CircleAvatar(
                        radius: 50.h,
                        backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                        child: Icon(
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
            ],
          ),
        ),
      ),
    );
  }
}
