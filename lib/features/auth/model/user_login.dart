import 'dart:convert';

class UserLogin {
  final String id;
  final String email;
  final String name;
  final String nisn;

  UserLogin(
      {required this.id,
      required this.email,
      required this.name,
      required this.nisn});

  factory UserLogin.fromRawJson(String id, String str) =>
      UserLogin.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
        id: json["id"] ?? '',
        email: json["email"] ?? '',
        name: json["name"] ?? '',
        nisn: json["nisn"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "nisn": nisn,
      };
}
