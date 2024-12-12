import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vetpro/data/models/schedule_request_model.dart';
import 'package:vetpro/data/models/schedule_response_model.dart';
import 'package:logger/logger.dart';

class ScheduleRemoteDatasource {
  final String apiUrl =
      "http://192.168.0.100:8000/api/schedules"; // Base URL for schedules API
  Logger logger = Logger();

  final Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  // Get all schedules
  Future<Either<String, ScheduleResponseModel>> getSchedule() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
      logger.d("Raw API response: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return Right(ScheduleResponseModel.fromList(jsonResponse));
      } else {
        return Left(
            'Failed to fetch schedules. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return Left('An error occurred: $e');
    }
  }

  // Create a new schedule
  Future<Either<String, Schedule>> createSchedule(
      ScheduleRequestModel model) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: model.toJson(),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(Schedule.fromMap(jsonResponse)); // Parse single schedule
      } else {
        return Left(
            'Failed to create schedule. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return Left('An error occurred: $e');
    }
  }

  // Update an existing schedule
  Future<Either<String, Schedule>> updateSchedule(
      int id, ScheduleRequestModel model) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: headers,
        body: model.toJson(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(Schedule.fromMap(jsonResponse)); // Parse single schedule
      } else {
        return Left(
            'Failed to update schedule. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return Left('An error occurred: $e');
    }
  }

  // Delete an existing schedule
  Future<Either<String, String>> deleteSchedule(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return const Right('Delete successful.');
      } else {
        return Left(
            'Failed to delete schedule. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return Left('An error occurred: $e');
    }
  }
}
