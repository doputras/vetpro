part of 'inspection_invoice_bloc.dart';

@freezed
class InspectionInvoiceEvent with _$InspectionInvoiceEvent {
  const factory InspectionInvoiceEvent.started() = _Started;
  const factory InspectionInvoiceEvent.addToListInvoice(
      InspectionModel data, String status) = _AddToListInvoice;
}
