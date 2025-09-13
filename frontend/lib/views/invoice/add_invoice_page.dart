import 'package:flutter/material.dart';
import 'package:vetpro/views/invoice/screen/add_and_detail_invoice.dart';

class AddInvoicePage extends StatelessWidget {
  const AddInvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AddAndDetailInvoice(
      typePage: 'Add',
    );
  }
}
