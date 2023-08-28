class Ticket {
  const Ticket({
    required this.id,
    required this.userId,
    required this.title,
    required this.eventId,
    required this.key,
    required this.endDateTime,
    required this.createdDateTime
  });

  final int id;
  final int userId;
  final String title;
  final int eventId;
  final int key;
  final String endDateTime;
  final String createdDateTime;
}