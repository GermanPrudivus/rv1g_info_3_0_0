import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/features/authentication/presentation/widgets/sign_in_page.dart';
import 'package:rv1g_info/src/features/settings/presentation/controllers/settings_controller.dart';
import 'package:the_validator/the_validator.dart';

import '../../../../constants/theme_colors.dart';

class ConfirmDeleteWidget extends ConsumerStatefulWidget {
  final String fullName;
  final String avatarUrl;

  const ConfirmDeleteWidget({
    required this.fullName,
    required this.avatarUrl,
    super.key
  });

  @override
  ConsumerState<ConfirmDeleteWidget> createState() => _ConfirmDeleteWidgetState();
}

class _ConfirmDeleteWidgetState extends ConsumerState<ConfirmDeleteWidget> {

  TextEditingController fullNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
                    "Apstiprini savas darbības:",
                    style: TextStyle(
                      fontSize: 18.h
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Text(
                "Ieraksti savu pilnu vārdu, lai turpināt!",
                style: TextStyle(
                  fontSize: 14.h,
                  color: blue
                ),
              ),
              SizedBox(height: 10.h),
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: TextFormField(
                    controller: fullNameController,
                    style: TextStyle(
                      fontSize: 14.h,
                      color: blue,
                    ),
                    decoration: InputDecoration(
                      hintText: "${widget.fullName}",
                      hintStyle: TextStyle(
                        fontSize: 13.h,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 2.h,
                          color: Colors.black
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 2.h,
                          color: blue
                        ),
                      ),
                    ),
                    cursorColor: blue,
                    validator: FieldValidator.equalTo(
                      widget.fullName,
                    ),
                  ),
                ),
              ),

              Padding(
                  padding: EdgeInsets.only(top: 70.h, bottom: 20.h),
                  child: ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        ref
                          .read(settingsControllerProvider.notifier)
                          .deleteUser(widget.avatarUrl)
                          .whenComplete(() {
                            Navigator.popUntil(context, (route) => false);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInPage()
                              )
                            );
                          });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(1.sw, 50.h),
                      backgroundColor: blue,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.h)
                      )
                    ),
                    child: Text(
                      "Izdzēst profilu",
                      style: TextStyle(
                        fontSize: 16.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        )
      )
    );
  }
}