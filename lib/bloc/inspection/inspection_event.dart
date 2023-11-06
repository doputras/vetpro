part of 'inspection_bloc.dart';

@freezed
class InspectionEvent with _$InspectionEvent {
  const factory InspectionEvent.started() = _Started;
  const factory InspectionEvent.addInspection(InspectionModel data) =
      _AddInspection;
  const factory InspectionEvent.updateInspection() = _UpdateInspection;
  const factory InspectionEvent.deleteInspection() = _DeleteInspection;
}
