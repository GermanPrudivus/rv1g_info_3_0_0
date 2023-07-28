class Poll {
  const Poll({
    required this.id,
    required this.title,
    required this.allVotes,
    required this.pollStart,
    required this.pollEnd,
    required this.newsId
  });

  final int id;
  final String title;
  final int allVotes;
  final String pollStart;
  final String pollEnd;
  final int newsId;

  static Poll fromJson(Map<String, dynamic> json) => Poll(
    id: json['id'],
    title: json['title'],
    allVotes: json['all_votes'],
    pollStart: json['poll_start'],
    pollEnd: json['poll_end'],
    newsId: json['news_id']
  );
 
  Map<String, dynamic> toJson() => <String, dynamic>{
    'title': title,
    'all_votes': allVotes,
    'pollStart': pollStart,
    'pollEnd': pollEnd,
    'news_id': newsId
  };
}