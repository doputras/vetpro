// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'inspection_invoice_bloc.dart';

@freezed
class InspectionInvoiceState with _$InspectionInvoiceState {
  const factory InspectionInvoiceState.loaded(List<InspectionInvoice> items) =
      _Loaded;
  const factory InspectionInvoiceState.loading() = _Loading;
}

class InspectionInvoice {
  final InspectionModel inspectionModel;
  final String status;
  InspectionInvoice({
    required this.inspectionModel,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'inspectionModel': inspectionModel.toJson(),
      'status': status,
    };
  }

  factory InspectionInvoice.fromJson(Map<String, dynamic> json) {
    return InspectionInvoice(
      inspectionModel: InspectionModel.fromJson(json['inspectionModel']),
      status: json['status'],
    );
  }
}
