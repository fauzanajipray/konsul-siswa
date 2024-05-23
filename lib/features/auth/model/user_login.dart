import 'dart:convert';

class UserLogin {
  final String? id;
  final String? email;
  final String? name;
  final String? nisn;
  final String? type;

  UserLogin({
    this.id,
    this.email,
    this.name,
    this.nisn,
    this.type,
  });

  factory UserLogin.fromRawJson(String id, String str) =>
      UserLogin.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
        id: json["id"] ?? '',
        email: json["email"] ?? '',
        name: json["name"] ?? '',
        nisn: json["nisn"] ?? '',
        type: json["type"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "nisn": nisn,
        "type": type,
      };
}
