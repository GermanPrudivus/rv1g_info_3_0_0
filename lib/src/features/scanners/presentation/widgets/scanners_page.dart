import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/components/drawer_app_bar_widget.dart';
import 'package:rv1g_info/src/features/scanners/presentation/controllers/scanners_controller.dart';
import 'package:rv1g_info/src/features/scanners/presentation/widgets/scanner_page.dart';

import '../../../../constants/theme_colors.dart';
import '../../domain/models/scanner.dart';

class ScannersPage extends ConsumerStatefulWidget {
  final bool isAdmin;
  final List<String> controllers;

  const ScannersPage({
    required this.isAdmin,
    required this.controllers,
    super.key
  });

  @override
  ConsumerState<ScannersPage> createState() => _ScannersPageState();
}

class _ScannersPageState extends ConsumerState<ScannersPage> {
  List<Scanner> scanners = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getScanners();
    });
    super.initState();
  }

  Future<void> getScanners() async{
    ref
      .read(scannersControllerProvider.notifier)
      .getScanners()
      .then((value) {
        setState(() {
          scanners = value!;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: DrawerAppBarWidget(
          title: "Skeneri", 
          add: false, 
          navigateTo: Placeholder(), 
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            scanners.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      "Nav skeneru",
                      style: TextStyle(
                        fontSize: 16.h,
                        color: blue
                      ),
                    ),
                  ),
                )
              : Expanded(
                child: RefreshIndicator(
                  onRefresh: () {
                    return getScanners();
                  },
                  child: ListView.builder(
                   itemCount: scanners.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
                              padding: EdgeInsets.only(top: 15.h, bottom: 15.h, right: 20.w, left: 20.w),
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        scanners[index].title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 18.h
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Dalībnieku skaits: ${scanners[index].participantQuant}',
                                                style: TextStyle(
                                                  fontSize: 14.h,
                                                ),
                                              )
                                            ]
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  Column(
                                    children: [
                                      Icon(
                                        Icons.chevron_right,
                                        size: 30.h,
                                        color: blue,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return ScannerPage(
                                  scanner: scanners[index]
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
                          ).whenComplete(() => getScanners());
                        },
                      );
                    }
                  ),
                ),
              )
          ],
        )
      ),
    );
  }
}