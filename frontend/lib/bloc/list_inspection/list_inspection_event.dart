part of 'list_inspection_bloc.dart';

@freezed
class ListInspectionEvent with _$ListInspectionEvent {
  const factory ListInspectionEvent.started() = _Started;
  const factory ListInspectionEvent.getInspection() = _GetInspection;
}
