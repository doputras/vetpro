import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vetpro/data/datasources/inspection_remote_datasource.dart';

import '../../data/models/inspection_model.dart';

part 'list_inspection_event.dart';
part 'list_inspection_state.dart';
part 'list_inspection_bloc.freezed.dart';

class ListInspectionBloc
    extends Bloc<ListInspectionEvent, ListInspectionState> {
  InspectionRemoteDatasource datasource;
  ListInspectionBloc(
    this.datasource,
  ) : super(const _Initial()) {
    on<_GetInspection>((event, emit) async {
      emit(const _Loading());
      final response = await datasource.getListInspection();
      response.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r)),
      );
    });
  }
}
