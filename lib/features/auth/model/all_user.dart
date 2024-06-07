import 'dart:convert';

class AllUser {
  final String? id;
  final String? email;
  final String? name;
  final String? nisn;
  final String? nip;
  final String? type;
  final String? phoneNumber;
  final String? pembimbing;
  final String? imageUrl;

  AllUser({
    this.id,
    this.email,
    this.name,
    this.nisn,
    this.nip,
    this.type,
    this.phoneNumber,
    this.pembimbing,
    this.imageUrl,
  });

  AllUser copyWith({
    String? id,
    String? email,
    String? name,
    String? nisn,
    String? nip,
    String? type,
    String? phoneNumber,
    String? pembimbing,
    String? imageUrl,
  }) {
    return AllUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      nisn: nisn ?? this.nisn,
      nip: nip ?? this.nip,
      type: type ?? this.type,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      pembimbing: pembimbing ?? this.pembimbing,
      imageUrl: imageUrl ?? this.imageUrl,
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
        phoneNumber: json["number"] ?? '',
        pembimbing: json["pembimbing"] ?? '',
        imageUrl: json["imageUrl"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "nisn": nisn,
        "nip": nip,
        "type": type,
        "number": phoneNumber,
        "pembimbing": pembimbing,
        "imageUrl": imageUrl,
      };
}
