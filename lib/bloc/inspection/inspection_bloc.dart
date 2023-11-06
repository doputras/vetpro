// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:vetpro/data/datasources/inspection_remote_datasource.dart';
import 'package:vetpro/data/models/inspection_model.dart';

part 'inspection_bloc.freezed.dart';
part 'inspection_event.dart';
part 'inspection_state.dart';

class InspectionBloc extends Bloc<InspectionEvent, InspectionState> {
  InspectionRemoteDatasource datasource;
  InspectionBloc(
    this.datasource,
  ) : super(const _Initial()) {
    on<_AddInspection>((event, emit) async {
      emit(const _Loading());
      final response = await datasource.addInspection(event.data);
      response.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r)),
      );
    });

    on<_UpdateInspection>((event, emit) async {
      //Todo
    });

    on<_DeleteInspection>((event, emit) async {
      //Todo
    });
  }
}
