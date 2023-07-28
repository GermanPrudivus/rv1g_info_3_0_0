class Answer {
  const Answer({
    required this.id,
    required this.answer,
    required this.votes,
    required this.pollId,
  });

  final int id;
  final String answer;
  final int votes;
  final int pollId;

  static Answer fromJson(Map<String, dynamic> json) => Answer(
    id: json['id'],
    answer: json['answer'],
    votes: json['votes'],
    pollId: json['poll_id'],
  );
 
  Map<String, dynamic> toJson() => <String, dynamic>{
    'answer': answer,
    'votes': votes,
    'poll_id': pollId,
  };
}