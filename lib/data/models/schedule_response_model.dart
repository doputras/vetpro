import 'dart:convert';

class ScheduleResponseModel {
  final List<Schedule> data;

  ScheduleResponseModel({required this.data});

  // Parse a JSON list into a ScheduleResponseModel
  factory ScheduleResponseModel.fromList(List<dynamic> jsonList) =>
      ScheduleResponseModel(
        data: jsonList.map((x) => Schedule.fromMap(x)).toList(),
      );

  String toJson() => json.encode(data.map((x) => x.toMap()).toList());
}

class Schedule {
  final int? id;
  final String? animalName;
  final String? location;
  final String? inspector;
  final DateTime? inspectionDate;
  final String? description;

  Schedule({
    this.id,
    this.animalName,
    this.location,
    this.inspector,
    this.inspectionDate,
    this.description,
  });

  factory Schedule.fromMap(Map<String, dynamic> json) => Schedule(
        id: json["id"] as int?,
        animalName: json["animal_name"] as String?,
        location: json["location"] as String?,
        inspector: json["inspector"] as String?,
        inspectionDate: json["inspection_date"] != null
            ? DateTime.parse(json["inspection_date"])
            : null,
        description: json["description"] as String?,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "animal_name": animalName,
        "location": location,
        "inspector": inspector,
        "inspection_date": inspectionDate?.toIso8601String(),
        "description": description,
      };
}
