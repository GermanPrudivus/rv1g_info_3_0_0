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
    profilePicUrl: json['profile_pic_url'],
    name: json['name'],
    surname: json['surname'],
    formId: json['form_id'],
    email: json['email'],
    password: json['password'],
    verified: json['verifid'],
    createdDateTime: json['created_datetime']
  );
 
  Map<String, dynamic> toJson() => <String, dynamic>{
    'profile_pic_url': profilePicUrl,
    'name': name,
    'surname': surname,
    'form_id': formId,
    'email': email,
    'password': password,
    'verified': verified,
    'created_datetime': createdDateTime
  };
}