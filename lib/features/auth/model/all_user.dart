import 'dart:convert';

class AllUser {
  final String? id;
  final String? email;
  final String? name;
  final String? nisn;
  final String? nip;
  final String? type;
  final String? pembimbing;

  AllUser({
    this.id,
    this.email,
    this.name,
    this.nisn,
    this.nip,
    this.type,
    this.pembimbing,
  });

  AllUser copyWith({
    String? id,
    String? email,
    String? name,
    String? nisn,
    String? nip,
    String? type,
    String? pembimbing,
  }) {
    return AllUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      nisn: nisn ?? this.nisn,
      nip: nip ?? this.nip,
      type: type ?? this.type,
      pembimbing: pembimbing ?? this.pembimbing,
    );
  }

  factory AllUser.fromRawJson(String id, String str) =>
      AllUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AllUser.fromJson(Map<String, dynamic> json) => AllUser(
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
