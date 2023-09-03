import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/constants/theme_colors.dart';

class AppBarWidget extends StatefulWidget {
  final String title;
  final String profilePicUrl;
  final bool add;
  final Widget navigateTo;
  final bool showDialog;
  final Function(BuildContext) openDrawerCallback;

  const AppBarWidget({
    super.key, 
    required this.title,
    required this.profilePicUrl,
    required this.add,
    required this.navigateTo,
    required this.showDialog,
    required this.openDrawerCallback
  });

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      shadowColor: appBarShadow,

      toolbarHeight: 60.h,

      leading: GestureDetector(
        onTap: () => widget.openDrawerCallback(context),
        child: Container(
          height: 60.h,
          alignment: Alignment.centerRight,
          child: widget.profilePicUrl == ""
            ? CircleAvatar(
                radius: 18.h,
                backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30.h,
                )
              )
            : CircleAvatar(
                radius: 18.h,
                backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                backgroundImage: NetworkImage(widget.profilePicUrl),
              ),
        ),
      ),

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
              if(widget.showDialog){
                return showDialog(
                  context: context, 
                  builder: (context) => widget.navigateTo,
                  barrierDismissible: false,
                );
              } else {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => widget.navigateTo
                  )
                );
              }
            },
            child: Container(
              color: Colors.transparent,
              height: 60.h,
              width: 40.w,
              alignment: Alignment.center,
              child: Icon(
                Icons.add,
                color: blue,
                size: 30.w,
              ),
            ),
          )
      ],
    );
  }
}