import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/constants/const.dart';
import 'package:rv1g_info/src/components/app_bar_widget.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../components/drawer_widget.dart';
import '../../../../components/image_zoom_widget.dart';
import '../../../../constants/theme.dart';
import '../../domain/models/changes.dart';
import '../controllers/changes_controller.dart';
import 'crud_changes_widget.dart';

class ChangesPage extends ConsumerStatefulWidget {
  final String profilePicUrl;
  final String fullName;
  final bool isAdmin;
  final List<String> events;
  final List<String> controllers;

  const ChangesPage({
    required this.profilePicUrl,
    required this.fullName,
    required this.isAdmin,
    required this.events,
    required this.controllers,
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChangesPageState();
}

class _ChangesPageState extends ConsumerState<ChangesPage> {
  CalendarFormat format = CalendarFormat.week;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  String selectedStr = '${DateTime.now()}'.split(' ')[0];
  String vardaDiena = '';

  Map<String, Changes> changes = {};
  String image = noChanges;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAnalytics.instance.logEvent(name: "changes_page_opened");
      getChanges();
    });
    super.initState();
  }

  Future<void> getChanges() async{
    ref
      .read(changesControllerProvider.notifier)
      .getChanges()
      .then((value) {
        setState(() {
          changes = value!;
          setChanges();
        });
      });
  }

  void setChanges() {
    vardaDiena = "";
    if(changes.containsKey('changes$selectedStr')){
      image = changes['changes$selectedStr']!.mediaUrl;
      for(int i=0;i<changes['changes$selectedStr']!.nameDay.length;i++){
        if(i==0){
          vardaDiena = '$vardaDiena${changes['changes$selectedStr']!.nameDay[i]}';
        } else if(i==changes['changes$selectedStr']!.nameDay.length-1){
          vardaDiena = '$vardaDiena un ${changes['changes$selectedStr']!.nameDay[i]}';
        } else {
          vardaDiena = '$vardaDiena, ${changes['changes$selectedStr']!.nameDay[i]}';
        }
      }
    } else {
      image = noChanges;
      String key = selectedStr.substring(selectedStr.length-5, selectedStr.length);
      for(int i=0;i<nameDays[key]!.length;i++){
        if(i==0){
          vardaDiena = '$vardaDiena${nameDays[key]![i]}';
        } else if(i==nameDays[key]!.length-1){
          vardaDiena = '$vardaDiena un ${nameDays[key]![i]}';
        } else {
          vardaDiena = '$vardaDiena, ${nameDays[key]![i]}';
        }
      }
    }
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
          title: "Izmaiņas", 
          profilePicUrl: widget.profilePicUrl,
          add: widget.isAdmin, 
          navigateTo: CRUDChangesWidget(
            tag: "changes$selectedStr",
            imageUrl: image,
          ),
          showDialog: true,
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
        child: RefreshIndicator(
          onRefresh: () {
            return getChanges();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                TableCalendar(
                  focusedDay: selectedDay,
                  firstDay: DateTime(DateTime.now().year-1, 12, 31),
                  lastDay: DateTime(DateTime.now().year+1, 12, 31),
                  calendarFormat: format,
                  startingDayOfWeek: StartingDayOfWeek.monday,

                  //Day Changed
                  onDaySelected: (DateTime selectDay, DateTime focusDay){
                    setState(() {
                      selectedDay = selectDay;
                      focusedDay = focusDay;
                      selectedStr = '$selectedDay'.split(' ')[0];
                      setChanges();
                    });
                  },
                  selectedDayPredicate: (DateTime date){
                    return isSameDay(selectedDay, date);
                  },

                  //Style
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 12.h,
                    ),
                    weekendStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 12.h,
                    )
                  ),

                  calendarStyle: CalendarStyle(
                    isTodayHighlighted: true,
                    cellMargin: EdgeInsets.all(5.w),
                    selectedDecoration: BoxDecoration(
                      color: blue,
                      shape: BoxShape.circle
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 13.5.h,
                    ),
                    defaultTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 13.5.h,
                    ),
                    todayTextStyle: TextStyle(
                      fontSize: 13.5.h,
                      color: Colors.white
                    ),
                    weekendTextStyle: TextStyle(
                      color: Colors.black54,
                      fontSize: 13.5.h,
                    ),
                    disabledTextStyle: TextStyle(
                      color: Colors.black12,
                      fontSize: 13.5.h,
                    ),
                    todayDecoration: const BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    )
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: blue,
                      size: 20.h,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: blue,
                      size: 20.h,
                    ),
                    titleCentered: true,
                      titleTextStyle: TextStyle(
                        fontSize: 15.h,
                      )
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 5.h, left: 10.w, right: 10.w),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(15.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.w),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 2.0,
                          offset: Offset(0, 1)
                        ),
                      ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Šodien vārda dienu svin:',
                          style: TextStyle(
                            fontSize: 17.w,
                            height: 1.w,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          vardaDiena,
                          style: TextStyle(
                            fontSize: 18.w,
                            height: 1.w,
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  )
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w, bottom: 10.h),
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
                            builder: (context) => buildImageZoom(context, image),
                            barrierDismissible: true,
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.w),
                          child: Image.network(
                            image,
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
                  )                 
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}