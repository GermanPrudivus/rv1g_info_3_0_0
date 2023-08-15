import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/components/drawer_widget.dart';
import 'package:rv1g_info/src/components/image_zoom_widget.dart';
import 'package:rv1g_info/src/components/tab_app_bar_widget.dart';
import 'package:rv1g_info/src/features/menu/presentation/controllers/menu_controller.dart';
import 'package:rv1g_info/src/features/menu/presentation/widgets/crud_menu_widget.dart';

import '../../../../constants/const.dart';
import '../../../../constants/theme_colors.dart';
import '../../domain/models/menu.dart';

class MenuPage extends ConsumerStatefulWidget {
  final bool isAdmin;
  final bool isVerified;

  const MenuPage({
    required this.isAdmin,
    required this.isVerified,
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> with TickerProviderStateMixin {
  late TabController _tabController;
  String profilePicUrl = "";
  String fullName = "";

  Map<String, Menu> images = {};
  String menu = noMenu;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
        .read(menuControllerProvider.notifier)
        .getUser()
        .then((value) {
          setState(() {
            profilePicUrl = value![0];
            fullName = value[1];
          });
        });
      getMenu();
    });
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getMenu() async {
    ref
      .read(menuControllerProvider.notifier)
      .getMenu()
      .then((value) {
        setState(() {
          images = value!;
          menu = images['menuP']?.mediaUrl ?? noMenu;
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
        preferredSize: Size.fromHeight(90.h),
        child: TabAppBarWidget(
          title: "Pusdienas",
          profilePicUrl: profilePicUrl,
          tabQuant: 3, 
          tabNames: const ["Pusdienu grafiks", "Ēdienkarte", "Ēdienkarte(bez glutēna)"],
          tabController: _tabController, 
          openDrawerCallback: openDrawerCallback,
          parametrs: [widget.isAdmin, true, true],//1.isAdmin, 2.showDialog, 3.isScrollable
          addWidgets: [
            CRUDMenuWidget(
              tag: const ['menuP'],
              imageUrl: [menu]
            ),
            CRUDMenuWidget(
              tag: const [
                'menu79',
                'menu1012'
              ],
              imageUrl: [
                images['menu79']?.mediaUrl ?? noMenu,
                images['menu1012']?.mediaUrl ?? noMenu
              ]
            ),
            CRUDMenuWidget(
              tag: const [
                'menu79bg',
                'menu1012bg'
              ],
              imageUrl: [
                images['menu79bg']?.mediaUrl ?? noMenu,
                images['menu1012bg']?.mediaUrl ?? noMenu
              ]
            ),
          ],
        ),
      ),
      drawer: DrawerWidget(
        profilePicUrl: profilePicUrl,
        fullName: fullName,
        isAdmin: widget.isAdmin,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            //first page
            RefreshIndicator(
              onRefresh: () async {
                return getMenu();
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: 15.h, bottom: 15.h, left: 10.w, right: 10.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.w),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 2.0,
                          offset: Offset(0, 1)
                        ),
                      ],
                    ),
                    child: InteractiveViewer(
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => buildImageZoom(context, menu),
                            barrierDismissible: true,
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.w),
                          child: Image.network(
                            menu,
                            fit: BoxFit.cover,
                            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                              if (frame != null) return child;
                                return Container(
                                  height: 500.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.w),
                                  ),
                                  child: CircularProgressIndicator(color: blue),
                                );
                            },
                            loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                                return Container(
                                  height: 500.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.w),
                                  ),
                                  child: CircularProgressIndicator(color: blue),
                                );
                            },
                          ),
                        )
                      )
                    ),
                  ),
                ),
              )
            ),

            //second page
            RefreshIndicator(
              onRefresh: () async {
                return getMenu();
              },
              child: SingleChildScrollView(
                child:Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, left: 20.w, bottom: 4.h),
                      child: Row(
                        children: [
                          Text(
                            '7.-9.klase',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.h
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.w),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 2.0,
                              offset: Offset(0, 1)
                            ),
                          ]
                        ),
                        width: 335.w,
                        child: InteractiveViewer(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => buildImageZoom(context, images['menu79']?.mediaUrl ?? noMenu),
                                barrierDismissible: true,
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.w),
                              child: Image.network(
                                images['menu79']?.mediaUrl ?? noMenu,
                                fit: BoxFit.cover,
                                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                  if (frame != null) return child;
                                    return Container(
                                      height: 500.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.w),
                                      ),
                                      child: CircularProgressIndicator(color: blue),
                                    );
                                },
                                loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                    return Container(
                                      height: 500.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.w),
                                      ),
                                      child: CircularProgressIndicator(color: blue),
                                    );
                                },
                              ),
                            )
                          )
                        )
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.h, left: 20.w, bottom: 4.h),
                      child: Row(
                        children: [
                          Text(
                            '10.-12.klase',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.h
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.w),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 2.0,
                              offset: Offset(0, 1)
                            ),
                          ]
                        ),
                        width: 335.w,
                        child: InteractiveViewer(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => buildImageZoom(context, images['menu1012']?.mediaUrl ?? noMenu),
                                barrierDismissible: true,
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.w),
                              child: Image.network(
                                images['menu1012']?.mediaUrl ?? noMenu,
                                fit: BoxFit.cover,
                                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                  if (frame != null) return child;
                                    return Container(
                                      height: 500.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.w),
                                      ),
                                      child: CircularProgressIndicator(color: blue),
                                    );
                                },
                                loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                    return Container(
                                      height: 500.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.w),
                                      ),
                                      child: CircularProgressIndicator(color: blue),
                                    );
                                },
                              ),
                            )
                          )
                        )
                      )
                    ),
                  ],
                ),
              )
            ),

            //third page
            RefreshIndicator(
              onRefresh: () async {
                return getMenu();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, left: 20.w, bottom: 4.h),
                      child: Row(
                        children: [
                          Text(
                            '7.-9.klase',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.h
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.w),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 2.0,
                              offset: Offset(0, 1)
                            ),
                          ]
                        ),
                        width: 335.w,
                        child: InteractiveViewer(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => buildImageZoom(context, images['menu79bg']?.mediaUrl ?? noMenu),
                                barrierDismissible: true,
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.w),
                              child: Image.network(
                                images['menu79bg']?.mediaUrl ?? noMenu,
                                fit: BoxFit.cover,
                                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                  if (frame != null) return child;
                                    return Container(
                                      height: 500.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.w),
                                      ),
                                      child: CircularProgressIndicator(color: blue),
                                    );
                                },
                                loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                    return Container(
                                      height: 500.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.w),
                                      ),
                                      child: CircularProgressIndicator(color: blue),
                                    );
                                },
                              ),
                            )
                          )
                        )
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.h, left: 20.w, bottom: 4.h),
                      child: Row(
                        children: [
                          Text(
                            '10.-12.klase',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.h
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.w),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 2.0,
                              offset: Offset(0, 1)
                            ),
                          ]
                        ),
                        width: 335.w,
                        child: InteractiveViewer(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => buildImageZoom(context, images['menu1012bg']?.mediaUrl ?? noMenu),
                                barrierDismissible: true,
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.w),
                              child: Image.network(
                                images['menu1012bg']?.mediaUrl ?? noMenu,
                                fit: BoxFit.cover,
                                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                  if (frame != null) return child;
                                    return Container(
                                      height: 500.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.w),
                                      ),
                                      child: CircularProgressIndicator(color: blue),
                                    );
                                },
                                loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                    return Container(
                                      height: 500.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.w),
                                      ),
                                      child: CircularProgressIndicator(color: blue),
                                    );
                                },
                              ),
                            )
                          )
                        )
                      )
                    ),
                  ],
                ),
              )
            )
          ]
        ),
      ),  
    );
  }
}