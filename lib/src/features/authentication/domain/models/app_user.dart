class AppUser {
  const AppUser({
    required this.id,
    required this.profilePicUrl,
    required this.name,
    required this.surname,
    required this.formId,
    required this.email,
    required this.password,
    required this.verified,
    required this.createdDateTime
  });

  final int id;
  final String profilePicUrl;
  final String name;
  final String surname;
  final int formId;
  final String email;
  final String password;
  final bool verified;
  final DateTime createdDateTime;

  static AppUser fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'],
    profilePicUrl: json['profilePicUrl'],
    name: json['name'],
    surname: json['surname'],
    formId: json['formId'],
    email: json['email'],
    password: json['password'],
    verified: json['verifid'],
    createdDateTime: json['createdDateTime']
  );
 
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'profilePicUrl': profilePicUrl,
    'name': name,
    'surname': surname,
    'formId': formId,
    'email': email,
    'password': password,
    'verified': verified,
    'createdDateTime': createdDateTime
  };
}