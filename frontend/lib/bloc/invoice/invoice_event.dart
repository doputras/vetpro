part of 'invoice_bloc.dart';

@freezed
class InvoiceEvent with _$InvoiceEvent {
  const factory InvoiceEvent.started() = _Started;
  const factory InvoiceEvent.fetchDataInvoiceEvent() = _GetListInvoice;
  const factory InvoiceEvent.fetchDataInvoiceByStatusEvent(String status) =
      _GetListInvoiceByStatus;
  const factory InvoiceEvent.addDataInvoiceEvent(
      AddInvoiceModel addInvoicesData) = _AddDataInvoice;
  const factory InvoiceEvent.editDataInvoiceEvent(
      {required EditInvoiceModel data, required String id}) = _EditDataInvoice;
  const factory InvoiceEvent.getInvoiceById(String id) = _GetInvoiceById;
}
