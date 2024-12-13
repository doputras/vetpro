import 'dart:convert';

import 'package:vetpro/data/models/invoices_model.dart';

class AddInvoiceModel {
  DateTime? tanggal;
  String? pemeriksa;
  String? status;
  List<DataInvoiceModel>? details;

  AddInvoiceModel({
    this.tanggal,
    this.pemeriksa,
    this.status,
    this.details,
  });

  factory AddInvoiceModel.fromRawJson(String str) =>
      AddInvoiceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddInvoiceModel.fromJson(Map<String, dynamic> json) =>
      AddInvoiceModel(
        tanggal:
            json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
        pemeriksa: json["pemeriksa"],
        status: json["status"],
        details: json["details"] == null
            ? []
            : List<DataInvoiceModel>.from(
                json["details"]!.map((x) => DataInvoiceModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tanggal":
            "${tanggal!.year.toString().padLeft(4, '0')}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}",
        "pemeriksa": pemeriksa,
        "status": status,
        "details": details == null
            ? []
            : List<dynamic>.from(details!.map((x) => x.toJson())),
      };
}
