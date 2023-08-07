import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/app_bar_widget.dart';

class SchedulePage extends StatefulWidget {
  final bool isAdmin;
  final bool isVerified;

  const SchedulePage({
    required this.isAdmin,
    required this.isVerified,
    super.key
  });

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String dropdownValue = 'Konsultāciju grafiks';

  Widget buildImageZoom(BuildContext context, String url) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InteractiveViewer(
              child: Image.network(
                url,
                fit: BoxFit.fill,
              )
            )
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBarWidget(
          title: "Izmaiņas", 
          add: widget.isAdmin, 
          navigateTo: const AboutDialog(),
          showDialog: true,
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {},
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButton<String>(
                          focusColor: Colors.black54,
                          borderRadius: BorderRadius.circular(20.w),
                          dropdownColor: const Color.fromRGBO(241, 244, 251, 1),
                          value: dropdownValue,
                          elevation: 20.h.toInt(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.h
                          ),
                          underline: Container(
                            height: 2.h,
                            color: const Color.fromRGBO(42, 84, 141, 1),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                              if(dropdownValue == 'Konsultāciju grafiks' ){
                                      
                              }
                            });
                          },
                          items: <String>['Konsultāciju grafiks', '7.klase', '8.klase', '9.klase', '10.klase', '11.klase', '12.klase']
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                        )
                      ],
                    )
                  ),
                ],
              )
            )
          ),
        ),
      )
    );
  }
}