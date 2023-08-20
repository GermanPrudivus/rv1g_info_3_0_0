import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../constants/theme_colors.dart';

class UserQRCodeWidget extends StatelessWidget {
  final String userData;

  const UserQRCodeWidget({
    required this.userData,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    String data = userData.toString();
    
    return AlertDialog(
      shape: RoundedRectangleBorder(
		    borderRadius: BorderRadius.circular(15.h),
	    ),
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Container(
          width: 1.sw,
          height: 300.h,
          alignment: Alignment.topLeft,
          color: Colors.white,
          margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 20.h, bottom: 5.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Tava profila QR kods:",
                    style: TextStyle(
                      fontSize: 18.h
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Text(
                "Rādi to, lai nopirkt biļeti",
                style: TextStyle(
                  fontSize: 14.h,
                  color: blue
                ),
              ),
              SizedBox(height: 10.h),
              QrImageView(
                data: data,
                version: 2,
                size: 200.h,
              ),
            ],
          ),
        )
      )
    );
  }
}