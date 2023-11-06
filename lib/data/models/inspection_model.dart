// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class InspectionModel {
  final String? inspectionId;
  final String? animal;
  final String? cageTreatment;
  final String? environmentalCare;
  final String? feeding;
  final String? inspector;
  final String? location;
  final String? medicalTreatment;
  final String? suggestion;
  final String? result;
  final String? createdAt;

  InspectionModel({
    this.inspectionId,
    this.animal,
    this.cageTreatment,
    this.environmentalCare,
    this.feeding,
    this.inspector,
    this.location,
    this.medicalTreatment,
    this.suggestion,
    this.result,
    this.createdAt,
  });

  factory InspectionModel.fromJson(String str) =>
      InspectionModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InspectionModel.fromMap(Map<String, dynamic> json) => InspectionModel(
        inspectionId: json["inspection_id"] ?? '',
        animal: json["animal"] ?? '',
        cageTreatment: json["cage_treatment"] ?? '',
        environmentalCare: json["environmental_care"] ?? '',
        feeding: json["feeding"] ?? '',
        inspector: json["inspector"] ?? '',
        location: json["location"] ?? '',
        medicalTreatment: json["medical_treatment"] ?? '',
        suggestion: json["suggestion"] ?? '',
        result: json["result"] ?? '',
        createdAt: json["created_at"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "inspection_id": inspectionId,
        "animal": animal,
        "cage_treatment": cageTreatment,
        "environmental_care": environmentalCare,
        "feeding": feeding,
        "inspector": inspector,
        "location": location,
        "medical_treatment": medicalTreatment,
        "suggestion": suggestion,
        "result": result,
        "created_at": createdAt,
      };
}
