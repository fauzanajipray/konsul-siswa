import 'dart:convert';

import 'package:intl/intl.dart';

class Profile {
  final String? id;
  final String? email;
  final String? name;
  final String? nisn;
  final String? number;
  final DateTime? birthday;
  final String? imageUrl;

  Profile({
    this.id,
    this.email,
    this.name,
    this.nisn,
    this.number,
    this.birthday,
    this.imageUrl,
  });

  Profile copyWith({
    String? id,
    String? email,
    String? name,
    String? nisn,
    String? number,
    DateTime? birthday,
    String? imageUrl,
  }) =>
      Profile(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
        nisn: nisn ?? this.nisn,
        number: number ?? this.number,
        birthday: birthday ?? this.birthday,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  factory Profile.fromRawJson(String id, String str) =>
      Profile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Profile.fromJson(Map<String, dynamic> json) {
    final dateFormat = DateFormat('dd-MM-yyyy');
    return Profile(
      id: json["id"] ?? '',
      email: json["email"] ?? '',
      name: json["name"] ?? '',
      nisn: json["nisn"] ?? '',
      number: json["number"] ?? '',
      birthday:
          json["birthday"] == null ? null : dateFormat.parse(json["birthday"]),
      imageUrl: json["imageUrl"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "nisn": nisn,
        "number": number,
        "birthday": birthday == null
            ? null
            : DateFormat('dd-MM-yyyy').format(birthday!),
        "imageUrl": imageUrl,
      };
}
