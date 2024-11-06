import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:vetpro/data/models/inspection_model.dart';

class InspectionRemoteDatasource {
  final String apiUrl = "http://10.0.2.2:8000/api/inspections";

  Future<Either<String, InspectionModel>> addInspection(InspectionModel data) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode(data.toJson()), // Using toJson if available
      );

      if (response.statusCode == 201) {
        var jsonData = json.decode(response.body);
        InspectionModel inspection = InspectionModel.fromJson(jsonData);
        return right(inspection);
      } else {
        return left('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      return left('An exception occurred: $e');
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
