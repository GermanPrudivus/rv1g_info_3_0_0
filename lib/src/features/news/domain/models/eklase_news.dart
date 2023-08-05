class EklaseNews {
  const EklaseNews({
    required this.id,
    required this.title,
    required this.author,
    required this.shortText,
    required this.text,
    required this.media,
    required this.pin,
    required this.createdDateTime
  });

  final int id;
  final String title;
  final String author;
  final String shortText;
  final List<String> text;
  final List<String> media;
  final bool pin;
  final String createdDateTime;
}