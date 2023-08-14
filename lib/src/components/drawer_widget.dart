import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerWidget extends StatefulWidget {
  final String profilePicUrl;
  final String fullName;

  const DrawerWidget({
    required this.profilePicUrl,
    required this.fullName,
    super.key
  });

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  List<Widget> screens = [];

  String profilePicUrl = "";
  String fullName = "";

  @override
  void initState() {
    profilePicUrl = widget.profilePicUrl;
    fullName = widget.fullName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    profilePicUrl == ""
                      ? CircleAvatar(
                          radius: 20.h,
                          backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30.h,
                          )
                        )
                      : CircleAvatar(
                          radius: 20.h,
                          backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                          backgroundImage: NetworkImage(profilePicUrl),
                        ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 40.h,
                        width: 40.h,
                        color: Colors.transparent,
                        child: Icon(
                          Icons.qr_code,
                          size: 30.h,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  fullName,
                  style: TextStyle(
                    fontSize: 16.h,
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }
}