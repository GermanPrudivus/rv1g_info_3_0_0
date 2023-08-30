import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rv1g_info/src/components/drawer_app_bar_widget.dart';
import 'package:rv1g_info/src/features/authentication/presentation/widgets/sign_in_page.dart';
import 'package:rv1g_info/src/features/settings/presentation/controllers/settings_controller.dart';
import 'package:rv1g_info/src/features/settings/presentation/widgets/confirm_delete_widget.dart';
import 'package:rv1g_info/src/features/settings/presentation/widgets/contact_info_page.dart';
import 'package:rv1g_info/src/features/settings/presentation/widgets/edit_user_page.dart';

import '../../../../constants/theme_colors.dart';
import '../../domain/models/app_user.dart';
import '../../domain/models/role.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {

  AppUser user = AppUser(
    id: 0, 
    profilePicUrl: "", 
    fullName: "",
    formId: 0, 
    form: "", 
    email: "", 
    verified: false, 
    createdDateTime: ""
  );

  List<Role> roles = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserInfo();
    });
    super.initState();
  }

  Future<void> getUserInfo() async {
    ref
      .read(settingsControllerProvider.notifier)
      .getUser()
      .then((value) {
        setState(() {
          user = value!;
        });
        ref
          .read(settingsControllerProvider.notifier)
          .getUserRoles(value!.id)
          .then((value) {
            setState(() {
              roles = value!;
            });
          });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: DrawerAppBarWidget(
          title: "Iestatījumi", 
          add: false, 
          navigateTo: Placeholder(), 
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h, bottom: 15.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              user.profilePicUrl == ""
                                ? CircleAvatar(
                                    radius: 30.h,
                                    backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 40.h,
                                    )
                                  )
                                : CircleAvatar(
                                    radius: 30.h,
                                    backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                                    backgroundImage: NetworkImage(user.profilePicUrl),
                                  )
                            ],
                          ),
                          SizedBox(width: 15.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    user.fullName,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.h,
                                      fontWeight: FontWeight.bold
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 2.5.h),
                              Row(
                                children: [
                                  Text(
                                    user.email,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13.h
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ]
                      ),
                      SizedBox(width: 15.w),
                      Column(
                        children: [
                          Icon(
                            Icons.chevron_right,
                            size: 24.h,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return EditUserPage(user: user);
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
                  ).whenComplete(() => getUserInfo());
                },
              ),
              Divider(
                thickness: 2.h,
                height: 20.h,
                color: blue,
                indent: 20.h,
                endIndent: 20.h,
              ),

              //roles
              Container(
                height: 225.h,
                child: roles.isEmpty
                  ? Center(
                      child: Text(
                        "Nav amatu",
                        style: TextStyle(
                          color: blue,
                          fontSize: 14.h
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: roles.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        String title = "";

                        if(roles[index].role[0] == "P"){
                          title = roles[index].role.substring(0,21);
                        } else if(roles[index].role[0] == "B"){
                          title = roles[index].role.substring(0,19);
                        } else {
                          title = roles[index].role;
                        }

                        return Container(
                          margin: EdgeInsets.only(left: 25.w, right: 25.w),
                          padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color:Colors.grey,
                                width: 1.h,
                              )
                            )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.h
                                ),
                              ),
                              SizedBox(height: 5.h,),
                              Text(
                                roles[index].description,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14.h
                                ),
                              ),
                              SizedBox(height: 5.h,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    DateFormat('dd.MM.yyyy. HH:mm', 'en_US')
                                      .format(
                                        DateTime.parse(roles[index].startedDatetime)
                                      ),
                                    style: TextStyle(
                                     color: Colors.black54,
                                      fontSize: 14.h
                                    ),
                                  ),
                                  Text(
                                    " - ",
                                    style: TextStyle(
                                     color: Colors.black54,
                                      fontSize: 14.h
                                    ),
                                  ),
                                  Text(
                                    roles[index].endedDatetime != ""
                                      ? DateFormat('dd.MM.yyyy. HH:mm', 'en_US')
                                          .format(
                                            DateTime.parse(roles[index].endedDatetime)
                                          )
                                      : "Nav noteikts",
                                    style: TextStyle(
                                     color: Colors.black54,
                                      fontSize: 14.h
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }
                    )
              ),
              Divider(
                thickness: 2.h,
                height: 20.h,
                color: blue,
                indent: 20.h,
                endIndent: 20.h,
              ),

              //settings
              Container(
                child: Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.only(left: 15.w, right: 15.w, top:15.h, bottom: 15.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.w),
                                    color: Colors.blue,
                                  ),
                                  child: Icon(
                                    Icons.logout,
                                    size: 22.h,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                Text(
                                  "Iziet no sava profila",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.h,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: 5.w),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                              size: 24.h,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        ref
                          .read(settingsControllerProvider.notifier)
                          .logout()
                          .whenComplete(() {
                            Navigator.popUntil(context, (route) => false);
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => SignInPage()
                              )
                            );
                          });
                      },
                    ),
                  ],
                ),
              ),

              Container(
                child: Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h, bottom: 15.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.w),
                                    color: Colors.red,
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    size: 22.h,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                Text(
                                  "Izdzēst savu profilu",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.h,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: 5.w),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                              size: 24.h,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context, 
                          builder: (context) => ConfirmDeleteWidget(
                            fullName: user.fullName,
                            avatarUrl: user.profilePicUrl,
                          ),
                          barrierDismissible: true,
                        );
                      },
                    ),
                  ],
                ),
              ),

              Container(
                child: Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.only(left: 15.w, right: 15.w, top:15.h, bottom: 15.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.w),
                                    color: Colors.orange,
                                  ),
                                  child: Icon(
                                    Icons.question_answer,
                                    size: 22.h,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                Text(
                                  "Kontaktinformācija",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.h,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: 5.w),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                              size: 24.h,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return ContactInfoPage();
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
                        ).whenComplete(() => getUserInfo());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}