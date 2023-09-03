import 'participant.dart';

class Scanner {
  const Scanner({
    required this.id,
    required this.title,
    required this.key,
    required this.participantQuant,
    required this.participants,
    required this.endedDate,
  });

  final int id;
  final String title;
  final int key;
  final int participantQuant;
  final List<Participant> participants;
  final String endedDate;
}