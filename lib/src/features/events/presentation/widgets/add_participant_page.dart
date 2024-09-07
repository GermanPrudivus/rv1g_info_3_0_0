import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rv1g_info/src/components/scanner_border_painter.dart';
import 'package:rv1g_info/src/features/events/presentation/widgets/confirm_widget.dart';

import '../../../../constants/theme.dart';
import '../../doamain/models/event.dart';

class AddParticipantPage extends StatefulWidget {
  final Event event;

  const AddParticipantPage({
    required this.event,
    super.key
  });

  @override
  State<AddParticipantPage> createState() => _AddParticipantPageState();
}

class _AddParticipantPageState extends State<AddParticipantPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String result = "";
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        if(result != scanData.code.toString()){
          result = scanData.code.toString();
          showDialog(
            context: context, 
            builder: (context) => ConfirmWidget(qrinfo: result, event: widget.event),
            barrierDismissible: false,
          ).whenComplete(() {
            result = "";
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Reģistrēt jaunu dalībnieku:",
                      style: TextStyle(
                        fontSize: 22.w,
                        fontWeight: FontWeight.bold,
                        height: 1.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  "Ievietojiet QR kodu kvadrāta laukā",
                  style: TextStyle(
                    fontSize: 16.w,
                    color: blue,
                    height: 1.w,
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.h),
                        color: Colors.white,
                      ),
                      height: 450.h,
                      child: QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                      ),
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