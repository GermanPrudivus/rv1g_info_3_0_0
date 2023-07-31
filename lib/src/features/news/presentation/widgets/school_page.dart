import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/features/news/presentation/controllers/school_controller.dart';
import 'package:rv1g_info/src/features/news/presentation/widgets/crud_school_news_page.dart';
import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/theme_colors.dart';
import '../../domain/models/answer.dart';
import '../../domain/models/author_data.dart';
import '../../domain/models/poll.dart';
import '../../domain/models/school_news.dart';

class SchoolPage extends ConsumerStatefulWidget {
  const SchoolPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SchoolPageState();
}

class _SchoolPageState extends ConsumerState<SchoolPage> {

  List<SchoolNews> news = [];

  List<int> authorId = [];
  List<AuthorData> authorData = [];
  
  List<int> newsId = [];
  Map<int, Poll> polls = {};

  List<int> pollsId = [];
  List<Answer> answers = [];

  bool edit = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
          authorId.clear();
          newsId.clear();
          for(int i=0;i<news.length;i++){
            authorId.add(news[i].authorId);
            newsId.add(news[i].id);
          }
          ref
            .read(schoolControllerProvider.notifier)
            .getAuthorData(authorId)
            .then((value) {
              setState(() {
                authorData = value!;
              });
            });
          ref
            .read(schoolControllerProvider.notifier)
            .getPolls(newsId)
            .then((value) {
              setState(() {
                polls = value!;
                pollsId.clear();
                if(polls.isNotEmpty){
                  for(int i=1;i<=polls.length;i++){
                    pollsId.add(polls[i]!.id);
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children:[
            news.isEmpty || authorData.isEmpty
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: blue),
                  ),
                )
              : Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      getNews();
                    },
                    child: ListView.builder(
                      itemCount: news.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        List<String> text = news[index].text;
                        List<String> media = news[index].media;
                        String authorName = "";
                        String authorAvatar = "";
                        DateTime created = DateTime.now();
                        String title = "";
                        List<Answer> answersForNews = [];
                        DateTime pollEnd = DateTime.now();

                        if(authorData.isNotEmpty){
                          authorName = authorData[index].fullName;
                          authorAvatar = authorData[index].avatarUrl;
                          created = DateTime.parse(news[index].createdDateTime);
                        }

                        if(polls.isNotEmpty && polls.containsKey(index+1)){
                          title = polls[index+1]!.title;
                          pollEnd = DateTime.parse(polls[index+1]!.pollEnd);
                          if(answers.isNotEmpty){
                            for(int i=0;i<answers.length;i++){
                              if(answers[i].pollId == polls[index+1]!.id){
                                answersForNews.add(answers[i]);
                              }
                            }
                          }
                        }

                        return Container(
                          margin: EdgeInsets.only(left: 7.5.w, right: 15.w, top: 10.h, bottom: 10.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //avatar and like button
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  authorAvatar == ""
                                    ? CircleAvatar(
                                      radius: 20.h,
                                      backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 10.h,
                                      )
                                    )
                                    : CircleAvatar(
                                        radius: 20.h,
                                        backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                                        backgroundImage: NetworkImage(authorAvatar),
                                      ),
                                    
                                ],
                              ),

                              SizedBox(width: 7.5.w),

                              //text
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if(!edit)
                                      SizedBox(height: 7.h),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          authorName,
                                          style: TextStyle(
                                            fontSize: 14.h,
                                            fontWeight: FontWeight.bold,
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
                                        if(DateTime.now().difference(created).inDays > 0)
                                          Text(
                                            '${DateTime.now().difference(created).inDays}d',
                                            style: TextStyle(
                                              fontSize: 13.h,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        if(DateTime.now().difference(created).inDays == 0 
                                            && DateTime.now().difference(created).inHours > 0)
                                          Text(
                                            '${DateTime.now().hour-created.hour}h',
                                            style: TextStyle(
                                              fontSize: 13.h,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        if(DateTime.now().difference(created).inHours == 0)
                                          Text(
                                            '${DateTime.now().difference(created).inMinutes}m',
                                            style: TextStyle(
                                              fontSize: 13.h,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        if(edit)
                                          SizedBox(width: 90.w,),
                                        if(edit)
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
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
                                                    formatedText = formatedText+json.decode(text[text.length-1])['text'];

                                                    return AddSchoolNewsPage(
                                                      edit: true,
                                                      newsId: news[index].id,
                                                      text: formatedText,
                                                      pin: news[index].pin,
                                                      pollId: answersForNews.isNotEmpty
                                                                ? polls[index+1]!.id
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
                                              ).whenComplete(() => getNews());
                                            },
                                            child: Container(
                                              height: 30.h,
                                              width: 40.h,
                                              alignment: Alignment.center,
                                              color: Colors.white,
                                              child: const Icon(
                                                Icons.edit,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  
                                    if(!edit)
                                      SizedBox(height: 5.h),

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
                                      )
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