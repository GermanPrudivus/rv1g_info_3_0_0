import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/constants/theme_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ignore: must_be_immutable
class TabAppBarWidget extends StatefulWidget {
  final String title;
  final int tabQuant;
  final List<String> tabNames;
  final List<bool> parametrs;//1.isAdmin, 2.showDialog, 3.isScrollable
  final List<Widget> addWidgets;
  late TabController tabController;

  TabAppBarWidget({
    super.key, 
    required this.title, 
    required this.tabQuant,
    required this.tabNames,
    required this.parametrs,
    required this.addWidgets,
    required this.tabController,
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
        onTap: () {},
        child: Container(
          height: 60.h,
          color: Colors.white,
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
          fontSize: 20.h,
          color: blue,
          fontWeight: FontWeight.bold
        ),
      ),

      actions: [
        if(widget.parametrs[0])
          GestureDetector(
            onTap: () async{
              if(widget.parametrs[1]){
                return showDialog(
                  context: context, 
                  builder: (context) => widget.addWidgets[widget.tabController.index],
                  barrierDismissible: false,
                );
              } else {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => widget.addWidgets[widget.tabController.index]
                  )
                );
              }
            },
            child: Container(
              color: Colors.white,
              height: 60.h,
              width: 40.w,
              alignment: Alignment.center,
              child: Icon(
                Icons.add,
                color: blue,
                size: 30.h,
              ),
            ),
          ),
          SizedBox(width: 2.5.w)
      ],

      bottom: TabBar(
        isScrollable: widget.parametrs[2],
        indicatorColor: blue,
        indicatorWeight: 2.5.h,
        controller: widget.tabController,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black45,
        labelStyle: TextStyle(
          fontSize: widget.parametrs[2]
            ? 14.h
            : 16.h,
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
    .select('profile_pic_url')
    .eq('email', email);

  final profilePicUrl = res[0]['profile_pic_url'];

  return await profilePicUrl;
}