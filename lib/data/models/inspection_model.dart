// To parse this JSON data, do
//
//     final inspectionModel = inspectionModelFromJson(jsonString);

import 'dart:convert';

List<InspectionModel> inspectionModelFromJson(String str) => List<InspectionModel>.from(json.decode(str).map((x) => InspectionModel.fromJson(x)));

String inspectionModelToJson(List<InspectionModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InspectionModel {
    final int? id;
    final String animal;
    final String cageTreatment;
    final String date;
    final String environmentalCare;
    final String feeding;
    final String medicalTreatment;
    final String inspector;
    final String location;
    final String suggestion;
    final String result;

    InspectionModel({
        this.id,
        required this.animal,
        required this.cageTreatment,
        required this.date,
        required this.environmentalCare,
        required this.feeding,
        required this.medicalTreatment,
        required this.inspector,
        required this.location,
        required this.suggestion,
        required this.result,
    });

    factory InspectionModel.fromJson(Map<String, dynamic> json) => InspectionModel(
        id: json["id"],
        animal: json["animal"],
        cageTreatment: json["cage_treatment"],
        date: json["date"],
        environmentalCare: json["environmental_care"],
        feeding: json["feeding"],
        medicalTreatment: json["medical_treatment"],
        inspector: json["inspector"],
        location: json["location"],
        suggestion: json["suggestion"],
        result: json["result"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "animal": animal,
        "cage_treatment": cageTreatment,
        "date": date,
        "environmental_care": environmentalCare,
        "feeding": feeding,
        "medical_treatment": medicalTreatment,
        "inspector": inspector,
        "location": location,
        "suggestion": suggestion,
        "result": result,
    };
}
