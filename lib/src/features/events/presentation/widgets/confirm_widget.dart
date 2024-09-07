import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/features/events/presentation/controllers/add_participant_controller.dart';
import 'package:rv1g_info/src/utils/exception.dart';

import '../../../../constants/theme.dart';
import '../../doamain/models/event.dart';

class ConfirmWidget extends ConsumerStatefulWidget {
  final String qrinfo;
  final Event event;

  const ConfirmWidget({
    required this.qrinfo,
    required this.event,
    super.key
  });

  @override
  ConsumerState<ConfirmWidget> createState() => _ConfirmWidgetState();
}

class _ConfirmWidgetState extends ConsumerState<ConfirmWidget> {
  String fullName = "";
  String form = "";
  String id = "";

  @override
  void initState() {
    List info = widget.qrinfo.split(" ");
    id = info[0];
    fullName = info[1]+" "+info[2];
    form = info[3];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {   
    ref.listen<AsyncValue>(
      addParticipantControllerProvider,
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
                    "Pievienot jaunu dalībnieku:",
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
                    fullName,
                    style: TextStyle(
                      fontSize: 18.w,
                      height: 1.w,
                    ),
                  ),
                  Text(
                    form,
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
                        .read(addParticipantControllerProvider.notifier)
                        .addParticipant(int.parse(id), widget.event)
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
                      "Pievienot",
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