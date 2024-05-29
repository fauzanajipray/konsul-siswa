import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Promise {
  DateTime? date;
  String? dosenId;
  String? siswaId;
  String? status;

  Promise({
    this.date,
    this.dosenId,
    this.siswaId,
    this.status,
  });

  Promise copyWith({
    DateTime? date,
    String? dosenId,
    String? siswaId,
    String? status,
  }) =>
      Promise(
        date: date ?? this.date,
        dosenId: dosenId ?? this.dosenId,
        siswaId: siswaId ?? this.siswaId,
        status: status ?? this.status,
      );

  factory Promise.fromRawJson(String str) => Promise.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Promise.fromJson(Map<String, dynamic> json) => Promise(
        date:
            json["date"] == null ? null : (json["date"] as Timestamp).toDate(),
        dosenId: json["dosenId"],
        siswaId: json["siswaId"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "dosenId": dosenId,
        "siswaId": siswaId,
        "status": status,
      };
}
