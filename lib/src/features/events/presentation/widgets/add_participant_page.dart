import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/components/qr_code_border_painter.dart';

import '../../../../constants/theme_colors.dart';

class AddParticipantPage extends StatefulWidget {
  const AddParticipantPage({super.key});

  @override
  State<AddParticipantPage> createState() => _AddParticipantPageState();
}

class _AddParticipantPageState extends State<AddParticipantPage> {
  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      "Reģistrēt jaunu dalībnieku:",
                      style: TextStyle(
                        fontSize: 22.h,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
                Text(
                  "Ievietojiet QR kodu kvadrāta laukā",
                  style: TextStyle(
                    fontSize: 16.h,
                    color: blue
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                      decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(15.h),
                        color: Colors.grey.shade400,
                      ),
                      height: 450.h,
                    ),
                    CustomPaint(
                      size: Size(240.w, 240.h), // Adjust the size as needed
                      painter: QRCodeBorderPainter(),
                    ),
                  ],
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}