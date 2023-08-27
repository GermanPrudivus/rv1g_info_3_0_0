class Participant {
  const Participant({
    required this.userId,
    required this.fullName,
    required this.form,
    required this.active,
  });

  final int userId;
  final String fullName;
  final String form;
  final bool active;
}