// ignore_for_file: unused_import, prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vetpro/data/models/invoices_model.dart';
import 'package:vetpro/views/invoice/generation_pdf/pdf_api.dart';

class PdfInvoiceApi {
  static Future<File> generate({
    required String userName,
    required List<DataInvoiceModel>? items,
    required String subTotal,
    required String tax,
    required String invoiceId,
    required String invoiceDate,
  }) async {
    final pdf = pw.Document();

    final imageLogo = pw.MemoryImage(
      (await rootBundle.load('assets/logo-telkom2.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          buildHeader(imageLogo),
          buildTitle(companyName: userName),
          buildCardInvoice(
            amountDue: {'sub_total': subTotal, 'tax': tax},
            invoiceId: invoiceId,
            invoiceDate: invoiceDate,
          ),
          buildListInvoice(items: items),
          buildBottom(subTotal: subTotal, tax: tax),
          pw.Spacer(),
          buildFooter(),
        ],
      ),
    );

    return PdfApi.saveDocument(name: 'invoice.pdf', pdf: pdf);
  }

  static pw.Widget buildHeader(pw.MemoryImage imageLogo,) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Image(imageLogo, width: 100, height: 100),
                  pw.SizedBox(height: 8),
                ],
              ),
              pw.Text('I N V O I C E',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ],
          ),
          pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static pw.Widget buildTitle({required String companyName}) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
          _buildTextLeftAndRight(
            left: 'Bill from:',
            right: 'BILL TO:',
            fontSizeleft: 12,
            fontSizeRight: 12,
            fontWeightleft: pw.FontWeight.bold,
            fontWeightRight: pw.FontWeight.bold,
          ),
          _buildTextLeftAndRight(
            left: companyName,
            right: 'Telkom University',
            fontWeightleft: pw.FontWeight.bold,
            fontWeightRight: pw.FontWeight.bold,
            fontSizeleft: 20,
            fontSizeRight: 18,
          ),
          _buildTextLeftAndRight(
            left: '',
            right: 'Jl. Telekomunikasi No. 1, \nTerusan Buahbatu - Bojongsoang, Kec. Dayeuhkolot',
          ),
          _buildTextLeftAndRight(left: '', right: 'Bandung'),
          _buildTextLeftAndRight(left: '', right: 'Indonesia'),
          _buildTextLeftAndRight(left: '', right: '40257'),
          pw.Divider(),
        ],
      );

  static pw.Row _buildTextLeftAndRight({
    required String left,
    required String right,
    double fontSizeleft = 12,
    pw.FontWeight fontWeightleft = pw.FontWeight.normal,
    double fontSizeRight = 12,
    pw.FontWeight fontWeightRight = pw.FontWeight.normal,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          left,
          style: pw.TextStyle(
            fontSize: fontSizeleft,
            fontWeight: fontWeightleft,
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            right,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(
              fontSize: fontSizeRight,
              fontWeight: fontWeightRight,
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget buildCardInvoice({
    required Map<String, dynamic>? amountDue,
    required String invoiceId,
    required String invoiceDate,
  }) {
    return pw.Column(children: [
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        _buildContaintCardInvoice(
          title: 'INVOICE #',
          subTitle: invoiceId,
        ),
        _buildContaintCardInvoice(
          title: 'DATE',
          subTitle: invoiceDate,
        ),
        _buildContaintCardInvoice(
          title: 'AMOUNT DUE',
          subTitle: NumberFormat.currency(
                  locale: 'id', symbol: 'Rp', decimalDigits: 0)
              .format(
            int.parse(amountDue?['sub_total'].split('.')[0]) +
                int.parse(amountDue?['tax'].split('.')[0]),
          ),
        ),
      ]),
      pw.Divider(),
    ]);
  }

  static pw.Column _buildContaintCardInvoice(
      {required String title, required String subTitle}) {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
      pw.Text(
        title,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      pw.Text(
        subTitle,
        style: pw.TextStyle(
          fontSize: 18,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    ]);
  }

  static pw.Widget buildListInvoice({required List<DataInvoiceModel>? items}) {
    return pw.Column(children: [
      _buildContaintListInvoice(
        isHeader: true,
        item: "ITEMS",
        description: "DESCRIPTION",
        quantity: "QTY",
        price: "PRICE",
        amount: "AMOUNT",
        fontWeight: pw.FontWeight.bold,
      ),
      pw.ListView.builder(
          itemBuilder: (context, index) {
            final result = items[index];
            return _buildContaintListInvoice(
                item: "${index + 1}",
                description: result.description.toString(),
                quantity: result.quantity.toString(),
                price: NumberFormat.currency(
                        locale: 'id', symbol: 'Rp', decimalDigits: 0)
                    .format(int.parse(result.price?.split('.')[0] ?? '0')),
                amount: NumberFormat.currency(
                        locale: 'id', symbol: 'Rp', decimalDigits: 0)
                    .format(int.parse(result.total?.split('.')[0] ?? '0')));
          },
          itemCount: items!.length),
      pw.Divider(),
    ]);
  }

  static pw.Table _buildContaintListInvoice({
    required String item,
    required String description,
    required String quantity,
    required String price,
    required String amount,
    bool isHeader = false,
    pw.FontWeight fontWeight = pw.FontWeight.normal,
  }) {
    return pw.Table(
      columnWidths: const {
        0: pw.FlexColumnWidth(2),
        1: pw.FlexColumnWidth(4),
        2: pw.FlexColumnWidth(2),
        3: pw.FlexColumnWidth(4),
        4: pw.FlexColumnWidth(4),
      },
      // border: TableBorder.all(color: Colors.grey, width: 0.5),

      children: [
        pw.TableRow(
          children: [
            _buildCell(item, isHeader: isHeader),
            _buildCell(description, isHeader: isHeader),
            _buildCell(quantity,
                isHeader: isHeader,
                textAlign: isHeader ? pw.TextAlign.left : pw.TextAlign.center),
            _buildCell(price,
                isHeader: isHeader,
                textAlign: isHeader ? pw.TextAlign.left : pw.TextAlign.right),
            _buildCell(amount,
                isHeader: isHeader,
                textAlign: isHeader ? pw.TextAlign.left : pw.TextAlign.right),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildCell(
    String text, {
    bool isHeader = false,
    pw.TextAlign textAlign = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8.0),
      child: pw.Text(
        text,
        textAlign: textAlign,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static pw.Widget buildBottom({required String subTotal, required String tax}) {
    return pw.Column(children: [
      pw.Row(children: [
        pw.Flexible(child: _buildMessageBottom(), flex: 2),
        pw.Flexible(
            child: pw.Column(children: [
              _buildTextLeftAndRight(
                left: 'Subtotal',
                right: NumberFormat.currency(
                        locale: 'id', symbol: 'Rp', decimalDigits: 0)
                    .format(
                  int.parse(subTotal.split('.')[0]),
                ),
                fontWeightleft: pw.FontWeight.bold,
              ),
              _buildTextLeftAndRight(
                left: 'tax',
                fontWeightleft: pw.FontWeight.bold,
                right: NumberFormat.currency(
                        locale: 'id', symbol: 'Rp', decimalDigits: 0)
                    .format(
                  int.parse(tax.split('.')[0]),
                ),
              ),
              pw.Divider(),
              _buildTextLeftAndRight(
                left: 'Total',
                fontWeightleft: pw.FontWeight.bold,
                right: NumberFormat.currency(
                        locale: 'id', symbol: 'Rp', decimalDigits: 0)
                    .format(
                  int.parse(subTotal.split('.')[0]) +
                      int.parse(tax.split('.')[0]),
                ),
              ),
            ]),
            flex: 1),
      ]),
    ]);
  }

  static _buildMessageBottom() {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text('NOTES:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
      pw.Text(
        'LOREM IPSUM DOLOR SIT AMET CONSECTETUR ADIPISICING ELIT SED DO EIUSMOD TEMPOR INCIDIDUNT UT LABORE ET DOLORE MAGNA ALIQUA',
        style: pw.TextStyle(fontSize: 10),
      ),
    ]);
  }

  static buildFooter() {
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      pw.Text(''),
      pw.Text('Telkom University'),
    ]);
  }
}
