import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/constants/theme_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TabAppBarWidget extends StatefulWidget {
  final String title;
  final int tabQuant;
  final List<String> tabNames;
  final bool add;
  final Widget navigateTo;
  late TabController tabController;

  TabAppBarWidget({
    super.key, 
    required this.title, 
    required this.tabQuant,
    required this.tabNames,
    required this.tabController,
    required this.add,
    required this.navigateTo,
  });

  @override
  State<TabAppBarWidget> createState() => _TabAppBarWidgetState();
}

class _TabAppBarWidgetState extends State<TabAppBarWidget> with TickerProviderStateMixin {

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
          color: Colors.white,
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
          fontSize: 22.h,
          color: blue,
          fontWeight: FontWeight.bold
        ),
      ),

      bottom: TabBar(
          indicatorColor: blue,
          indicatorWeight: 2.5.h,
          controller: widget.tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black45,
          labelStyle: TextStyle(
            fontSize: 16.h,
          ),
          tabs: <Widget>[
            for(int i=0;i<widget.tabQuant;i++)
              SizedBox(
                height: 30.h,
                child: Tab(text: widget.tabNames[i],),
              )
          ],
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