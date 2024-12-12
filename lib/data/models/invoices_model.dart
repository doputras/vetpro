import 'dart:convert';

import 'package:equatable/equatable.dart';

class InvoiceModel extends Equatable {
  final int? id;
  final DateTime? tanggal;
  final String? pemeriksa;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<DataInvoiceModel>? details;

  InvoiceModel({
    this.id,
    this.tanggal,
    this.pemeriksa,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.details,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [details];

  factory InvoiceModel.fromRawJson(String str) =>
      InvoiceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json["id"],
        tanggal:
            json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
        pemeriksa: json["pemeriksa"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        details: json["details"] == null
            ? []
            : List<DataInvoiceModel>.from(
                json["details"]!.map((x) => DataInvoiceModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tanggal":
            "${tanggal!.year.toString().padLeft(4, '0')}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}",
        "pemeriksa": pemeriksa,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "details": details == null
            ? []
            : List<dynamic>.from(details!.map((x) => x.toJson())),
      };
}

class DataInvoiceModel {
  final int? id;
  final int? invoiceId;
  final String? description;
  final String? price;
  final int? quantity;
  final String? total;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DataInvoiceModel({
    this.id,
    this.invoiceId,
    this.description,
    this.price,
    this.quantity,
    this.total,
    this.createdAt,
    this.updatedAt,
  });

  factory DataInvoiceModel.fromRawJson(String str) =>
      DataInvoiceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataInvoiceModel.fromJson(Map<String, dynamic> json) =>
      DataInvoiceModel(
        id: json["id"],
        invoiceId: json["invoice_id"],
        description: json["description"],
        price: json["price"],
        quantity: json["quantity"],
        total: json["total"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_id": invoiceId,
        "description": description,
        "price": price,
        "quantity": quantity,
        "total": total,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
