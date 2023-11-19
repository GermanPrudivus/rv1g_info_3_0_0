import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/features/news/presentation/controllers/school_controller.dart';
import 'package:rv1g_info/src/features/news/presentation/widgets/crud_school_news_page.dart';
import 'package:styled_text/styled_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/theme_colors.dart';
import '../../domain/models/school_news.dart';

class SchoolPage extends ConsumerStatefulWidget {
  final bool isAdmin;

  const SchoolPage({
    Key? key,
    required this.isAdmin
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SchoolPageState();
}

class _SchoolPageState extends ConsumerState<SchoolPage> {

  int userId = 0;
  List<SchoolNews> news = [];

  bool hasNoNews = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAnalytics.instance.logEvent(name: "school_page_opened");
      ref
        .read(schoolControllerProvider.notifier)
        .getUserId()
        .then((value) {
          setState(() {
            userId = value!;
          });
        });
      getNews();
    });
    super.initState();
  }

  Future<void> getNews() async{
    ref
      .read(schoolControllerProvider.notifier)
      .getSchoolNews()
      .then((value) {
        setState(() {
          news = value!;
          if(news.isEmpty){
            hasNoNews = true;
          }
        });
      });
  }

  String differenceInDates(DateTime later, DateTime earlier) {
    later = DateTime.utc(later.year, later.month, later.day, later.hour, later.minute);
    earlier = DateTime.utc(earlier.year, earlier.month, earlier.day, earlier.hour, earlier.minute);

    if(later.difference(earlier).inDays > 0){
      return "${later.difference(earlier).inDays}d";
    } else if (later.difference(earlier).inDays == 0 && later.difference(earlier).inHours > 0){
      return "${later.difference(earlier).inHours}h";
    } else if (later.difference(earlier).inHours == 0 && later.difference(earlier).inMinutes > 0){
      return "${later.difference(earlier).inMinutes}m";
    } else {
      return "${later.difference(earlier).inSeconds}s";
    }
  }

  String formatedText(List<String> text) {
    String formatedText = "";
    for(int i=0;i<text.length-1;i++){
      if(json.decode(text[i])['text']==""){
        formatedText = "$formatedText\n\n";
      } else if(json.decode(text[i])['text']!="" && json.decode(text[i+1])['text']!=""){
        formatedText = '${formatedText + json.decode(text[i])['text']}\n';
      } else {
        formatedText = formatedText + json.decode(text[i])['text'];
      }
    }

    if(text.isNotEmpty) {
      formatedText = formatedText+json.decode(text[text.length-1])['text'];
    }

    return formatedText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children:[
            news.isEmpty
              ? Expanded(
                  child: Center(
                    child: hasNoNews
                      ? Text(
                          "Nav skolas ziņu",
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
                        Container(
                          padding: EdgeInsets.only(top: 10.h, left: 7.5.w, right: 15.w, bottom: 10.h),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: news[index].pin
                                  ? blue
                                  : Colors.grey,
                                width: news[index].pin
                                  ? 2.5.h
                                  : 0.5.h,
                              )
                            )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //avatar and like button
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  news[index].authorAvatar == ""
                                    ? CircleAvatar(
                                      radius: 20.h,
                                      backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 30.h,
                                      )
                                    )
                                    : CircleAvatar(
                                        radius: 20.h,
                                        backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                                        backgroundImage: NetworkImage(news[index].authorAvatar),
                                    ),
                                ],
                              ),
    
                              SizedBox(width: 7.5.w),
      
                              //text
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  news[index].authorName,
                                                  style: TextStyle(
                                                    fontSize: 15.w,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 7.5.w),
                                              ClipOval(
                                                child: Container(
                                                  color: Colors.grey,
                                                  height: 3.w,
                                                  width: 3.w,
                                                ),
                                              ),
                                              SizedBox(width: 7.5.w),
                                              Text(
                                                differenceInDates(
                                                  DateTime.now(), 
                                                  DateTime.parse(news[index].createdDateTime)
                                                ),
                                                style: TextStyle(
                                                  fontSize: 15.w,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if(widget.isAdmin)
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return CRUDSchoolNewsPage(
                                                      edit: true,
                                                      newsId: news[index].id,
                                                      text: formatedText(news[index].text),
                                                      pin: news[index].pin,
                                                      poll: news[index].poll,
                                                      images: news[index].media,
                                                    );
                                                  }
                                                )
                                              ).whenComplete(() {
                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                  getNews();
                                                });
                                              });
                                            },
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.grey,
                                              size: 20.h,
                                            ),
                                          )
                                      ],
                                    ),

                                    //main text
                                    for(int i=0;i<news[index].text.length;i++)
                                      StyledText(
                                        text: json.decode(news[index].text[i])['text'],
                                        style: TextStyle(
                                          fontSize: 15.w,
                                          height: 1.w,
                                        ),
                                        textAlign: TextAlign.start,
                                        tags: {
                                          'b': StyledTextTag(style: const TextStyle(fontWeight: FontWeight.bold)),
                                          'u': StyledTextTag(style: const TextStyle(decoration: TextDecoration.underline)),
                                          'i': StyledTextTag(style: const TextStyle(fontStyle: FontStyle.italic)),
                                          'link': StyledTextActionTag(
                                            (_, attrs) async {
                                              await launchUrl(Uri.parse(attrs['href']!));
                                            },
                                            style: const TextStyle(color: Colors.lightBlue),
                                          ),
                                        },
                                      ),
      
                                    if(news[index].poll.id != 0 && news[index].text.isNotEmpty)
                                      SizedBox(height: 15.h),

                                    //poll
                                    if(news[index].poll.id != 0)
                                      FlutterPolls(
                                        onVoted: (PollOption pollOption, _) async {
                                          ref
                                            .read(schoolControllerProvider.notifier)
                                            .updateVotes(news[index].poll.id, toInt(pollOption.id)!, userId)
                                            .whenComplete(() {
                                              setState(() {
                                                getNews();
                                              });
                                            });
                                          return true;
                                        }, 
                                        pollId: news[index].poll.id.toString(),
                                        pollTitle: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            news[index].poll.title,
                                            style: TextStyle(
                                              fontSize: 15.w,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        pollEnded: differenceInDates(
                                          DateTime.parse(news[index].poll.pollEnd), 
                                          DateTime.now()
                                        )[0] == "-",
                                        hasVoted: news[index].poll.hasVoted,
                                        userVotedOptionId: news[index].poll.choosedAnswer.toString(),
                                        pollOptions: [
                                          for(int i=0;i<news[index].poll.answers.length;i++)
                                            PollOption(
                                              id: news[index].poll.answers[i].id.toString(),
                                              title: Padding(
                                                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    news[index].poll.answers[i].answer,
                                                    style: TextStyle(
                                                      fontSize: 14.w
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              votes: news[index].poll.answers[i].votes
                                            )
                                        ],
                                        voteInProgressColor: Colors.white,
                                        votedProgressColor:  transparentLightGrey,
                                        votedBackgroundColor: Colors.white,
                                        leadingVotedProgessColor: transparentLightGrey,
                                        votedPercentageTextStyle: TextStyle(
                                          fontSize: 14.w,
                                          color: Colors.black
                                        ),
                                        votesText: "nobalsoja",
                                        votesTextStyle: TextStyle(
                                          fontSize: 13.w,
                                          fontWeight: FontWeight.bold
                                        ),
                                        metaWidget: Row(
                                          children: [
                                            SizedBox(width: 7.5.w),
                                            ClipOval(
                                              child: Container(
                                                color: Colors.black,
                                                height: 2.5.w,
                                                width: 2.5.w,
                                              ),
                                            ),
                                            SizedBox(width: 7.5.w),
                                            Text(
                                              differenceInDates(DateTime.parse(news[index].poll.pollEnd), DateTime.now())[0] != "-"
                                                ? "${differenceInDates(DateTime.parse(news[index].poll.pollEnd), DateTime.now())} palika nobalsot"
                                                : "balsošana beidzās",
                                              style: TextStyle(
                                                fontSize: 13.w,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ]
                                        )
                                      ),
                                    
                                    //images
                                    for(int i=0;i<news[index].media.length;i++)
                                      Container(
                                        padding: EdgeInsets.only(top: 5.h),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.h)
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10.h),
                                          child: Image.network(
                                            json.decode(news[index].media[i])['image_url'],
                                            fit: BoxFit.cover
                                          ),
                                        ),
                                      ),
                                  ]
                                )
                              )
                            ],
                          )
                        ),
                      ]
                    )
                    )
                  ),
                )
          ]
        )
      ),
    );
  }
}