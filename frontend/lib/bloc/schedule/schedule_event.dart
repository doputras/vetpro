part of 'schedule_bloc.dart';

@freezed
class ScheduleEvent with _$ScheduleEvent {
  const factory ScheduleEvent.started() = _Started;
  const factory ScheduleEvent.getSchedule() = _GetSchedule;
  const factory ScheduleEvent.createSchedule(ScheduleRequestModel model) =
      _CreateSchedule;
  const factory ScheduleEvent.updateSchedule(
      int id, ScheduleRequestModel model) = _UpdateSchedule;
  const factory ScheduleEvent.deleteSchedule(int id) = _DeleteSchedule;
}
