import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vetpro/data/datasources/schedule_remote_datasource.dart';
import 'package:vetpro/data/models/schedule_request_model.dart';
import 'package:vetpro/data/models/schedule_response_model.dart';
import 'package:logger/logger.dart';

part 'schedule_bloc.freezed.dart';
part 'schedule_event.dart';
part 'schedule_state.dart';

final logger = Logger();

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRemoteDatasource datasource;

  ScheduleBloc(this.datasource) : super(const _Initial()) {
    
    // Handle fetching schedules
    on<_GetSchedule>((event, emit) async {
      logger.d("Event triggered: _GetSchedule");
      emit(const _Loading());

      final response = await datasource.getSchedule();
      response.fold(
        (error) {
          logger.e("Error fetching schedules: $error");
          emit(_Error(error));
        },
        (data) {
          logger.d("Schedules loaded successfully: ${data.data.length}");
          emit(_LoadedGet(data));
        },
      );
    });


    // Handle creating a new schedule
    on<_CreateSchedule>((event, emit) async {
      logger.d("Event triggered: _CreateSchedule");
      emit(const _Loading());

      final response = await datasource.createSchedule(event.model);
      response.fold(
        (error) {
          logger.e("Error creating schedule: $error");
          emit(_Error(error));
        },
        (data) {
          logger.d("Schedule created successfully: ${data.animalName}");
          emit(_LoadedCreate(data));
        },
      );
    });

    // Handle updating an existing schedule
    on<_UpdateSchedule>((event, emit) async {
      logger.d("Event triggered: _UpdateSchedule");
      emit(const _Loading());

      final response = await datasource.updateSchedule(event.id, event.model);
      response.fold(
        (error) {
          logger.e("Error updating schedule: $error");
          emit(_Error(error));
        },
        (data) {
          logger.d("Schedule updated successfully: ${data.animalName}");
          emit(_LoadedUpdate(data));
        },
      );
    });

    // Handle deleting a schedule
    on<_DeleteSchedule>((event, emit) async {
      logger.d("Event triggered: _DeleteSchedule");
      emit(const _Loading());

      final response = await datasource.deleteSchedule(event.id);
      response.fold(
        (error) {
          logger.e("Error deleting schedule: $error");
          emit(_Error(error));
        },
        (message) {
          logger.d("Schedule deleted successfully");
          emit(_LoadedDelete(message));
        },
      );
    });
  }
}
