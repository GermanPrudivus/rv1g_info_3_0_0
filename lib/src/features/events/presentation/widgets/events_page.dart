import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rv1g_info/src/components/drawer_app_bar_widget.dart';
import 'package:rv1g_info/src/features/events/presentation/widgets/crud_event_page.dart';
import 'package:styled_text/styled_text.dart';

import '../../../../constants/const.dart';
import '../../../../constants/theme_colors.dart';
import '../../doamain/models/event.dart';
import '../controllers/events_controller.dart';
import 'event_page.dart';

class EventsPage extends ConsumerStatefulWidget {
  final bool isAdmin;

  const EventsPage({
    required this.isAdmin,
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {

  List<Event> events = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getEvents();
    });
    super.initState();
  }

  Future<void> getEvents() async{
    ref
      .read(eventsControllerProvider.notifier)
      .getEvents()
      .then((value) {
        setState(() {
          events = value!;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: DrawerAppBarWidget(
          title: "Pasākumi", 
          add: widget.isAdmin, 
          navigateTo: CRUDEventPage(
            edit: false, 
            eventId: 0, 
            title: "", 
            shortText: "", 
            startDate: DateTime.now(), 
            endDate: DateTime.now(), 
            description: "", 
            images: []
          ), 
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            events.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      "Nav pasākumu",
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
                    return getEvents();
                  },
                  child: ListView.builder(
                   itemCount: events.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
                            padding: EdgeInsets.only(top: 15.h, bottom: 15.h, right: 5.w, left: 5.w),
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
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    events[index].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18.h
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
                                    text: events[index].shortText,
                                    style: TextStyle(
                                      fontSize: 13.h,
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
                                            DateFormat('dd.MM.yyyy.', 'en_US')
                                              .format(
                                                DateTime.parse(events[index].startDate)
                                              ),
                                            style: TextStyle(
                                              fontSize: 12.h,
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
                                      return EventPage(
                                        isAdmin: widget.isAdmin,
                                        event: events[index],
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
                                );
                              },
                              isThreeLine: true,
                            )
                          ),
                        ],
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