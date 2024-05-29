import 'dart:convert';

class UserLogin {
  final String? id;
  final String? email;
  final String? name;
  final String? nisn;
  final String? nip;
  final String? type;
  final String? pembimbing;

  UserLogin({
    this.id,
    this.email,
    this.name,
    this.nisn,
    this.nip,
    this.type,
    this.pembimbing,
  });

  UserLogin copyWith({
    String? id,
    String? email,
    String? name,
    String? nisn,
    String? nip,
    String? type,
    String? pembimbing,
  }) {
    return UserLogin(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      nisn: nisn ?? this.nisn,
      nip: nip ?? this.nip,
      type: type ?? this.type,
      pembimbing: pembimbing ?? this.pembimbing,
    );
  }

  factory UserLogin.fromRawJson(String id, String str) =>
      UserLogin.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
        id: json["id"] ?? '',
        email: json["email"] ?? '',
        name: json["name"] ?? '',
        nisn: json["nisn"] ?? '',
        nip: json["nip"] ?? '',
        type: json["type"] ?? '',
        pembimbing: json["pembimbing"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "nisn": nisn,
        "nip": nip,
        "type": type,
        "pembimbing": pembimbing,
      };
}
