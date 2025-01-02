// ignore_for_file: unused_import, prefer_const_constructors

import 'dart:io';

import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:vetpro/data/models/invoices_model.dart';
import 'package:vetpro/views/invoice/generation_pdf/pdf_api.dart';

class PdfInvoiceApi {
  static Future<File> generate({
    required String companyName,
    required List<DataInvoiceModel>? items,
    required String subTotal,
    required String tax,
  }) async {
    final pdf = Document();

    pdf.addPage(
      MultiPage(
        build: (context) => [
          buildTitle(companyName: companyName),
          buildCardInvoice(amountDue: {'sub_total': subTotal, 'tax': tax}),
          buildListInvoice(items: items),
          buildBottom(subTotal: subTotal, tax: tax),
          Spacer(),
          buildFooter(),
        ],
      ),
    );

    return PdfApi.saveDocument(name: 'invoice.pdf', pdf: pdf);
  }

  static Widget buildTitle({required String companyName}) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(children: [
            Text('I N V O I C E',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(width: 0.2 * PdfPageFormat.cm),
            Expanded(child: Divider())
          ]),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text('BILL TO:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          _buildTextLeftAndRight(
            left: 'PT', //Your Company Name
            right: 'Company Name',
            fontWeightleft: FontWeight.bold,
            fontWeightRight: FontWeight.bold,
            fontSizeleft: 20,
            fontSizeRight: 18,
          ),
          _buildTextLeftAndRight(
            left: 'Your Bussines Addres',
            right: 'Addres',
          ),
          _buildTextLeftAndRight(left: 'City', right: 'City'),
          _buildTextLeftAndRight(left: 'Country', right: 'Country'),
          _buildTextLeftAndRight(left: 'Postal', right: 'Postal'),
          Divider(),
        ],
      );

  static Row _buildTextLeftAndRight({
    required String left,
    required String right,
    double fontSizeleft = 12,
    FontWeight fontWeightleft = FontWeight.normal,
    double fontSizeRight = 12,
    FontWeight fontWeightRight = FontWeight.normal,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: TextStyle(
            fontSize: fontSizeleft,
            fontWeight: fontWeightleft,
          ),
        ),
        Text(
          right,
          style: TextStyle(
            fontSize: fontSizeRight,
            fontWeight: fontWeightRight,
          ),
        ),
      ],
    );
  }

  static Widget buildCardInvoice({Map<String, dynamic>? amountDue}) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _buildContaintCardInvoice(
          title: 'INVOICE #',
          subTitle: '12312321',
        ),
        _buildContaintCardInvoice(
          title: 'DATE',
          subTitle: '12/31/20',
        ),
        _buildContaintCardInvoice(
          title: 'INVOICE DUE DATE',
          subTitle: '12/31/20',
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
      Divider(),
    ]);
  }

  static Column _buildContaintCardInvoice(
      {required String title, required String subTitle}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        subTitle,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ]);
  }

  static Widget buildListInvoice({required List<DataInvoiceModel>? items}) {
    return Column(children: [
      _buildContaintListInvoice(
        isHeader: true,
        item: "ITEMS",
        description: "DESCRIPTION",
        quantity: "QTY",
        price: "PRICE",
        amount: "AMOUNT",
        fontWeight: FontWeight.bold,
      ),
      ListView.builder(
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
      Divider(),
    ]);
  }

  static Table _buildContaintListInvoice({
    required String item,
    required String description,
    required String quantity,
    required String price,
    required String amount,
    bool isHeader = false,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(4),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(4),
        4: FlexColumnWidth(4),
      },
      // border: TableBorder.all(color: Colors.grey, width: 0.5),

      children: [
        TableRow(
          children: [
            _buildCell(item, isHeader: isHeader),
            _buildCell(description, isHeader: isHeader),
            _buildCell(quantity,
                isHeader: isHeader,
                textAlign: isHeader ? TextAlign.left : TextAlign.center),
            _buildCell(price,
                isHeader: isHeader,
                textAlign: isHeader ? TextAlign.left : TextAlign.right),
            _buildCell(amount,
                isHeader: isHeader,
                textAlign: isHeader ? TextAlign.left : TextAlign.right),
          ],
        ),
      ],
    );
  }

  static Widget _buildCell(
    String text, {
    bool isHeader = false,
    TextAlign textAlign = TextAlign.left,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  static Widget buildBottom({required String subTotal, required String tax}) {
    return Column(children: [
      Row(children: [
        Flexible(child: _buildMessageBottom(), flex: 2),
        Flexible(
            child: Column(children: [
              _buildTextLeftAndRight(
                left: 'Subtotal',
                right: NumberFormat.currency(
                        locale: 'id', symbol: 'Rp', decimalDigits: 0)
                    .format(
                  int.parse(subTotal.split('.')[0]),
                ),
                fontWeightleft: FontWeight.bold,
              ),
              _buildTextLeftAndRight(
                left: 'tax',
                fontWeightleft: FontWeight.bold,
                right: NumberFormat.currency(
                        locale: 'id', symbol: 'Rp', decimalDigits: 0)
                    .format(
                  int.parse(tax.split('.')[0]),
                ),
              ),
              Divider(),
              _buildTextLeftAndRight(
                left: 'Total',
                fontWeightleft: FontWeight.bold,
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('NOTES:', style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
      Text(
        'LOREM IPSUM DOLOR SIT AMET CONSECTETUR ADIPISICING ELIT SED DO EIUSMOD TEMPOR INCIDIDUNT UT LABORE ET DOLORE MAGNA ALIQUA',
        style: TextStyle(fontSize: 10),
      ),
    ]);
  }

  static buildFooter() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('Your Company Name'),
      Text('Company Name'),
    ]);
  }
}
