import 'dart:convert';

class Room {
  String? id;
  String? dosenId;
  String? siswaId;
  String? promiseId;
  String? status;

  Room({
    this.id,
    this.dosenId,
    this.siswaId,
    this.promiseId,
    this.status,
  });

  Room copyWith({
    String? id,
    String? dosenId,
    String? siswaId,
    String? promiseId,
    String? status,
  }) =>
      Room(
        id: id,
        dosenId: dosenId ?? this.dosenId,
        siswaId: siswaId ?? this.siswaId,
        promiseId: promiseId ?? this.promiseId,
        status: status ?? this.status,
      );

  factory Room.fromRawJson(String str) => Room.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json["id"],
        dosenId: json["dosenId"],
        siswaId: json["siswaId"],
        promiseId: json["promiseId"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dosenId": dosenId,
        "siswaId": siswaId,
        "promiseId": promiseId,
        "status": status,
      };
}
