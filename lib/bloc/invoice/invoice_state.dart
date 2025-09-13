part of 'invoice_bloc.dart';

@freezed
class InvoiceState with _$InvoiceState {
  const factory InvoiceState.initial() = _Initial;
  const factory InvoiceState.loading() = _Loading;
  const factory InvoiceState.loaded(List<InvoiceModel> items) = _Loaded;
  const factory InvoiceState.loadedByStatus(List<InvoiceModel> items) =
      _LoadedByStatus;
  const factory InvoiceState.loadedById(InvoiceModel item) = _LoadedById;
  const factory InvoiceState.loadedAdd(InvoiceModel item) = _LoadedAdd;
  const factory InvoiceState.loadedEdit(InvoiceModel item) = _LoadedEdit;
  const factory InvoiceState.error(String message) = _Error;
}
