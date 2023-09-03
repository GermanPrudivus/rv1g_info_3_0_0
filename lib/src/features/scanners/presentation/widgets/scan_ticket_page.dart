import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../components/scanner_border_painter.dart';
import '../../../../constants/theme_colors.dart';

class ScanTicketPage extends StatefulWidget {
  const ScanTicketPage({super.key});

  @override
  State<ScanTicketPage> createState() => _ScanTicketPageState();
}

class _ScanTicketPageState extends State<ScanTicketPage> {
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
                      "Noskanēt biļeti:",
                      style: TextStyle(
                        fontSize: 22.h,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
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