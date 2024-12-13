import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vetpro/data/datasources/invoices_remote_datasource.dart';
import 'package:vetpro/data/models/add_invoice_model.dart';
import 'package:vetpro/data/models/edit_invoice_model.dart';
import 'package:vetpro/data/models/invoices_model.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';
part 'invoice_bloc.freezed.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final InvoicesRemoteDatasource datasource;

  InvoiceBloc(this.datasource) : super(_Initial()) {
    on<_GetListInvoice>(_onToListInvoice);
    on<_GetListInvoiceByStatus>(_onToListInvoiceByStatus);
    on<_AddDataInvoice>(_onToAddDataInvoice);
    on<_EditDataInvoice>(_onToEditDataInvoice);
    on<_GetInvoiceById>(_onToInvoiceById);
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

  FutureOr<void> _onToAddDataInvoice(
      _AddDataInvoice event, Emitter<InvoiceState> emit) async {
    final response = await datasource.addInvoices(event.addInvoicesData);

    response.fold(
      (errorMessage) => emit(InvoiceState.error(errorMessage)),
      (invoice) {
        emit(InvoiceState.loadedAdd(invoice));
      },
    );
  }

  FutureOr<void> _onToInvoiceById(
      _GetInvoiceById event, Emitter<InvoiceState> emit) async {
    final response = await datasource.getInvoicesById(event.id);

    response.fold(
      (errorMessage) => emit(InvoiceState.error(errorMessage)),
      (invoice) {
        emit(InvoiceState.loadedById(invoice));
      },
    );
  }

  FutureOr<void> _onToListInvoiceByStatus(
      _GetListInvoiceByStatus event, Emitter<InvoiceState> emit) async {
    final response = await datasource.getListInvoicesByStatus(event.status);

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

  FutureOr<void> _onToEditDataInvoice(
      _EditDataInvoice event, Emitter<InvoiceState> emit) async {
    final response =
        await datasource.updateInvoices(data: event.data, id: event.id);
    response.fold(
      (errorMessage) => emit(InvoiceState.error(errorMessage)),
      (invoice) {
        emit(InvoiceState.loadedEdit(invoice));
      },
    );
  }
}
