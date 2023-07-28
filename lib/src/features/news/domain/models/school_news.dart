class SchoolNews {
  const SchoolNews({
    required this.id,
    required this.authorId,
    required this.text,
    required this.media,
    required this.likes,
    required this.pin,
    required this.createdDateTime
  });

  final int id;
  final int authorId;
  final List<String> text;
  final List<String> media;
  final int likes;
  final bool pin;
  final String createdDateTime;

  static SchoolNews fromJson(Map<String, dynamic> json) => SchoolNews(
    id: json['id'],
    authorId: json['author_id'],
    text: List.from(json['text']),
    media: List.from(json['media']),
    likes: json['likes'],
    pin: json['pin'],
    createdDateTime: json['created_datetime']
  );
 
  Map<String, dynamic> toJson() => <String, dynamic>{
    'author_id': authorId,
    'text': text,
    'media': media,
    'likes': likes,
    'pin': pin,
    'created_datetime': createdDateTime
  };
}