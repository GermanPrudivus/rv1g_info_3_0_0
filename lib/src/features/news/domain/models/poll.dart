class Poll {
  const Poll({
    required this.id,
    required this.title,
    required this.allVotes,
    required this.pollStart,
    required this.pollEnd,
    required this.newsId,
    required this.hasVoted,
    required this.choosedAnswer,
  });

  final int id;
  final String title;
  final int allVotes;
  final String pollStart;
  final String pollEnd;
  final int newsId;
  final bool hasVoted;
  final int choosedAnswer;
}