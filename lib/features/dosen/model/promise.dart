import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Promise {
  String? id;
  DateTime? date;
  String? dosenId;
  String? siswaId;
  String? roomId;
  String? status;
  String? reason;
  DateTime? updatedAt;

  Promise({
    this.id,
    this.date,
    this.dosenId,
    this.siswaId,
    this.roomId,
    this.status,
    this.reason,
    this.updatedAt,
  });

  Promise copyWith({
    String? id,
    DateTime? date,
    String? dosenId,
    String? siswaId,
    String? roomId,
    String? status,
    String? reason,
    DateTime? updatedAt,
  }) =>
      Promise(
        id: id,
        date: date ?? this.date,
        dosenId: dosenId ?? this.dosenId,
        siswaId: siswaId ?? this.siswaId,
        roomId: roomId ?? this.roomId,
        status: status ?? this.status,
        reason: reason ?? this.reason,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Promise.fromRawJson(String str) => Promise.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Promise.fromJson(Map<String, dynamic> json) => Promise(
        id: json["id"],
        date:
            json["date"] == null ? null : (json["date"] as Timestamp).toDate(),
        dosenId: json["dosenId"],
        siswaId: json["siswaId"],
        roomId: json["roomId"],
        status: json["status"],
        reason: json["reason"],
        updatedAt: json["updatedAt"] == null
            ? null
            : (json["updatedAt"] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "dosenId": dosenId,
        "siswaId": siswaId,
        "roomId": roomId,
        "status": status,
        "reason": reason,
        "updatedAt": updatedAt,
      };
}
