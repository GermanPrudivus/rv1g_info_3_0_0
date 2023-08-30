import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketQRCodeWidget extends StatelessWidget {
  final String data;

  const TicketQRCodeWidget({
    required this.data,
    super.key
  });

  @override
  Widget build(BuildContext context) {
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
          margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Biļetes QR kods:",
                    style: TextStyle(
                      fontSize: 18.h
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.h),
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