import 'answer.dart';

class Poll {
  const Poll({
    required this.id,
    required this.title,
    required this.allVotes,
    required this.pollStart,
    required this.pollEnd,
    required this.newsId,
    required this.answers,
    required this.hasVoted,
    required this.choosedAnswer,
  });

  final int id;
  final String title;
  final int allVotes;
  final String pollStart;
  final String pollEnd;
  final int newsId;
  final List<Answer> answers;
  final bool hasVoted;
  final int choosedAnswer;
}