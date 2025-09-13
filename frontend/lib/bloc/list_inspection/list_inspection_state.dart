part of 'list_inspection_bloc.dart';

@freezed
class ListInspectionState with _$ListInspectionState {
  const factory ListInspectionState.initial() = _Initial;
  const factory ListInspectionState.loading() = _Loading;
  const factory ListInspectionState.loaded(List<InspectionModel> data) =
      _Loaded;
  const factory ListInspectionState.error(String message) = _Error;
}
