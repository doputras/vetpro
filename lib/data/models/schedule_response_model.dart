import 'dart:convert';

class ScheduleResponseModel {
  List<Schedule>? data;

  ScheduleResponseModel({
    this.data,
  });

  factory ScheduleResponseModel.fromJson(String str) =>
      ScheduleResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ScheduleResponseModel.fromMap(Map<String, dynamic> json) =>
      ScheduleResponseModel(
        data: json["data"] == null
            ? []
            : List<Schedule>.from(
                json["data"]!.map((x) => Schedule.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Schedule {
  int? id;
  String? animalName;
  String? location;
  String? inspector;
  DateTime? inspectionDate;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  Schedule({
    this.id,
    this.animalName,
    this.location,
    this.inspector,
    this.inspectionDate,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Schedule.fromJson(String str) => Schedule.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Schedule.fromMap(Map<String, dynamic> json) => Schedule(
        id: json["id"],
        animalName: json["animal_name"],
        location: json["location"],
        inspector: json["inspector"],
        inspectionDate: json["inspection_date"] == null
            ? null
            : DateTime.parse(json["inspection_date"]),
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "animal_name": animalName,
        "location": location,
        "inspector": inspector,
        "inspection_date":
            "${inspectionDate!.year.toString().padLeft(4, '0')}-${inspectionDate!.month.toString().padLeft(2, '0')}-${inspectionDate!.day.toString().padLeft(2, '0')}",
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
