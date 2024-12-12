import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:vetpro/data/models/invoices_model.dart';

class InvoicesRemoteDatasource {
  final String apiUrl = "http://192.168.0.100:8000/api/invoices";

  Future<Either<String, InvoiceModel>> addInvoices(InvoiceModel data) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode(data.toJson()), // Using toJson if available
      );

      if (response.statusCode == 201) {
        var jsonData = json.decode(response.body);
        InvoiceModel invoices = InvoiceModel.fromJson(jsonData);
        return right(invoices);
      } else {
        return left('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      return left('An exception occurred: $e');
    }
  }

  Future<Either<String, List<InvoiceModel>>> getListInvoices() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List;
        List<InvoiceModel> invoices =
            jsonData.map((invoice) => InvoiceModel.fromJson(invoice)).toList();
        return right(invoices);
      } else {
        return left(
            'Failed to load Invoicess with status code: ${response.statusCode}');
      }
    } catch (e) {
      return left('Exception when fetching data: $e');
    }
  }

  Future<Either<String, InvoiceModel>> updateInvoices(InvoiceModel data) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${data.id}'), // Ensure ID is part of the model
        headers: {"Content-Type": "application/json"},
        body: json.encode(data.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Right(InvoiceModel.fromJson(jsonData));
      } else {
        return Left('Failed to update Invoices: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Error updating Invoices: $e');
    }
  }

  // Delete Invoices by ID
  Future<Either<String, String>> deleteInvoices(int invoicesId) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$invoicesId'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return const Right('Invoices deleted successfully');
      } else {
        return Left('Failed to delete Invoices: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Error deleting Invoices: $e');
    }
  }
}
