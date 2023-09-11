import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/components/user_qr_code_widget.dart';
import 'package:rv1g_info/src/features/events/presentation/widgets/events_page.dart';
import 'package:rv1g_info/src/features/scanners/presentation/widgets/scanners_page.dart';
import 'package:rv1g_info/src/features/settings/presentation/widgets/settings_page.dart';
import 'package:rv1g_info/src/features/tickets/presentation/widgets/tickets_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/volunteering/presentation/widgets/volunteering_jobs_page.dart';

class DrawerWidget extends StatefulWidget {
  final String profilePicUrl;
  final String fullName;
  final List<String> events;
  final List<String> controllers;
  final bool isAdmin;

  const DrawerWidget({
    required this.profilePicUrl,
    required this.fullName,
    required this.events,
    required this.controllers,
    required this.isAdmin,
    super.key
  });

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  List<Widget> screens = [];

  String profilePicUrl = "";
  String fullName = "";

  String userData = '';

  bool enabled = false;

  @override
  void initState() {
    profilePicUrl = widget.profilePicUrl;
    fullName = widget.fullName;
    enabled = widget.isAdmin || widget.controllers.isNotEmpty || widget.events.isNotEmpty;
    getUser()
      .then((value) {
        userData = value;
      });
    super.initState();
  }

  void navigateTo(Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return page;
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeIn;
                                           
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                          
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      )
    );
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
                      onTap: () {
                        showDialog(
                          context: context, 
                          builder: (context) => UserQRCodeWidget(userData: userData),
                          barrierDismissible: true,
                        );
                      },
                      child: Container(
                        height: 40.h,
                        width: 40.h,
                        color: Colors.transparent,
                        child: Icon(
                          Icons.qr_code_2,
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
                    fontSize: 17.w,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 20.h),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Icon(
                        Icons.event_outlined,
                        color: Colors.black,
                        size: 25.h,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Pasākumi",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.w,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    return navigateTo(
                      EventsPage(
                        isAdmin: widget.isAdmin, 
                        events: widget.events
                      )
                    );
                  },
                ),
                SizedBox(height: 2.5.h),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Icon(
                        Icons.group_outlined,
                        color: Colors.black,
                        size: 25.h,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Brīvpratīgie",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.w,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    return navigateTo(
                      VolunteeringJobsPage(isAdmin: widget.isAdmin)
                    );
                  },
                ),
                SizedBox(height: 2.5.h),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Icon(
                        Icons.receipt_outlined,
                        color: Colors.black,
                        size: 25.h,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Biļetes",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.w,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    navigateTo(
                      TicketsPage()
                    );
                  },
                ),
                SizedBox(height: 2.5.h),
                ListTile(
                  enabled: enabled,
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Icon(
                        Icons.qr_code_scanner,
                        color: enabled
                          ? Colors.black
                          : Colors.grey,
                        size: 25.h,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Skeneri",
                        style: TextStyle(
                          color: enabled
                            ? Colors.black
                            : Colors.grey,
                          fontSize: 18.w,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    if(enabled){
                      navigateTo(
                        ScannersPage(
                          isAdmin: widget.isAdmin, 
                          controllers: widget.controllers
                        )
                      );
                    }
                  },
                ),
                SizedBox(height: 2.5.h),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Icon(
                        Icons.settings_outlined,
                        color: Colors.black,
                        size: 25.h,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Iestatījumi",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.w,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    return navigateTo(
                      SettingsPage(),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}

Future<String> getUser() async {
  final supabase = Supabase.instance.client;
  final email = supabase.auth.currentUser!.email;

  final res = await supabase
    .from('users')
    .select()
    .eq('email', email);

  final form = await supabase
    .from('forms')
    .select()
    .eq('id', res[0]['form_id']);

  return res[0]['id'].toString() + " "
       + res[0]['name'] + " "
       + res[0]['surname'] + " "
       + '${form[0]['number'].toString()}.${form[0]['letter']}';
}