import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/theme_colors.dart';
import 'scanner_border_painter.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      "Verificēšana:",
                      style: TextStyle(
                        fontSize: 22.h,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Text(
                  "Ievietojiet savu Rīgas Skolēna karti attiecīgajā laukā!",
                  style: TextStyle(
                    fontSize: 16.h,
                    color: blue
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                Text(
                  "Jūsu kartes fotogrāfija un informācija no tās netiek nekur saglabāta, un tā tiek izmantota tikai vienreizēji!",
                  style: TextStyle(
                    fontSize: 15.h,
                    color: Colors.red
                  ),
                  textAlign: TextAlign.center,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 5.h, bottom: 10.h),
                      decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(15.h),
                        color: Colors.grey.shade400,
                      ),
                      height: 400.h,
                    ),
                    CustomPaint(
                      size: Size(240.w, 310.h), // Adjust the size as needed
                      painter: ScannerBorderPainter(),
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