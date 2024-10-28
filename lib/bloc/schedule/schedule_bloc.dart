// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:vetpro/data/datasources/schedule_remote_datasource.dart';
import 'package:vetpro/data/models/schedule_request_model.dart';
import 'package:vetpro/data/models/schedule_response_model.dart';

part 'schedule_bloc.freezed.dart';
part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleRemoteDatasource datasource;
  ScheduleBloc(
    this.datasource,
  ) : super(const _Initial()) {
    on<_GetSchedule>((event, emit) async {
      emit(const _Loading());
      final response = await datasource.getSchedule();
      response.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_LoadedGet(r)),
      );
    });

    on<_CreateSchedule>((event, emit) async {
      emit(const _Loading());
      final response = await datasource.createSchedule(event.model);
      response.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_LoadedCreate(r)),
      );
    });

    on<_UpdateSchedule>((event, emit) async {
      emit(const _Loading());
      final response = await datasource.updateSchedule(event.id, event.model);
      response.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_LoadedUpdate(r)),
      );
    });

    on<_DeleteSchedule>((event, emit) async {
      emit(const _Loading());
      final response = await datasource.deleteSchedule(event.id);
      response.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_LoadedDelete(r)),
      );
    });
  }
}
