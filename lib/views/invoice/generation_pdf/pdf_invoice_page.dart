import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vetpro/views/invoice/generation_pdf/pdf_api.dart';
import 'package:vetpro/views/invoice/generation_pdf/pdf_invoice_api.dart';

class PdfExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final pdfFile = await PdfInvoiceApi.generate();
            PdfApi.openFile(pdfFile);
          },
          child: Text('Generate PDF'),
        ),
      ),
    );
  }
}
