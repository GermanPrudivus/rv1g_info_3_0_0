import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/constants/theme_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppBarWidget extends StatefulWidget {
  final String title;
  final bool add;
  final Widget navigateTo;
  final bool showDialog;
  final Function(BuildContext) openDrawerCallback;

  const AppBarWidget({
    super.key, 
    required this.title,
    required this.add,
    required this.navigateTo,
    required this.showDialog,
    required this.openDrawerCallback
  });

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {

  String profilePicUrl = "";

  @override
  void initState() {
    getProfilePicUrl()
      .then((value) {
        setState(() {
          profilePicUrl = value;
        });
      }
    );
    super.initState();
  }

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
          child: profilePicUrl == ""
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
                backgroundImage: NetworkImage(profilePicUrl),
              ),
        ),
      ),

      centerTitle: true,
      title: Text(
        widget.title,
        style: TextStyle(
          fontSize: 19.h,
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
                size: 30.h,
              ),
            ),
          )
      ],
    );
  }
}

Future<String> getProfilePicUrl() async{
  final supabase = Supabase.instance.client;

  final email = supabase.auth.currentUser?.email;
  final res = await supabase
    .from('users')
    .select('profile_pic_url')
    .eq('email', email);

  final profilePicUrl = res[0]['profile_pic_url'];

  return await profilePicUrl;
}