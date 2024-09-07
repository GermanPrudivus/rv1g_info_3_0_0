import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/features/scanners/presentation/controllers/scan_ticket_controller.dart';

import '../../../../constants/theme.dart';

class ActivateWidget extends ConsumerStatefulWidget {
  final int id;
  final String fullName;
  final String form;
  final int eventId;

  const ActivateWidget({
    required this.id,
    required this.fullName,
    required this.form,
    required this.eventId,
    super.key
  });

  @override
  ConsumerState<ActivateWidget> createState() => _ActivateWidgetState();
}

class _ActivateWidgetState extends ConsumerState<ActivateWidget> {
  @override
  Widget build(BuildContext context) {   
    return AlertDialog(
      shape: RoundedRectangleBorder(
		    borderRadius: BorderRadius.circular(15.h),
	    ),
      contentPadding: EdgeInsets.zero,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Container(
          width: 1.sw,
          alignment: Alignment.topLeft,
          color: Colors.white,
          margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 20.h, bottom: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Text(
                    "Aktivizēt jaunu dalībnieku:",
                    style: TextStyle(
                      fontSize: 18.w,
                      height: 1.w,
                    ),
                  )
                ],
              ),

              SizedBox(height: 60.h),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.fullName,
                    style: TextStyle(
                      fontSize: 18.w,
                      height: 1.w,
                    ),
                  ),
                  Text(
                    widget.form,
                    style: TextStyle(
                      fontSize: 17.w,
                      height: 1.w,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 60.h),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(125.w, 40.h),
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.h),
                        side: BorderSide(color: blue)
                      )
                    ),
                    child: Text(
                      "Atcelt",
                      style: TextStyle(
                        fontSize: 15.w,
                        color: blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref
                        .read(scanTicketControllerProvider.notifier)
                        .activateParticipant(widget.id, widget.eventId)
                        .whenComplete(() {
                          Navigator.pop(context);
                        });
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(125.w, 40.h),
                      backgroundColor: blue,
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.h)
                      )
                    ),
                    child: Text(
                      "Aktivizēt",
                      style: TextStyle(
                        fontSize: 15.w,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      )
    );
  }
}