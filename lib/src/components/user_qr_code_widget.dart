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
          alignment: Alignment.topLeft,
          color: Colors.white,
          margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 20.h, bottom: 35.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tava profila QR kods:",
                    style: TextStyle(
                      fontSize: 18.w,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              SizedBox(height: 17.5.h),
              Text(
                "Rādi to, lai nopirkt biļeti",
                style: TextStyle(
                  fontSize: 15.w,
                  color: blue
                ),
              ),
              SizedBox(height: 10.h),
              QrImageView(
                data: data,
                version: QrVersions.auto,
                size: 200.h,
              ),
            ],
          ),
        )
      )
    );
  }
}