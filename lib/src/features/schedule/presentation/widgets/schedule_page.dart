import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/constants/const.dart';
import 'package:rv1g_info/src/features/schedule/presentation/controllers/schedule_controller.dart';
import 'package:rv1g_info/src/features/schedule/presentation/widgets/crud_schedule_page.dart';

import '../../../../constants/theme_colors.dart';
import '../../../../core/app_bar_widget.dart';
import '../../domain/models/schedule.dart';

class SchedulePage extends ConsumerStatefulWidget {
  final bool isAdmin;
  final bool isVerified;

  const SchedulePage({
    required this.isAdmin,
    required this.isVerified,
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  String dropdownValue = 'Konsultāciju grafiks';

  String image = noSchedule;
  bool seeImage = false;

  Map<String, List<String>> forms = {};
  int length = 0;
  String key = "";
  String tag = "scheduleK";

  Map<String, Schedule> images = {};

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSchedule();
    });
    super.initState();
  }

  Widget buildImageZoom(BuildContext context, String url) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InteractiveViewer(
              child: Image.network(
                url,
                fit: BoxFit.fill,
              )
            )
          ],
        ),
      )
    );
  }

  Future<void> getSchedule() async {
    ref
      .read(scheduleControllerProvider.notifier)
      .getForms()
      .then((value) {
        setState(() {
          forms = value!;
        });
      });
      
    ref
      .read(scheduleControllerProvider.notifier)
      .getSchedule()
      .then((value) {
        setState(() {
          images = value!;
          image = value[tag]?.mediaUrl ?? noSchedule;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBarWidget(
          title: "Stundu saraksts", 
          add: widget.isAdmin, 
          navigateTo: CRUDScheduleWidget(tag: tag, imageUrl: image),
          showDialog: true,
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: !widget.isVerified
          ? RefreshIndicator(
              onRefresh: () {
                return getSchedule();
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 2.5.h, right: 5.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            DropdownButton<String>(
                              focusColor: Colors.black54,
                              borderRadius: BorderRadius.circular(20.w),
                              dropdownColor: navigationBarColor,
                              value: dropdownValue,
                              elevation: 20.h.toInt(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.h
                              ),
                              underline: Container(
                                height: 2.h,
                                color: blue,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                  if(forms.containsKey(dropdownValue[0])){
                                    length = forms[dropdownValue[0]]!.length;
                                    key = dropdownValue[0];
                                  } else if(forms.containsKey(dropdownValue.substring(0,2))){
                                    length = forms[dropdownValue.substring(0,2)]!.length;
                                    key = dropdownValue.substring(0,2);
                                  } else {
                                    seeImage = false;
                                    tag = "scheduleK";
                                    image = images["scheduleK"]?.mediaUrl ?? noSchedule;
                                  }
                                });
                              },
                              items: <String>['Konsultāciju grafiks', '7.klase', '8.klase', '9.klase', '10.klase', '11.klase', '12.klase']
                                  .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                            )
                          ],
                        )
                      ),

                      Row(
                        children: [
                          if(forms.containsKey(dropdownValue[0]) || forms.containsKey(dropdownValue.substring(0,2)))
                            for(int i=0;i<length;i++)
                              Padding(
                                padding: EdgeInsets.only(top: 10.h, left: 2.5.w, right: 2.5.w),
                                child: GestureDetector(
                                  onTap: (() {
                                    setState(() {
                                      seeImage = true;
                                      tag = 'schedule$key${forms[key]![i]}';
                                      image = images['schedule$key${forms[key]![i]}']?.mediaUrl ?? noSchedule;
                                    });
                                  }),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.w),
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black54,
                                          blurRadius: 1.5,
                                          offset: Offset(0, 1)
                                        ),
                                      ]
                                    ),
                                    width: 45.w,
                                    height: 45.w,
                                    alignment: Alignment.center,
                                    child: Text(
                                      forms[key]![i],
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16.5.h,
                                      ),
                                    )
                                  ),
                                ),
                              ),
                        ],
                      ),

                      if(dropdownValue == "Konsultāciju grafiks" || seeImage)
                        Padding(
                          padding: EdgeInsets.only(top: 10.h, bottom: 10.h, left: 5.w, right: 5.w),
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
                          ),
                        ),
                    ],
                  )
                )
              ),
            )
          : const Center(child: CircularProgressIndicator()),
      )
    );
  }
}