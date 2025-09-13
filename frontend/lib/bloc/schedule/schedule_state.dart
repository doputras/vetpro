part of 'schedule_bloc.dart';

@freezed
class ScheduleState with _$ScheduleState {
  const factory ScheduleState.initial() = _Initial;
  const factory ScheduleState.loading() = _Loading;
  const factory ScheduleState.loadedGet(ScheduleResponseModel model) =
      _LoadedGet;
  const factory ScheduleState.loadedCreate(Schedule data) = _LoadedCreate;
  const factory ScheduleState.loadedUpdate(Schedule data) = _LoadedUpdate;
  const factory ScheduleState.loadedDelete(String message) = _LoadedDelete;
  const factory ScheduleState.error(String message) = _Error;
}
