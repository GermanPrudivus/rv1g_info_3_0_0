import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/core/tab_app_bar_widget.dart';
import 'package:rv1g_info/src/features/news/presentation/widgets/eklase_page.dart';
import 'package:rv1g_info/src/features/news/presentation/widgets/school_page.dart';

class NewsPage extends ConsumerStatefulWidget {
  const NewsPage({super.key});

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
          add: false,
          navigateTo: const AboutDialog(),
        ),
      ),
      backgroundColor: Colors.white,
      body: TabBarView(
        controller: _tabController,
        children: const [
          SchoolPage(),
          EklasePage(),
        ],
      )
    );
  }
}