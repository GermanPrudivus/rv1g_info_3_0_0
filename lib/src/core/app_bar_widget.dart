import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/constants/theme_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppBarWidget extends StatefulWidget {
final String title;

  const AppBarWidget({super.key, required this.title});

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
        onTap: () {
          print('avatar tap');
        },
        child: Container(
          height: 60.h,
          alignment: Alignment.centerRight,
          child: profilePicUrl == ""
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
        ),
      ),

      centerTitle: true,
      title: Text(
        widget.title,
        style: TextStyle(
          fontSize: 20.h,
          color: blue,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}

Future<String> getProfilePicUrl() async{
  final supabase = Supabase.instance.client;

  final email = supabase.auth.currentUser?.email;
  final res = await supabase
    .from('users')
    .select('profilePicUrl')
    .eq('email', email);

  final profilePicUrl = res[0]['profilePicUrl'];

  return await profilePicUrl;
}