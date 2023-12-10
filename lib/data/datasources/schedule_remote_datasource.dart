import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:vetpro/common/constants/global_variables.dart';
import 'package:vetpro/data/models/schedule_request_model.dart';
import 'package:vetpro/data/models/schedule_response_model.dart';

class ScheduleRemoteDatasource {
  //Get All
  Future<Either<String, ScheduleResponseModel>> getSchedule() async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final response = await http.get(
      Uri.parse('${GlobalVariables.baseUrl}/api/schedules'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // final List<Schedule>? schedules =
      //     ScheduleResponseModel.fromJson(response.body).data;

      // final DateTime currentDate = DateTime.now();

      // schedules!.removeWhere((schedule) =>
      //     DateTime.parse(schedule.inspectionDate.toString())
      //         .isBefore(currentDate));

      // print(currentDate);

      // return Right(ScheduleResponseModel(data: schedules));
      return Right(ScheduleResponseModel.fromJson(response.body));
    } else {
      return const Left('Server error. Contact admin please!');
    }
  }

  //Create schedule
  Future<Either<String, Schedule>> createSchedule(
      ScheduleRequestModel model) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final response = await http.post(
        Uri.parse('${GlobalVariables.baseUrl}/api/schedules'),
        headers: headers,
        body: model.toJson());

    if (response.statusCode == 201) {
      return Right(Schedule.fromJson(response.body));
    } else {
      return const Left('Server error.');
    }
  }

  //update schedule
  Future<Either<String, Schedule>> updateSchedule(
      int id, ScheduleRequestModel model) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final response = await http.put(
        Uri.parse('${GlobalVariables.baseUrl}/api/schedules/$id'),
        headers: headers,
        body: model.toJson());

    if (response.statusCode == 200) {
      return Right(Schedule.fromJson(response.body));
    } else {
      return const Left('Server error.');
    }
  }

  //delete schedule
  Future<Either<String, String>> deleteSchedule(int id) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final response = await http.delete(
      Uri.parse('${GlobalVariables.baseUrl}/api/schedules/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return const Right('Delete success.');
    } else {
      return const Left('Server error.');
    }
  }
}
