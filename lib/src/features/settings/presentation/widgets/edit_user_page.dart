import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../components/drawer_app_bar_widget.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({super.key});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: DrawerAppBarWidget(
          title: "Profils", 
          add: false, 
          navigateTo: Placeholder(), 
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}