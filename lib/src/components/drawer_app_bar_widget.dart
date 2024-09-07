import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/constants/theme.dart';

class DrawerAppBarWidget extends StatefulWidget {
  final String title;
  final bool add;
  final Widget navigateTo;

  const DrawerAppBarWidget({
    super.key, 
    required this.title,
    required this.add,
    required this.navigateTo,
  });

  @override
  State<DrawerAppBarWidget> createState() => _DrawerAppBarWidgetState();
}

class _DrawerAppBarWidgetState extends State<DrawerAppBarWidget> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
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

      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      shadowColor: appBarShadow,
      scrolledUnderElevation: 0,
      elevation: 3,
      toolbarHeight: 60.h,

      centerTitle: true,
      title: Text(
        widget.title,
        style: TextStyle(
          fontSize: 20.w,
          color: blue,
          fontWeight: FontWeight.bold
        ),
      ),

      actions: [
        if(widget.add)
          GestureDetector(
            onTap: () async{
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => widget.navigateTo
                )
              );
            },
            child: Container(
              color: Colors.transparent,
              height: 60.h,
              width: 40.w,
              alignment: Alignment.center,
              child: Icon(
                Icons.add,
                color: blue,
                size: 30.h,
              ),
            ),
          )
      ],
    );
  }
}