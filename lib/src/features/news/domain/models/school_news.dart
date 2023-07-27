class SchoolNews {
  const SchoolNews({
    required this.id,
    required this.authorId,
    required this.text,
    required this.likes,
    required this.pin,
    required this.hasPoll,
    required this.createdDateTime
  });

  final int id;
  final int authorId;
  final String text;
  final int likes;
  final bool pin;
  final bool hasPoll;
  final DateTime createdDateTime;

  static SchoolNews fromJson(Map<String, dynamic> json) => SchoolNews(
    id: json['id'],
    authorId: json['author_id'],
    text: json['text'],
    likes: json['likes'],
    pin: json['pin'],
    hasPoll: json['has_poll'],
    createdDateTime: json['created_datetime']
  );
 
  Map<String, dynamic> toJson() => <String, dynamic>{
    'author_id': authorId,
    'text': text,
    'likes': likes,
    'pin': pin,
    'has_poll': hasPoll,
    'created_datetime': createdDateTime
  };
}