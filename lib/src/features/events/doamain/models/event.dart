class Event {
  const Event({
    required this.id,
    required this.title,
    required this.shortText,
    required this.description,
    required this.participantQuant,
    required this.startDate,
    required this.endDate,
    required this.key,
    required this.media,
  });

  final int id;
  final String title;
  final String shortText;
  final List<String> description;
  final int participantQuant;
  final String startDate;
  final String endDate;
  final int key;
  final List<String> media;
}