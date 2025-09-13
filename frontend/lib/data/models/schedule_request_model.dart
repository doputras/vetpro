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

  // Convert JSON string to ScheduleRequestModel
  factory ScheduleRequestModel.fromJson(String str) =>
      ScheduleRequestModel.fromMap(json.decode(str));

  // Convert ScheduleRequestModel to JSON string
  String toJson() => json.encode(toMap());

  // Convert JSON map to ScheduleRequestModel
  factory ScheduleRequestModel.fromMap(Map<String, dynamic> json) =>
      ScheduleRequestModel(
        animalName: json["animal_name"] ?? '',
        location: json["location"] ?? '',
        inspector: json["inspector"] ?? '',
        inspectionDate: json["inspection_date"] != null
            ? DateTime.parse(json["inspection_date"])
            : DateTime.now(), // Handle null dates gracefully
        description: json["description"] ?? '',
      );

  // Convert ScheduleRequestModel to JSON map
  Map<String, dynamic> toMap() => {
        "animal_name": animalName,
        "location": location,
        "inspector": inspector,
        "inspection_date": inspectionDate.toIso8601String(), // ISO 8601 format
        "description": description,
      };

  // Convert list of JSON objects to list of ScheduleRequestModels
  static List<ScheduleRequestModel> fromJsonList(String str) =>
      List<ScheduleRequestModel>.from(
          json.decode(str).map((x) => ScheduleRequestModel.fromMap(x)));

  // Convert list of ScheduleRequestModels to list of JSON maps
  static String toJsonList(List<ScheduleRequestModel> models) =>
      json.encode(List<dynamic>.from(models.map((x) => x.toMap())));
}
