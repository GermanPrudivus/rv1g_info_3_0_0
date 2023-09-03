import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rv1g_info/src/features/tickets/presentation/controllers/tickets_controller.dart';
import 'package:rv1g_info/src/features/tickets/presentation/widgets/ticket_qr_code_widget.dart';

import '../../../../components/difference_in_dates.dart';
import '../../../../components/drawer_app_bar_widget.dart';
import '../../../../constants/theme_colors.dart';
import '../../domain/models/ticket.dart';

class TicketsPage extends ConsumerStatefulWidget {
  const TicketsPage({super.key});

  @override
  ConsumerState<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends ConsumerState<TicketsPage> {

  List<Ticket> tickets = [
    Ticket(
      id: 1, 
      userId: 3, 
      title: "Zaļumballe", 
      eventId: 2, 
      key: 12232040248249, 
      endDateTime: DateTime(2023, 9, 14).toIso8601String(), 
      createdDateTime: DateTime.now().toIso8601String()
    )
  ];
  
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTickets();
    });
    super.initState();
  }

  Future<void> getTickets() async {
    ref
      .read(ticketsControllerProvider.notifier)
      .getTickets()
      .then((value) {
        setState(() {
          tickets = tickets + value!;
        });
      });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: DrawerAppBarWidget(
          title: "Biļetes", 
          add: false, 
          navigateTo: Placeholder(), 
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            tickets.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      "Nav biļetes",
                      style: TextStyle(
                        color: blue,
                        fontSize: 16.h
                      ),
                    )
                  ),
                )
              : Expanded(
                child: RefreshIndicator(
                  onRefresh: () {
                    return getTickets();
                  },
                  child: ListView.builder(
                   itemCount: tickets.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      bool enabled = true;

                      if(differenceInDates(DateTime.parse(tickets[index].endDateTime), DateTime.now())[0] == "-"){
                        enabled = false;
                      }
                      
                      return GestureDetector(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 7.5.w, right: 7.5.w, top: 10.h, bottom: 10.h),
                              padding: EdgeInsets.only(top: 15.h, bottom: 15.h, right: 12.5.w, left: 12.5.w),
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
                                        tickets[index].title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 18.h
                                        ),
                                      ),
                                      SizedBox(height: 7.5.h),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Biļete derīga:',
                                                style: TextStyle(
                                                  fontSize: 14.h,
                                                  fontWeight: FontWeight.w500
                                                ),
                                              ),
                                              SizedBox(height: 2.5.h,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "No:",
                                                        style: TextStyle(
                                                          fontSize: 12.h,
                                                       ),
                                                      ),
                                                      SizedBox(height: 5.h,),
                                                      Text(
                                                        DateFormat('dd.MM.yyyy. HH:mm', 'en_US')
                                                          .format(
                                                            DateTime.parse(tickets[index].createdDateTime)
                                                         ),
                                                        style: TextStyle(
                                                          fontSize: 14.5.w,
                                                          fontWeight: FontWeight.bold
                                                       ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Līdz:",
                                                        style: TextStyle(
                                                          fontSize: 12.h,
                                                       ),
                                                      ),
                                                      SizedBox(height: 5.h,),
                                                      Text(
                                                        DateFormat('dd.MM.yyyy. HH:mm', 'en_US')
                                                          .format(
                                                            DateTime.parse(tickets[index].endDateTime)
                                                         ),
                                                        style: TextStyle(
                                                          fontSize: 14.5.w,
                                                          fontWeight: FontWeight.bold
                                                       ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ]
                                          ),
                                        ],
                                      )
                                    ],
                                  ),

                                  Column(
                                    children: [
                                      Icon(
                                        Icons.chevron_right,
                                        size: 26.h,
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
                          Ticket ticket = tickets[index];
                          String data = "";

                          data = ticket.id.toString() +" "
                                + ticket.userId.toString() +" "
                                + ticket.eventId.toString() +" "
                                + ticket.title +" "
                                + ticket.key.toString() +" "
                                + ticket.endDateTime;

                          print(data);
                            
                          if(enabled){
                            showDialog(
                              context: context, 
                              builder: (context) => TicketQRCodeWidget(data: data),
                              barrierDismissible: true,
                            );
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