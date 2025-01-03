import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:vetpro/common/constants/global_variables.dart';
import 'package:vetpro/data/datasources/auth_local_datasource.dart';
import 'package:vetpro/data/models/add_invoice_model.dart';
import 'package:vetpro/data/models/edit_invoice_model.dart';
import 'package:vetpro/data/models/invoices_model.dart';

class InvoicesRemoteDatasource {
  final String apiUrl = "${GlobalVariables.baseUrl}api/invoices";

  Future<Either<String, InvoiceModel>> addInvoices(AddInvoiceModel data) async {
    try {
      final userId = await AuthLocalDatasource().getId();
      data.userId = int.tryParse(userId ?? '0') ?? 0;
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode(data.toJson()),
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

// For Admin
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

  Future<Either<String, List<InvoiceModel>>> getListInvoicesByStatus(
      String status) async {
    try {
      final response = await http.get(
        Uri.parse("$apiUrl/status/$status"),
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

// For Detail
  Future<Either<String, InvoiceModel>> getInvoicesById(String id) async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl + "/$id"),
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        InvoiceModel invoices = InvoiceModel.fromJson(jsonData);
        return right(invoices);
      } else {
        return left(
            'Failed to load Invoicess with status code: ${response.statusCode}');
      }
    } catch (e) {
      return left('Exception when fetching data: $e');
    }
  }

//For User
  Future<Either<String, List<InvoiceModel>>> getInvoicesByUserID() async {
    try {
      final userId = await AuthLocalDatasource().getId();
      final response = await http.get(
        Uri.parse(apiUrl + "/users/$userId"),
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List;
        List<InvoiceModel> invoices =
            jsonData.map((invoice) => InvoiceModel.fromJson(invoice)).toList();
        return right(invoices);
      } else if (response.statusCode == 404) {
        return right([]);
      } else {
        return left(
            'Failed to load Invoicess with status code: ${response.statusCode}');
      }
    } catch (e) {
      return left('Exception when fetching data: $e');
    }
  }

  Future<Either<String, InvoiceModel>> updateInvoices(
      {required EditInvoiceModel data, required String id}) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${id}'), // Ensure ID is part of the model
        headers: {"Content-Type": "application/json"},
        body: data.toRawJson(),
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
