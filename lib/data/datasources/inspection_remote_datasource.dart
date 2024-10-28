import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:vetpro/data/models/inspection_model.dart';

class InspectionRemoteDatasource {
  final String apiUrl = "http://192.168.100.105:8000/api/inspections";


   Future<Either<String, InspectionModel>> addInspection(InspectionModel data) async {
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json", 'Accept': 'application/json',},
      body: json.encode({
        "animal": data.animal,
        "cage_treatment": data.cageTreatment,
        "date": data.date,
        "environmental_care": data.environmentalCare,
        "feeding": data.feeding,
        "medical_treatment" : data.medicalTreatment,
        "inspector": data.inspector,
        "location" : data.location,
        "suggestion" : data.suggestion,
        "result": data.result
      }),
    );

    if (response.statusCode == 201) {
      var jsonData = json.decode(response.body);
      // Assuming InspectionModel.fromJson() returns an InspectionModel instance
      InspectionModel inspection = InspectionModel.fromJson(jsonData);
      return right(inspection); // Return the successful result
    } else {
      var errorMsg = 'Request failed with status: ${response.statusCode}.';
      return left(errorMsg); // Return the error message
    }
  } catch (e) {
    // Log the error and return it
    return left('An exception occurred: $e'); // Return the exception message
  }
}
   Future<Either<String, List<InspectionModel>>> getListInspection() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<InspectionModel> inspections = jsonData.map((data) => InspectionModel.fromJson(data)).toList();
        return right(inspections);
      } else {
        return left('Failed to load inspections with status code: ${response.statusCode}');
      }
    } catch (e) {
      return left('Exception when fetching data: $e');
    }
  }

}


  
