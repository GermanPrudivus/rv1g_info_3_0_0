class Role {
  const Role({
    required this.id,
    required this.role,
    required this.description,
    required this.userId,
    required this.startedDatetime,
    required this.endedDatetime,
  });

  final int id;
  final String role;
  final String description;
  final int userId;
  final String startedDatetime;
  final String endedDatetime;
}