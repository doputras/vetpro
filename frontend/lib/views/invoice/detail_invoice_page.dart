import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vetpro/bloc/invoice/invoice_bloc.dart';
import 'package:vetpro/views/invoice/screen/add_and_detail_invoice.dart';

class DetailInvoicePage extends StatelessWidget {
  const DetailInvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    var idInvoice = 0;
    if (Get.arguments['id'] != null) {
      idInvoice = Get.arguments['id'] as int;
      context
          .read<InvoiceBloc>()
          .add(InvoiceEvent.getInvoiceById("$idInvoice"));
    }
    return BlocBuilder<InvoiceBloc, InvoiceState>(
      builder: (context, state) {
        return state.maybeWhen(
            orElse: () {
              return Container();
            },
            loadedById: (invoice) {
              return AddAndDetailInvoice(
                typePage: 'Detail',
                invoice: invoice,
                idInvoice: idInvoice,
              );
            },
            error: (message) => Container());
      },
    );
  }
}
