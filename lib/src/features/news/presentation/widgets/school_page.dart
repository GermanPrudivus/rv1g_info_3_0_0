import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/features/news/presentation/controllers/school_controller.dart';
import 'package:rv1g_info/src/features/news/presentation/widgets/crud_school_news_page.dart';
import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/theme_colors.dart';
import '../../domain/models/answer.dart';
import '../../domain/models/poll.dart';
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
  
  List<int> newsId = [];
  Map<int, Poll> polls = {};

  List<int> pollsId = [];
  List<Answer> answers = [];

  List<bool> likePressed = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
          newsId.clear();
          for(int i=0;i<news.length;i++){
            newsId.add(news[i].id);
            likePressed.add(news[i].userLiked);
          }
          ref
            .read(schoolControllerProvider.notifier)
            .getPolls(newsId)
            .then((value) {
              setState(() {
                polls = value!;
                pollsId.clear();
                if(polls.isNotEmpty){
                  for(int i=0;i<news.length;i++){
                    if(polls.containsKey(news[i].id)){
                      pollsId.add(polls[news[i].id]!.id);
                    }
                  }
                  ref
                    .read(schoolControllerProvider.notifier)
                    .getAnswers(pollsId)
                    .then((value) {
                      setState(() {
                        answers = value!;
                      });
                    });
                }
              });
            });
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
            news.isEmpty || polls.isEmpty || answers.isEmpty
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: blue),
                  ),
                )
              : Expanded(
                  child: RefreshIndicator(
                    onRefresh: () {
                      return getNews();
                    },
                    child: ListView.builder(
                      itemCount: news.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        int newsId = news[index].id;
                        List<String> text = news[index].text;
                        List<String> media = news[index].media;
                        String authorName = news[index].authorName;
                        String authorAvatar = news[index].authorAvatar;
                        int likes = news[index].likes;
                        DateTime created = DateTime.parse(news[index].createdDateTime);
                        String title = "";
                        List<Answer> answersForNews = [];
                        bool hasVoted = false;
                        int choosedAnswer = 0;
                        DateTime pollEnd = DateTime.now();

                        if(polls.isNotEmpty && polls.containsKey(newsId)){
                          title = polls[newsId]!.title;
                          pollEnd = DateTime.parse(polls[newsId]!.pollEnd);
                          if(answers.isNotEmpty){
                            for(int i=0;i<answers.length;i++){
                              if(answers[i].pollId == polls[newsId]!.id){
                                answersForNews.add(answers[i]);
                              }
                            }
                          }
                          hasVoted = polls[newsId]!.hasVoted;
                          choosedAnswer = polls[newsId]!.choosedAnswer;
                        }

                        return Container(
                          padding: EdgeInsets.only(top: 10.h, left: 7.5.w, right: 15.w, bottom: 10.h),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: news[index].pin
                                  ? blue
                                  : Colors.grey,
                                width: news[index].pin
                                  ? 1.5.h
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
                                  authorAvatar == ""
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
                                        backgroundImage: NetworkImage(authorAvatar),
                                      ),
                                  GestureDetector(
                                    onTap: () {
                                      ref
                                        .read(schoolControllerProvider.notifier)
                                        .updateLikes(newsId, likes, likePressed[index], userId)
                                        .whenComplete(() {
                                          setState(() {
                                            likePressed[index] = !likePressed[index];
                                            getNews();
                                          });
                                        });
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          Icon(
                                            likePressed[index]
                                              ? Icons.favorite
                                              : Icons.favorite_outline,
                                            color: likePressed[index]
                                              ? const Color.fromRGBO(255, 0, 0, 1)
                                              : Colors.grey,
                                            size: 25.h,
                                          ),
                                          Text(
                                            likes.toString(),
                                            style: TextStyle(
                                              color: likePressed[index]
                                                ? const Color.fromRGBO(255, 0, 0, 1)
                                                : Colors.grey,
                                              fontSize: 12.h
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  )
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
                                                  authorName,
                                                  style: TextStyle(
                                                    fontSize: 14.h,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 7.5.w),
                                              ClipOval(
                                                child: Container(
                                                  color: Colors.grey,
                                                  height: 3.h,
                                                  width: 3.h,
                                                ),
                                              ),
                                              SizedBox(width: 7.5.w),
                                              Text(
                                                differenceInDates(DateTime.now(), created),
                                                style: TextStyle(
                                                  fontSize: 13.h,
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
                                                      newsId: newsId,
                                                      text: formatedText(text),
                                                      pin: news[index].pin,
                                                      pollId: answersForNews.isNotEmpty
                                                                ? polls[newsId]!.id
                                                                : 0,
                                                      title: answersForNews.isNotEmpty
                                                              ? title
                                                              : "",
                                                      answer1Id: answersForNews.isNotEmpty
                                                                  ? answersForNews[0].id
                                                                  : 0,
                                                      answer2Id: answersForNews.isNotEmpty
                                                                  ? answersForNews[1].id
                                                                  : 0,
                                                      answer3Id: answersForNews.length < 3
                                                                  ? 0
                                                                  : answersForNews[2].id,
                                                      answer4Id: answersForNews.length < 4
                                                                  ? 0
                                                                  : answersForNews[3].id,
                                                      answer1: answersForNews.isNotEmpty
                                                                ? answersForNews[0].answer
                                                                : "",
                                                      answer2: answersForNews.isNotEmpty
                                                                ? answersForNews[1].answer
                                                                : "",
                                                      answer3: answersForNews.length < 3
                                                                ? ""
                                                                : answersForNews[2].answer,
                                                      answer4: answersForNews.length < 4
                                                                ? ""
                                                                : answersForNews[3].answer,
                                                      pollEnd: pollEnd,
                                                      images: media,
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
                                    for(int i=0;i<text.length;i++)
                                      StyledText(
                                        text: json.decode(text[i])['text'],
                                        style: TextStyle(
                                          fontSize: 14.h,
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

                                    if(polls.containsKey(newsId))
                                      SizedBox(height: 15.h),

                                    //poll
                                    if(polls.containsKey(newsId))
                                      FlutterPolls(
                                        onVoted: (PollOption pollOption, _) async {
                                          ref
                                            .read(schoolControllerProvider.notifier)
                                            .updateVotes(polls[newsId]!.id, pollOption.id!, userId)
                                            .whenComplete(() {
                                              setState(() {
                                                getNews();
                                              });
                                            });
                                          await Future.delayed(const Duration(seconds: 3));
                                          return true;
                                        }, 
                                        pollId: polls[newsId]!.id.toString(),
                                        pollTitle: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            polls[newsId]!.title,
                                            style: TextStyle(
                                              fontSize: 14.h,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        pollEnded: DateTime.now() == pollEnd,
                                        hasVoted: hasVoted,
                                        userVotedOptionId: choosedAnswer,
                                        pollOptions: [
                                          for(int i=0;i<answersForNews.length;i++)
                                            PollOption(
                                              id: answersForNews[i].id,
                                              title: Padding(
                                                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    answersForNews[i].answer,
                                                    style: TextStyle(
                                                      fontSize: 13.h
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              votes: answersForNews[i].votes
                                            )
                                        ],
                                        voteInProgressColor: Colors.white,
                                        votedBackgroundColor: Colors.white,
                                        leadingVotedProgessColor: transparentLightGrey,
                                        votedPercentageTextStyle: TextStyle(
                                          fontSize: 14.h,
                                          color: Colors.black
                                        ),
                                        metaWidget: Row(
                                          children: [
                                            SizedBox(width: 7.5.w),
                                            ClipOval(
                                              child: Container(
                                                color: Colors.black,
                                                height: 3.h,
                                                 width: 3.h,
                                              ),
                                            ),
                                            SizedBox(width: 7.5.w),
                                            Text(
                                              "${differenceInDates(pollEnd, DateTime.now())} palika nobalsot",
                                              style: TextStyle(
                                                fontSize: 13.h,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ]
                                        )
                                      ),
                                    
                                    //images
                                    for(int i=0;i<media.length;i++)
                                      Container(
                                        padding: EdgeInsets.only(top: 5.h),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.h)
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10.h),
                                          child: Image.network(
                                            json.decode(media[i])['image_url'],
                                            fit: BoxFit.cover
                                          ),
                                        ),
                                      ),
                                  ]
                                )
                              )
                            ],
                          )
                        );
                      },
                    )
                  ),
                )
          ]
        )
      ),
    );
  }
}