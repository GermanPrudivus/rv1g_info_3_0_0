import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/constants/theme.dart';

// ignore: must_be_immutable
class TabAppBarWidget extends StatefulWidget {
  final String title;
  final String profilePicUrl;
  final int tabQuant;
  final List<String> tabNames;
  final List<bool> parametrs;//1.isAdmin, 2.showDialog, 3.isScrollable
  final List<Widget> addWidgets;
  late TabController tabController;
  final Function(BuildContext) openDrawerCallback;

  TabAppBarWidget({
    super.key, 
    required this.title,
    required this.profilePicUrl,
    required this.tabQuant,
    required this.tabNames,
    required this.parametrs,
    required this.addWidgets,
    required this.tabController,
    required this.openDrawerCallback
  });

  @override
  State<TabAppBarWidget> createState() => _TabAppBarWidgetState();
}

class _TabAppBarWidgetState extends State<TabAppBarWidget> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,

      shadowColor: appBarShadow,
      scrolledUnderElevation: 0,
      elevation: 3,

      toolbarHeight: 60.h,

      leading: GestureDetector(
        onTap: () => widget.openDrawerCallback(context),
        child: Container(
          height: 60.h,
          color: Colors.white,
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
                size: 30.w,
              ),
            ),
          ),
          SizedBox(width: 2.5.w)
      ],

      bottom: TabBar(
        isScrollable: widget.parametrs[2],
        indicatorColor: blue,
        indicatorWeight: 2.5.h,
        indicatorSize: TabBarIndicatorSize.tab,
        controller: widget.tabController,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black45,
        tabAlignment: widget.parametrs[2] ? TabAlignment.center : TabAlignment.fill,
        labelStyle: TextStyle(
          fontSize: widget.parametrs[2]
            ? 15.w
            : 17.w,
        ),
        tabs: <Widget>[
          for(int i=0;i<widget.tabQuant;i++)
            SizedBox(
              height: 30.h,
              child: Tab(text: widget.tabNames[i]),
            )
        ],
      ),
    );
  }
}