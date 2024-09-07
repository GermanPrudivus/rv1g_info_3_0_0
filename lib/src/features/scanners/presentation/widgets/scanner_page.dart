import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/features/scanners/presentation/widgets/scan_ticket_page.dart';

import '../../../../constants/theme.dart';
import '../../domain/models/participant.dart';
import '../../domain/models/scanner.dart';
import '../controllers/scanner_page.dart';

class ScannerPage extends ConsumerStatefulWidget {
  final Scanner scanner;
  
  const ScannerPage({
    required this.scanner,
    super.key
  });

  @override
  ConsumerState<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends ConsumerState<ScannerPage> {
  List<Participant> participants = [];

  @override
  void initState() {
    participants = widget.scanner.participants;
    super.initState();
  }

  Future<void> getParticipants() async{
    ref
      .read(scannerControllerProvider.notifier)
      .getParticipants(widget.scanner.id)
      .then((value) {
        setState(() {
          participants = value!;
        });
      });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 0.01,
          icon: Icon(
            Icons.chevron_left,
            color: blue, 
            size: 34.h,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        backgroundColor: Colors.white,
        shadowColor: appBarShadow,

        toolbarHeight: 60.h,

        centerTitle: true,
        title: Text(
          "Dalībnieku saraksts",
          style: TextStyle(
            fontSize: 20.w,
            color: blue,
            fontWeight: FontWeight.bold
          ),
        ),

        actions: [
          GestureDetector(
            onTap: () async{
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => ScanTicketPage(scanner: widget.scanner)
                )
              ).whenComplete(() {
                setState(() {
                  getParticipants();
                });
              });
            },
            child: Container(
              color: Colors.transparent,
              height: 60.h,
              width: 50.w,
              alignment: Alignment.center,
              child: Icon(
                Icons.qr_code_scanner,
                color: blue,
                size: 28.h,
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            participants.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      "Nav dalībnieku",
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
                    return getParticipants();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for(int index=0;index<participants.length;index++)
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 15.h, bottom: 15.h, right: 25.w, left: 25.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: BorderSide(
                                      color:Colors.grey,
                                      width: 1.h,
                                    )
                                  )
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          participants[index].fullName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 17.w,
                                            height: 1.w,
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
                                                  participants[index].active
                                                    ? 'Aktīvs dalībnieks'
                                                    : 'Neaktīvs dalībnieks',
                                                  style: TextStyle(
                                                    fontSize: 13.h,
                                                    color: participants[index].active
                                                      ? Colors.green
                                                      : Colors.red,
                                                    height: 1.w,
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
                                        Text(
                                          participants[index].form,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16.w,
                                            height: 1.w,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                      ]
                    )
                  ),
                ),
              )
          ],
        )
      ),
    );
  }
}