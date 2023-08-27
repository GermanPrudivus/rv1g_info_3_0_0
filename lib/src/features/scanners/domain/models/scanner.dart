import 'participant.dart';

class Scanner {
  const Scanner({
    required this.id,
    required this.title,
    required this.participantQuant,
    required this.participants,
    required this.endedDate,
  });

  final int id;
  final String title;
  final int participantQuant;
  final List<Participant> participants;
  final String endedDate;
}