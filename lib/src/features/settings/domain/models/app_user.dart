class AppUser {
  const AppUser({
    required this.id,
    required this.profilePicUrl,
    required this.fullName,
    required this.form,
    required this.email,
    required this.verified,
    required this.createdDateTime
  });

  final int id;
  final String profilePicUrl;
  final String fullName;
  final String form;
  final String email;
  final bool verified;
  final String createdDateTime;
}