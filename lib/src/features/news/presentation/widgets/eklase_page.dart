import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rv1g_info/src/constants/const.dart';
import 'package:rv1g_info/src/features/news/presentation/widgets/one_eklase_news_page.dart';
import 'package:styled_text/styled_text.dart';

import '../../../../constants/theme_colors.dart';
import '../../domain/models/eklase_news.dart';
import '../controllers/eklase_controller.dart';

class EklasePage extends ConsumerStatefulWidget {
  final bool isAdmin;

  const EklasePage({
    super.key,
    required this.isAdmin
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EklasePageState();
}

class _EklasePageState extends ConsumerState<EklasePage> {

  List<EklaseNews> news = [];

  bool hasNoNews = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAnalytics.instance.logEvent(name: "eklase_page_opened");
      getNews();
    });
    super.initState();
  }

  Future<void> getNews() async{
    ref
      .read(eklaseControllerProvider.notifier)
      .getEklaseNews()
      .then((value) {
        setState(() {
          news = value!;
          if(news.isEmpty){
            hasNoNews = true;
          }
        });
      });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            news.isEmpty
              ? Expanded(
                  child: Center(
                    child: hasNoNews
                      ? Text(
                          "Nav e-klases ziņu",
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
                      return getNews();
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for(int index=0;index<news.length;index++)
                            Column(
                              children:[
                                Container(
                                  margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
                                  padding: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 5.w, left: 5.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.w),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: shadowBlue,
                                        blurRadius: 2.w,
                                        spreadRadius: news[index].pin ? 3.w : 1.w,
                                        offset: const Offset(0, 2)
                                      ),
                                    ]
                                  ),
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          news[index].title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 20.w
                                          ),
                                        ),
                                      ],
                                    ),
                                    minLeadingWidth: 57.w,
                                    leading: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.w),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10.w),
                                        child: Image.network(
                                          eklaseNewsImage,
                                          fit: BoxFit.fill,
                                          width: 60.w,
                                          height: 100.h,
                                        ),
                                      )
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(height: 4.h),
                                        StyledText(
                                          text: news[index].shortText,
                                          style: TextStyle(
                                            fontSize: 14.w,
                                            color: Colors.black54,
                                          ),
                                          textAlign: TextAlign.start,
                                          tags: {
                                            'b': StyledTextTag(style: const TextStyle(fontWeight: FontWeight.bold)),
                                            'u': StyledTextTag(style: const TextStyle(decoration: TextDecoration.underline)),
                                            'i': StyledTextTag(style: const TextStyle(fontStyle:FontStyle.italic))
                                          },
                                        ),
                                        SizedBox(height: 6.h),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  news[index].author,
                                                  style: TextStyle(
                                                    fontSize: 13.w,
                                                  ),
                                                ),
                                                Text(
                                                  DateFormat('dd.MM.yyyy.', 'en_US')
                                                    .format(
                                                      DateTime.parse(news[index].createdDateTime)
                                                    ),
                                                  style: TextStyle(
                                                    fontSize: 13.w,
                                                  ),
                                                )
                                              ]
                                            ),
                                          ],
                                        ),
                                      ]
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) {
                                            return OneEklaseNewsPage(
                                              isAdmin: widget.isAdmin,
                                              news: news[index],
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
                                      ).whenComplete(() => getNews());
                                    },
                                    isThreeLine: true,
                                  )
                                ),
                                if(news[index].pin == true)
                                  Divider(
                                    color: blue,
                                    endIndent: 20.w,
                                    indent: 20.w,
                                    height: 15.h,
                                    thickness: 2.5.h,
                                  ),
                              ]
                            )
                          ],
                        )
                    )
                  )
                )
          ]
        ),
      ),
    );
  }
}