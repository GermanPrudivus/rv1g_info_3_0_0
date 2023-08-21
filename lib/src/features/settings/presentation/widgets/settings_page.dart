import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/components/clean_navigator.dart';
import 'package:rv1g_info/src/components/drawer_app_bar_widget.dart';
import 'package:rv1g_info/src/features/settings/presentation/controllers/settings_controller.dart';
import 'package:rv1g_info/src/features/settings/presentation/widgets/edit_user_page.dart';

import '../../domain/models/app_user.dart';

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
    form: "", 
    email: "", 
    verified: false, 
    createdDateTime: ""
  );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUser();
    });
    super.initState();
  }

  Future<void> getUser() async {
    ref
      .read(settingsControllerProvider.notifier)
      .getUser()
      .then((value) {
        setState(() {
          user = value!;
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
                  padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h, bottom: 15.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      SizedBox(width: 5.w),
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
                  return navigateTo(
                    EditUserPage(), 
                    context
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}