import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/components/app_bar_widget.dart';
import 'package:rv1g_info/src/features/shop/presentation/controllers/shop_controller.dart';
import 'package:rv1g_info/src/features/shop/presentation/widgets/crud_shop_page.dart';
import 'package:styled_text/styled_text.dart';

import '../../../../components/drawer_widget.dart';
import '../../../../constants/theme_colors.dart';
import '../../domain/models/item.dart';
import 'item_page.dart';

class ShopPage extends ConsumerStatefulWidget {
  final String profilePicUrl;
  final String fullName;
  final String email;
  final bool isAdmin;
  final List<String> events;
  final List<String> controllers;

  const ShopPage({
    required this.profilePicUrl,
    required this.fullName,
    required this.email,
    required this.isAdmin,
    required this.events,
    required this.controllers,
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage> {
  List<Item> items = [];

  bool hasNoItems = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAnalytics.instance.logEvent(name: "shop_page_opened");
      getItems();
    });
    super.initState();
  }

  Future<void> getItems() async {
    ref
      .read(shopControllerProvider.notifier)
      .getItems()
      .then((value) {
        setState(() {
          items = value!;
          if(items.isEmpty){
            hasNoItems = true;
          }
        });
      });
  }

  void openDrawerCallback(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBarWidget(
          title: "Veikals", 
          profilePicUrl: widget.profilePicUrl,
          add: widget.isAdmin && (widget.email == "german.prudivus1008@gmail.com" || widget.email == "rv1g.info@gmail.com"), 
          navigateTo: CRUDShopPage(
            edit: false, 
            itemId: 0, 
            title: "", 
            shortText: "", 
            price: "", 
            description: "", 
            images: []
          ),
          showDialog: false,
          openDrawerCallback: openDrawerCallback,
        ),
      ),
      drawer: DrawerWidget(
        profilePicUrl: widget.profilePicUrl,
        fullName: widget.fullName,
        events: widget.events,
        controllers: widget.controllers,
        isAdmin: widget.isAdmin,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            items.isEmpty
              ? Expanded(
                  child: Center(
                    child: hasNoItems
                      ? Text(
                          "Nav piedāvājumu",
                          style: TextStyle(
                            fontSize: 16.w,
                            color: blue
                          ),
                        )
                      : CircularProgressIndicator(color: blue),
                  ),
                )
              : Expanded(
                  child: RefreshIndicator(
                    onRefresh: () {
                      return getItems();
                    },
                    child: ListView.builder(
                      itemCount: items.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap:() {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) {
                                  return ItemPage(
                                    isAdmin: widget.isAdmin,
                                    item: items[index],
                                  );
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
                            ).whenComplete(() => getItems());
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
                            padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 15.h, bottom: 15.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.w),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: shadowBlue,
                                  blurRadius: 2.w,
                                  spreadRadius: 1.w,
                                  offset: const Offset(0, 2)
                                ),
                              ]
                            ),
                            child:  Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.w),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10.w),
                                          child: items[index].media.isEmpty
                                            ? Container(
                                                height: 100.h,
                                                color: Colors.grey,
                                              )
                                            : Image.network(
                                                json.decode(items[index].media[0])['image_url'],
                                                fit: BoxFit.fill,
                                              ),
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10.w),

                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        items[index].title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 18.w
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      StyledText(
                                        text: items[index].shortText,
                                        style: TextStyle(
                                          fontSize: 14.w,
                                         color: Colors.black
                                        ),
                                        tags: {
                                          'b': StyledTextTag(style: const TextStyle(fontWeight: FontWeight.bold)),
                                          'u': StyledTextTag(style: const TextStyle(decoration: TextDecoration.underline)),
                                          'i': StyledTextTag(style: const TextStyle(fontStyle:FontStyle.italic))
                                        },
                                      ),
                                      SizedBox(height: 10.h),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                items[index].price,
                                                style: TextStyle(
                                                  fontSize: 15.w,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black
                                                ),
                                              ),
                                            ]
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ]
                            )
                          )
                        );
                      }
                    ),
                  ),
                )
          ],
        ),
      )
    );
  }
}