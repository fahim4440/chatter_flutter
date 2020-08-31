class UserModel {
  final String name;
  final String email;
  final String photoUrl;

  UserModel.fromFirebase(Map<String, dynamic> parsedJson)
      : name = parsedJson['name'],
        email = parsedJson['email'],
        photoUrl = parsedJson['photoUrl'];

  UserModel.fromDb(Map<String, dynamic> parsedDb)
      : name = parsedDb['name'],
        email = parsedDb['email'],
        photoUrl = parsedDb['photoUrl'];

  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{
      "name": name,
      "email": email,
      "photoUrl": photoUrl ?? ''
    };
  }
}
