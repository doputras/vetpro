import 'package:flutter_test/flutter_test.dart';
import 'package:vetpro/common/components/species.dart';
import 'package:vetpro/common/extensions/format_ext.dart';
import 'package:vetpro/data/models/invoices_model.dart';
import 'package:vetpro/views/invoice/invoice_page.dart';

void main() {
  test('species lookup is case-insensitive and falls back to Lainnya', () {
    expect(speciesFor('domba ').name, 'Domba');
    expect(speciesFor('Kambing').name, 'Lainnya');
    expect(speciesFor(null).name, 'Lainnya');
  });

  test('API amounts parse without float drift', () {
    expect(parseAmount('150000.00'), 150000);
    expect(parseAmount('75000'), 75000);
    expect(parseAmount(null), 0);
    expect(parseAmount('abc'), 0);
  });

  test('invoice total sums line totals and formats as rupiah', () {
    final invoice = InvoiceModel(details: [
      DataInvoiceModel(total: '225000.00'),
      DataInvoiceModel(total: '50000.00'),
    ]);
    expect(invoiceTotal(invoice), 275000);
    expect(invoiceTotal(InvoiceModel()), 0);
    expect(275000.toRupiah().replaceAll(' ', ' '), 'Rp275.000');
  });
}
