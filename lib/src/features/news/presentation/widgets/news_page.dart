import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/components/tab_app_bar_widget.dart';
import 'package:rv1g_info/src/features/news/presentation/widgets/eklase_page.dart';
import 'package:rv1g_info/src/features/news/presentation/widgets/school_page.dart';

import '../../domain/models/poll.dart';
import 'crud_eklase_news_page.dart';
import 'crud_school_news_page.dart';

class NewsPage extends ConsumerStatefulWidget {
  final bool isAdmin;

  const NewsPage({
    super.key,
    required this.isAdmin
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewsPageState();
}

class _NewsPageState extends ConsumerState<NewsPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.h),
        child: TabAppBarWidget(
          title: "Ziņas", 
          tabQuant: 2, 
          tabNames: const ["Skola","E-klase"],
          tabController: _tabController,
          add: widget.isAdmin,
          addWidgets: [
            CRUDSchoolNewsPage(
              edit: false,
              newsId: 0,
              text: "",
              pin: false, 
              poll: Poll(
                id: 0, 
                title: "", 
                allVotes: 0, 
                pollStart: DateTime.now().toIso8601String(), 
                pollEnd: DateTime.now().toIso8601String(), 
                newsId: 0, 
                answers: [], 
                hasVoted: false, 
                choosedAnswer: 0
              ),
              images: const []
            ),
            const CRUDEklaseNewsPage(
              edit: false,
              newsId: 0, 
              title: "", 
              author: "", 
              shortText: "", 
              text: "", 
              images: [], 
              pin: false
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: TabBarView(
        controller: _tabController,
        children: [
          SchoolPage(isAdmin: widget.isAdmin),
          EklasePage(isAdmin: widget.isAdmin),
        ],
      )
    );
  }
}