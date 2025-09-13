import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vetpro/data/datasources/inspection_remote_datasource.dart';
import 'package:vetpro/data/models/inspection_model.dart';

part 'inspection_bloc.freezed.dart';
part 'inspection_event.dart';
part 'inspection_state.dart';

class InspectionBloc extends Bloc<InspectionEvent, InspectionState> {
  final InspectionRemoteDatasource datasource;

  InspectionBloc(this.datasource) : super(const _Initial()) {
    on<_AddInspection>(_onAddInspection);
    on<_FetchMostRecentInspection>(_onFetchMostRecentInspection);
  }

  Future<void> _onAddInspection(_AddInspection event, Emitter<InspectionState> emit) async {
    emit(const InspectionState.loading());
    final response = await datasource.addInspection(event.data);


    response.fold(
      (failureMessage) => emit(InspectionState.error(failureMessage)),
      (inspectionData) => emit(InspectionState.loaded(inspectionData)),
    );
  }

  Future<void> _onFetchMostRecentInspection(
    _FetchMostRecentInspection event,
    Emitter<InspectionState> emit) async {
  
  emit(const InspectionState.loading()); // Optional: emit loading state

  final response = await datasource.getListInspection();

  response.fold(
    (errorMessage) => emit(InspectionState.error(errorMessage)),
    (inspectionList) {
      if (inspectionList.isNotEmpty) {
        // Get the most recent inspection (assuming sorted by date)
        final mostRecentInspection = inspectionList.first;
        emit(InspectionState.loaded(mostRecentInspection));
      } else {
        emit(const InspectionState.error("No recent inspections found."));
      }
    },
  );
}



}
