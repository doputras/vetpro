import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetpro/data/models/inspection_model.dart';

part 'inspection_invoice_event.dart';
part 'inspection_invoice_state.dart';
part 'inspection_invoice_bloc.freezed.dart';

class InspectionInvoiceBloc
    extends Bloc<InspectionInvoiceEvent, InspectionInvoiceState> {
  InspectionInvoiceBloc() : super(const _Loaded([])) {
    on<_AddToListInvoice>((event, emit) async {
      emit(const _Loading());
      final inspectionInvoice = InspectionInvoice(
        inspectionModel: event.data,
        status: event.status,
      );

      final currentState = state as _Loaded;

      emit(_Loaded([
        ...currentState.items,
        inspectionInvoice,
      ]));

      // Save data to shared preferences
      final prefs = await SharedPreferences.getInstance();
      final itemList = currentState.items.map((item) => item.toJson()).toList();
      await prefs.setString('invoiceData', json.encode(itemList));
    });
  }
}
