import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rv1g_info/src/components/difference_in_dates.dart';
import 'package:rv1g_info/src/components/drawer_app_bar_widget.dart';
import 'package:rv1g_info/src/features/volunteering/presentation/widgets/volunteering_job_page.dart';

import '../../../../constants/theme_colors.dart';
import '../../domain/models/job.dart';
import '../controllers/volunteering_controller.dart';
import 'crud_volunteering_job_page.dart';

class VolunteeringJobsPage extends ConsumerStatefulWidget {
  final bool isAdmin;

  const VolunteeringJobsPage({
    required this.isAdmin,
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VolunteeringJobsPageState();
}

class _VolunteeringJobsPageState extends ConsumerState<VolunteeringJobsPage> {
  List<Job> jobs = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getJobs();
    });
    super.initState();
  }

  Future<void> getJobs() async{
    ref
      .read(volunteeringControllerProvider.notifier)
      .getEvents()
      .then((value) {
        setState(() {
          jobs = value!;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: DrawerAppBarWidget(
          title: "Brīvprātīgie", 
          add: widget.isAdmin, 
          navigateTo: CRUDVolunteeringPage(
            edit: false, 
            jobId: 0, 
            title: "", 
            description: "", 
            images: [],
            startDate: DateTime.now(), 
            endDate: DateTime.now(), 
          ), 
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            jobs.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      "Nav brīvprātīgo darbu",
                      style: TextStyle(
                        fontSize: 16.w,
                        color: blue
                      ),
                    ),
                  ),
                )
              : Expanded(
                child: RefreshIndicator(
                  onRefresh: () {
                    return getJobs();
                  },
                  child: ListView.builder(
                   itemCount: jobs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      bool enabled = true;

                      if(differenceInDates(DateTime.parse(jobs[index].endDate), DateTime.now())[0] == "-"){
                        enabled = false;
                      }

                      return GestureDetector(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
                              padding: EdgeInsets.only(top: 15.h, bottom: 15.h, right: 15.w, left: 15.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.w),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: enabled
                                      ? shadowBlue
                                      : Colors.black26,
                                    blurRadius: 2.w,
                                    spreadRadius: enabled
                                      ? 1.w
                                      : 0.5.w,
                                    offset: const Offset(0, 2)
                                  ),
                                ]
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    jobs[index].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: enabled
                                        ? Colors.black
                                        : Colors.black45,
                                      fontSize: 18.w
                                    ),
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
                                            DateFormat('dd.MM.yyyy.', 'en_US')
                                              .format(
                                                DateTime.parse(jobs[index].startDate)
                                              ),
                                            style: TextStyle(
                                              fontSize: 15.w,
                                              color: enabled
                                                ? Colors.black
                                                : Colors.black45
                                            ),
                                          )
                                        ]
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          if(enabled){
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) {
                                  return VolunteeringJobPage(
                                    isAdmin: widget.isAdmin,
                                    job: jobs[index],
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
                            ).whenComplete(() => getJobs());
                          }
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