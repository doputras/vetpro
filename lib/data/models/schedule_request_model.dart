import 'dart:convert';

class ScheduleRequestModel {
  final String animalName;
  final String location;
  final String inspector;
  final DateTime inspectionDate;
  final String description;

  ScheduleRequestModel({
    required this.animalName,
    required this.location,
    required this.inspector,
    required this.inspectionDate,
    required this.description,
  });

  factory ScheduleRequestModel.fromJson(String str) =>
      ScheduleRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ScheduleRequestModel.fromMap(Map<String, dynamic> json) =>
      ScheduleRequestModel(
        animalName: json["animal_name"],
        location: json["location"],
        inspector: json["inspector"],
        inspectionDate: DateTime.parse(json["inspection_date"]),
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "animal_name": animalName,
        "location": location,
        "inspector": inspector,
        "inspection_date":
            "${inspectionDate.year.toString().padLeft(4, '0')}-${inspectionDate.month.toString().padLeft(2, '0')}-${inspectionDate.day.toString().padLeft(2, '0')}",
        "description": description,
      };
}
