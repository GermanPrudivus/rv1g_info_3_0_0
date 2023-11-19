import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rv1g_info/src/features/scanners/presentation/widgets/activate_widget.dart';
import 'package:rv1g_info/src/utils/exception.dart';

import '../../../../components/difference_in_dates.dart';
import '../../../../components/scanner_border_painter.dart';
import '../../../../constants/theme_colors.dart';
import '../../domain/models/scanner.dart';
import '../controllers/scan_ticket_controller.dart';

class ScanTicketPage extends ConsumerStatefulWidget {
  final Scanner scanner;

  const ScanTicketPage({
    required this.scanner,
    super.key
  });

  @override
  ConsumerState<ScanTicketPage> createState() => _ScanTicketPageState();
}

class _ScanTicketPageState extends ConsumerState<ScanTicketPage> {
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

          List info = result.split(" ");
          Scanner scanner = widget.scanner;

          String fullName = "";
          String form = "";
          bool active = false;

          ref
            .read(scanTicketControllerProvider.notifier)
            .getParticipant(int.parse(info[1]), scanner.id)
            .then((value) {
              print(value);
              setState(() {
                fullName = value![0];
                form = value[1];
                active = value[2];
              });
              if(
                scanner.key == int.parse(info[4]) &&
                scanner.title == info[3] &&
                differenceInDates(DateTime.parse(info[5].toString()), DateTime.now())[0] != "-" &&
                scanner.id == int.parse(info[2]) &&
                active == false
              ){
                showDialog(
                  context: context, 
                  builder: (context) => ActivateWidget(
                    id: int.parse(info[1]),
                    fullName: fullName, 
                    form: form,
                    eventId: scanner.id,
                  ),
                  barrierDismissible: false,
                );
              } else {
                result = "";
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      'Biļete nav derīga!'
                    )
                  )
                );
              }
            });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue>(
      scanTicketControllerProvider,
      (_, state) {
        if(state.isLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator(color: blue))
          );
        } else if (state.asData == null){
          state.showSnackbarOnError(context);
        } else {
          Navigator.pop(context);
        }
      },
    );
    
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Noskenēt biļeti:",
                      style: TextStyle(
                        fontSize: 24.w,
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
                    fontSize: 17.w,
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