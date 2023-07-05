class AppUser {
  const AppUser({
    required this.id,
    required this.username,
    required this.profilePicUrl,
    required this.name,
    required this.surname,
    required this.formId,
    required this.email,
    required this.password,
    required this.verified,
    required this.createdDatetime
  });

  final int id;
  final String username;
  final String profilePicUrl;
  final String name;
  final String surname;
  final int formId;
  final String email;
  final String password;
  final bool verified;
  final DateTime createdDatetime;
}