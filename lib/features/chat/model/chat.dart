import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String? id;
  String? roomId;
  String? userId;
  String? chat;
  DateTime? createdAt;

  Chat({
    this.id,
    this.roomId,
    this.userId,
    this.chat,
    this.createdAt,
  });

  Chat copyWith({
    String? id,
    String? roomId,
    String? userId,
    String? chat,
    DateTime? createdAt,
  }) =>
      Chat(
        id: id,
        roomId: roomId ?? this.roomId,
        userId: userId ?? this.userId,
        chat: chat ?? this.chat,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Chat.fromRawJson(String str) => Chat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["id"],
        roomId: json["roomId"],
        userId: json["userId"],
        chat: json["chat"],
        createdAt: json["createdAt"] == null
            ? null
            : (json["createdAt"] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "roomId": roomId,
        "userId": userId,
        "chat": chat,
        "createdAt": createdAt
      };
}
