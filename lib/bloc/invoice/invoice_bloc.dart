import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vetpro/data/datasources/invoices_remote_datasource.dart';
import 'package:vetpro/data/models/invoices_model.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';
part 'invoice_bloc.freezed.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final InvoicesRemoteDatasource datasource;

  InvoiceBloc(this.datasource) : super(_Initial()) {
    on<InvoiceEvent>((event, emit) {
      on<_GetListInvoice>(_onToListInvoice);
    });
  }

  FutureOr<void> _onToListInvoice(
      _GetListInvoice event, Emitter<InvoiceState> emit) async {
    final response = await datasource.getListInvoices();

    response.fold(
      (errorMessage) => emit(InvoiceState.error(errorMessage)),
      (invoiceList) {
        if (invoiceList.isNotEmpty) {
          final mostRecentInvoice = invoiceList;
          emit(InvoiceState.loaded(mostRecentInvoice));
        } else {
          emit(const InvoiceState.error("No recent Invoices found."));
        }
      },
    );
  }
}
