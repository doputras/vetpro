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
        inspections.sort((a, b) => b.date.compareTo(a.date)); 
        return right(inspections);
      } else {
        return left('Failed to load inspections with status code: ${response.statusCode}');
      }
    } catch (e) {
      return left('Exception when fetching data: $e');
    }
  }

   Future<Either<String, InspectionModel>> updateInspection(InspectionModel data) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${data.id}'), // Ensure ID is part of the model
        headers: {"Content-Type": "application/json"},
        body: json.encode(data.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Right(InspectionModel.fromJson(jsonData));
      } else {
        return Left('Failed to update inspection: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Error updating inspection: $e');
    }
  }

  // Delete inspection by ID
  Future<Either<String, String>> deleteInspection(int inspectionId) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$inspectionId'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return const Right('Inspection deleted successfully');
      } else {
        return Left('Failed to delete inspection: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Error deleting inspection: $e');
    }
  }
}
