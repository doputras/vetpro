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
      // Emit the loading state
      emit(const _Loading());

      // Perform the operations that don't require the current state
      final inspectionInvoice = InspectionInvoice(
        inspectionModel: event.data,
        status: event.status,
      );

      // Check if the current state is _Loaded to access its items safely
      if (state is _Loaded) {
        final currentState = state as _Loaded; // This is safe now

        // Define a new list of items to include the new invoice
        final updatedItems = List<InspectionInvoice>.from(currentState.items)
          ..add(inspectionInvoice);

        // Emit the loaded state with the updated items
        emit(_Loaded(updatedItems));

        // Save data to shared preferences
        final prefs = await SharedPreferences.getInstance();
        final itemList = updatedItems.map((item) => item.toJson()).toList();
        await prefs.setString('invoiceData', json.encode(itemList));
      } else {
        // Handle the case where the state is not _Loaded
        // Maybe emit an error state or log this unexpected case
        // e.g., emit(_Error("Cannot add to list while data is loading"));
      }
    });
  }
}
