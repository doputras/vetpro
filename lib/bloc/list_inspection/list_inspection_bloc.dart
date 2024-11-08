import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vetpro/data/datasources/inspection_remote_datasource.dart';
import 'package:logger/logger.dart';

import '../../data/models/inspection_model.dart';

part 'list_inspection_event.dart';
part 'list_inspection_state.dart';
part 'list_inspection_bloc.freezed.dart';

final logger = Logger();

class ListInspectionBloc
    extends Bloc<ListInspectionEvent, ListInspectionState> {
  InspectionRemoteDatasource datasource;
  ListInspectionBloc(
    this.datasource,
  ) : super(const _Initial()) {
    on<_GetInspection>((event, emit) async {
      logger.d("Event triggered: _GetInspection");
      emit(const _Loading());
      final response = await datasource.getListInspection();
      response.fold(
        (error) {
          logger.e("Error: $error");
          emit(_Error(error));
        },
        (data) {
          logger.i("Data loaded: ${data.length} items");
          emit(_Loaded(data));
        },
      );
    });
  }
}
