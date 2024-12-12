part of 'invoice_bloc.dart';

@freezed
class InvoiceEvent with _$InvoiceEvent {
  const factory InvoiceEvent.started() = _Started;
  const factory InvoiceEvent.fetchDataInvoiceEvent() = _GetListInvoice;
  const factory InvoiceEvent.fetchDataById(String id) = _GetInvoiceById;
}
