import 'dart:convert';

class EditInvoiceModel {
    DateTime? tanggal;
    String? pemeriksa;
    String? status;
    List<Detail>? details;

    EditInvoiceModel({
        this.tanggal,
        this.pemeriksa,
        this.status,
        this.details,
    });

    factory EditInvoiceModel.fromRawJson(String str) => EditInvoiceModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory EditInvoiceModel.fromJson(Map<String, dynamic> json) => EditInvoiceModel(
        tanggal: json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
        pemeriksa: json["pemeriksa"],
        status: json["status"],
        details: json["details"] == null ? [] : List<Detail>.from(json["details"]!.map((x) => Detail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "tanggal": "${tanggal!.year.toString().padLeft(4, '0')}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}",
        "pemeriksa": pemeriksa,
        "status": status,
        "details": details == null ? [] : List<dynamic>.from(details!.map((x) => x.toJson())),
    };
}

class Detail {
    String? description;
    int? price;
    int? quantity;
    int? total;

    Detail({
        this.description,
        this.price,
        this.quantity,
        this.total,
    });

    factory Detail.fromRawJson(String str) => Detail.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        description: json["description"],
        price: json["price"],
        quantity: json["quantity"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "description": description,
        "price": price,
        "quantity": quantity,
        "total": total,
    };
}
